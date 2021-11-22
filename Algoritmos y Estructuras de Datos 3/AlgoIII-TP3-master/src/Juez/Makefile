#Compiling flags
CXX=g++
CXXFLAGS= -std=c++11 -g

SOURCES=$(wildcard *.cpp)
# Objs are all the sources, with .cpp replaced by .o
OBJS=$(SOURCES:.cpp=.o)


all: main

main: $(OBJS)
	$(CXX) $(CPPFLAGS) -o $@ $(OBJS) 


clean:
	rm *.o
	rm main

# Get a .o from a .cpp by calling compiler with cflags and includes (if defined)
.cpp.o:
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $<
