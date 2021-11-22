cd ..
g++ -std=c++11 -o random_player random_player.cpp

cd tools
#!/bin/bash
rm -rf ../log/ && mkdir ../greedy_player_src/build && cd ../greedy_player_src/build && cmake .. && make && cp greedy_player .. && cd .. && rm -rf build/ && mv greedy_player .. && cd .. && clear && python c_linea.py --blue_player ./greedy_player --iterations 1000 --columns 7 --rows 6 --p 21 --c 4   --red_player ./random_player
