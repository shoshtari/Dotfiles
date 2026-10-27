--[[
  Circuit-board HUD for conky (Wayland).
  Everything is drawn with cairo: a big clock, a "bus" line with icon
  nodes that branch out to stat blocks, and ring gauges top-right.
  Layout is designed for 1920x1080 and scaled to the real window size;
  blocks are placed in the dark areas of the leaves wallpaper.
]]

require 'cairo'

-- palette (matches waybar / hyprlock)
local ORANGE = 0xff9e4a
local GLOW   = 0xffd29a
local STEEL  = 0x8aa0d8
local DIM    = 0x3c4566
local LABEL  = 0x6c7698
local TEXT   = 0xcdd6f4
local DARK   = 0x1e1e2e
local RED    = 0xf38ba8

local SOFT = "Comfortaa"
local MONO = "CaskaydiaCove Nerd Font Mono"

local TODO_FILE = os.getenv("HOME") .. "/.config/conky/todo.txt"

-- icons (Nerd Font)
local ICON_USER  = "\u{F007}"
local ICON_LAN   = "\u{F0318}"
local ICON_WIFI  = "\u{F05A9}"
local ICON_DISK  = "\u{F02CA}"
local ICON_CHIP  = "\u{F061A}"

local NODE_R    = 36
local ICON_SIZE = 40

---------------------------------------------------------------- helpers

local function color(cr, hex, a)
    cairo_set_source_rgba(cr, ((hex >> 16) & 255) / 255, ((hex >> 8) & 255) / 255,
                          (hex & 255) / 255, a or 1)
end

local function parse(s) return conky_parse(s) or "" end
local function num(s) return tonumber(parse(s)) or 0 end

local function text(cr, str, x, y, opts)
    opts = opts or {}
    cairo_select_font_face(cr, opts.font or MONO, CAIRO_FONT_SLANT_NORMAL,
                           opts.bold and CAIRO_FONT_WEIGHT_BOLD or CAIRO_FONT_WEIGHT_NORMAL)
    cairo_set_font_size(cr, opts.size or 14)
    local ext = cairo_text_extents_t:create()
    tolua.takeownership(ext)
    cairo_text_extents(cr, str, ext)
    if opts.align == "center" then
        x = x - ext.x_advance / 2
    elseif opts.align == "right" then
        x = x - ext.x_advance
    end
    if opts.vcenter then
        y = y - (ext.height / 2 + ext.y_bearing)
    end
    if opts.glow then
        color(cr, opts.color or TEXT, 0.18)
        for _, d in ipairs({ {-2, 0}, {2, 0}, {0, -2}, {0, 2} }) do
            cairo_move_to(cr, x + d[1], y + d[2])
            cairo_show_text(cr, str)
        end
    end
    color(cr, opts.color or TEXT, opts.alpha or 1)
    cairo_move_to(cr, x, y)
    cairo_show_text(cr, str)
end

-- polyline with a soft glow underneath
local function wire(cr, pts, hex, alpha)
    for pass = 1, 2 do
        cairo_move_to(cr, pts[1][1], pts[1][2])
        for i = 2, #pts do cairo_line_to(cr, pts[i][1], pts[i][2]) end
        if pass == 1 then
            color(cr, hex, (alpha or 1) * 0.15)
            cairo_set_line_width(cr, 6)
        else
            color(cr, hex, alpha or 1)
            cairo_set_line_width(cr, 1.6)
        end
        cairo_stroke(cr)
    end
end

local function dot(cr, x, y, r, hex)
    color(cr, hex, 1)
    cairo_arc(cr, x, y, r, 0, 2 * math.pi)
    cairo_fill(cr)
end

-- circular node with an icon in the middle
local function node(cr, x, y, icon)
    color(cr, DARK, 0.75)
    cairo_arc(cr, x, y, NODE_R, 0, 2 * math.pi)
    cairo_fill(cr)
    color(cr, STEEL, 0.2)
    cairo_set_line_width(cr, 8)
    cairo_arc(cr, x, y, NODE_R, 0, 2 * math.pi)
    cairo_stroke(cr)
    color(cr, STEEL, 1)
    cairo_set_line_width(cr, 2)
    cairo_arc(cr, x, y, NODE_R, 0, 2 * math.pi)
    cairo_stroke(cr)
    text(cr, icon, x, y, { font = MONO, size = ICON_SIZE, color = ORANGE, align = "center", vcenter = true })
end

-- thin progress bar
local function bar(cr, x, y, w, pct, hex)
    color(cr, DIM, 0.8)
    cairo_rectangle(cr, x, y, w, 3)
    cairo_fill(cr)
    color(cr, hex, 1)
    cairo_rectangle(cr, x, y, w * math.min(math.max(pct, 0), 100) / 100, 3)
    cairo_fill(cr)
end

-- 270° ring gauge; the open quarter (top-left) holds the label
local function ring(cr, cx, cy, r, pct, hex, label, value)
    local start = -math.pi / 2
    local sweep = 1.5 * math.pi
    cairo_set_line_width(cr, 7)
    color(cr, DIM, 0.55)
    cairo_arc(cr, cx, cy, r, start, start + sweep)
    cairo_stroke(cr)
    local stop = start + sweep * math.min(math.max(pct, 0), 100) / 100
    color(cr, hex, 0.25)
    cairo_set_line_width(cr, 13)
    cairo_arc(cr, cx, cy, r, start, stop)
    cairo_stroke(cr)
    color(cr, hex, 1)
    cairo_set_line_width(cr, 7)
    cairo_arc(cr, cx, cy, r, start, stop)
    cairo_stroke(cr)
    text(cr, label .. "  " .. value, cx - 12, cy - r + 5,
         { font = SOFT, size = 13, bold = true, color = hex, align = "right" })
end

-- small header above a stat block
local function heading(cr, str, x, y)
    text(cr, str, x, y, { font = SOFT, size = 15, bold = true, color = ORANGE })
end

-- node on the bus with its stat block hanging above ("up") or below ("down")
local function branch(cr, x, bus_y, icon, dir, len)
    local s = dir == "up" and -1 or 1
    local y = bus_y + s * 70
    wire(cr, { { x, bus_y + s * NODE_R }, { x, y }, { x + len, y } }, STEEL, 0.9)
    dot(cr, x + len, y, 3, STEEL)
    node(cr, x, bus_y, icon)
    -- first text baseline of the block
    return dir == "up" and y - 78 or y + 26
end

local function read_todo()
    local items = {}
    local f = io.open(TODO_FILE, "r")
    if not f then return items end
    for line in f:lines() do
        if line:match("%S") and #items < 8 then items[#items + 1] = line end
    end
    f:close()
    return items
end

---------------------------------------------------------------- main

function conky_main()
    if conky_window == nil then return end
    local surface = conky_surface()
    if surface == nil then return end
    if tonumber(parse("${updates}")) < 2 then return end

    local cr = cairo_create(surface)
    local sx = conky_window.width / 1920
    local sy = conky_window.height / 1080
    local s = math.min(sx, sy)
    cairo_scale(cr, s, s)
    cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND)
    cairo_set_line_join(cr, CAIRO_LINE_JOIN_ROUND)

    ---- clock (dark sky above the top leaf)
    text(cr, os.date("%H:%M"), 960, 205,
         { font = SOFT, size = 150, bold = true, color = ORANGE, align = "center", glow = true })
    text(cr, os.date("%a, %d %b"), 960, 258,
         { font = SOFT, size = 36, color = STEEL, align = "center" })

    ---- main bus (dark band under the branch)
    local BUS_Y = 870
    local TERM_X = 1760
    wire(cr, { { 330, BUS_Y }, { TERM_X - 30, BUS_Y } }, STEEL, 0.9)
    dot(cr, 330, BUS_Y, 4, STEEL)

    ---- system (down)
    local x = 470
    local y = branch(cr, x, BUS_Y, ICON_USER, "down", 230)
    heading(cr, "system", x + 14, y)
    text(cr, parse("${uid_name 1000}@${nodename}"), x + 14, y + 22, { size = 14, color = TEXT })
    text(cr, "kernel  " .. parse("${kernel}"), x + 14, y + 42, { size = 13, color = LABEL })
    text(cr, "uptime  " .. parse("${uptime_short}"), x + 14, y + 62, { size = 13, color = LABEL })

    ---- network (down)
    x = 820
    local iface = parse("${if_up eno2}eno2${else}wlo1${endif}")
    local online = parse("${if_up " .. iface .. "}1${else}0${endif}") == "1"
    y = branch(cr, x, BUS_Y, iface == "eno2" and ICON_LAN or ICON_WIFI, "down", 230)
    heading(cr, "network  " .. iface, x + 14, y)
    if online then
        text(cr, parse("${addr " .. iface .. "}"), x + 14, y + 22, { size = 14, color = TEXT })
        text(cr, "down  " .. parse("${downspeed " .. iface .. "}"), x + 14, y + 42, { size = 13, color = GLOW })
        text(cr, "up    " .. parse("${upspeed " .. iface .. "}"), x + 14, y + 62, { size = 13, color = STEEL })
    else
        text(cr, "offline", x + 14, y + 22, { size = 14, color = RED })
    end

    ---- storage (up)
    x = 1130
    y = branch(cr, x, BUS_Y, ICON_DISK, "up", 230)
    heading(cr, "storage  " .. parse("${hwmon nvme temp 1}") .. "°C", x + 14, y)
    local rows = {
        { "root", "${fs_used /}", "${fs_size /}", num("${fs_used_perc /}"), ORANGE },
        { "home", "${fs_used /home}", "${fs_size /home}", num("${fs_used_perc /home}"), ORANGE },
        { "swap", "${swap}", "${swapmax}", num("${swapperc}"), STEEL },
    }
    for i, r in ipairs(rows) do
        local ry = y + i * 20
        text(cr, string.format("%-5s %s / %s", r[1], parse(r[2]), parse(r[3])), x + 14, ry,
             { size = 13, color = i == 1 and TEXT or LABEL })
        bar(cr, x + 14, ry + 4, 190, r[4], r[5])
    end

    ---- processes (up)
    x = 1450
    y = branch(cr, x, BUS_Y, ICON_CHIP, "up", 230)
    heading(cr, "processes  " .. parse("${running_processes}") .. "/" .. parse("${processes}"), x + 14, y)
    for i = 1, 3 do
        local py = y + i * 20
        text(cr, parse("${top name " .. i .. "}"), x + 14, py, { size = 13, color = i == 1 and TEXT or LABEL })
        text(cr, parse("${top cpu " .. i .. "}") .. "%", x + 224, py, { size = 13, color = ORANGE, align = "right" })
    end

    ---- ring gauges (top-right corner, above the branch tip)
    local cx, cy = TERM_X, 190
    ring(cr, cx, cy, 100, num("${cpu cpu0}"), ORANGE, "cpu", parse("${cpu cpu0}") .. "%")
    ring(cr, cx, cy, 83, num("${memperc}"), GLOW, "ram", parse("${memperc}") .. "%")
    ring(cr, cx, cy, 66, num("${fs_used_perc /}"), STEEL, "disk", parse("${fs_used_perc /}") .. "%")
    ring(cr, cx, cy, 49, num("${battery_percent BAT0}"), TEXT, "bat", parse("${battery_percent BAT0}") .. "%")
    text(cr, parse("${hwmon coretemp temp 1}") .. "°", cx, cy,
         { font = SOFT, size = 26, bold = true, color = num("${hwmon coretemp temp 1}") > 80 and RED or GLOW,
           align = "center", vcenter = true })

    ---- bus terminal: seconds ring, wired straight up to the gauges
    wire(cr, { { TERM_X, BUS_Y - 30 }, { TERM_X, cy + 112 } }, STEEL, 0.9)
    dot(cr, TERM_X, cy + 112, 4, STEEL)
    color(cr, DARK, 0.75)
    cairo_arc(cr, TERM_X, BUS_Y, 20, 0, 2 * math.pi)
    cairo_fill(cr)
    cairo_set_line_width(cr, 5)
    color(cr, STEEL, 1)
    cairo_arc(cr, TERM_X, BUS_Y, 20, 0, 2 * math.pi)
    cairo_stroke(cr)
    local sec = tonumber(os.date("%S"))
    cairo_set_line_width(cr, 3)
    color(cr, ORANGE, 1)
    cairo_arc(cr, TERM_X, BUS_Y, 30, -math.pi / 2, -math.pi / 2 + 2 * math.pi * sec / 60)
    cairo_stroke(cr)

    ---- tasks (top-left, dark sky)
    local todo = read_todo()
    if #todo > 0 then
        heading(cr, "to do", 110, 150)
        wire(cr, { { 110, 164 }, { 420, 164 } }, STEEL, 0.9)
        dot(cr, 420, 164, 3, STEEL)
        for i, item in ipairs(todo) do
            text(cr, "▸ " .. item, 110, 170 + i * 22, { size = 14, color = i == 1 and TEXT or LABEL })
        end
    end

    cairo_destroy(cr)
end
