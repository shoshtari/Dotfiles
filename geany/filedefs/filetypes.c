[build-menu]
FT_00_LB=_Compile
FT_00_CM=gcc  -Wshadow -Wall -o "%e" "%f" -O2 -Wno-unused-result 
FT_00_WD=
FT_01_LB=_Build
FT_01_CM=gcc -Wshadow -Wall -o "%e" "%f" -g -fsanitize=address -fsanitize=undefined -D_GLIBCXX_DEBUG
FT_01_WD=
