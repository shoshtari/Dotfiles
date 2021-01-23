[build-menu]
FT_00_LB=_Compile
FT_00_CM=g++  -Wshadow -Wall -std=c++20 -o "%e" "%f" -O2 -Wno-unused-result 
FT_00_WD=
FT_01_LB=_Build
FT_01_CM=g++ -Wshadow -Wall -std=c++20 -o "%e" "%f" -g -fsanitize=address -fsanitize=undefined -D_GLIBCXX_DEBUG
FT_01_WD=
FT_02_LB=_Lint
FT_02_CM=cppcheck --language=c++ --enable=warning,style --template=gcc "%f"
FT_02_WD=
