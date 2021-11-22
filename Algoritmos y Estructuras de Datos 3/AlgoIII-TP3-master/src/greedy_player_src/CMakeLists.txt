cmake_minimum_required(VERSION 3.10)
project(Tp3_Codigo)

set(CMAKE_CXX_STANDARD 14)

add_executable(greedy_player main.cpp Tablero.cpp Tablero.h JugadorGoloso.cpp JugadorGoloso.h FuncionesAuxiliares.cpp FuncionesAuxiliares.h)
