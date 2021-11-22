#include <iostream>
#include <vector>
#include <tuple>
#include <fstream>

using namespace std;

using edge = tuple<int, int, int>;

int& cost(edge& e) {return get<0>(e);}
int& first(edge& e) {return get<1>(e);}
int& second(edge& e) {return get<2>(e);}


void printVector(vector<int> v){
	cout << "[";
	for(int i=0; i<v.size()-1;i++){
		cout << v[i] << ",";
	}
	cout<<v[v.size()-1]<<"]"<<endl;
}

void printEdges(vector<edge> e){
	cout << "<<";
	for(int i=0;i<e.size()-1;i++){
		cout<<"("<<cost(e[i])<<","<<first(e[i])<<","<<second(e[i])<<"),";
	}
	cout<<"("<<cost(e[e.size()-1])<<","<<first(e[e.size()-1])<<","<<second(e[e.size()-1])<<")>>"<<endl;
}

vector<edge> takeinput(int& n, int& m, int& width, int& height, string filename){
    //Levanta los datos
    std::ifstream input_file;
    input_file.open(filename);
    input_file >> width >> height;
	n = width * height;
	vector<int> pixels(n);
	for(int i=0;i<pixels.size();i++){
		int value; input_file >> value;
		pixels[i] = value;
	}
	//Se puede calcular m
	m = 4*(width-2)*(height-2) + 5*(width+height-4) + 6;
	vector<edge> ejes(m);
	//Armo la lista de ejes para ordenar
	int actual = 0;
	for(int i=0;i<pixels.size()-1;i++){
		if(i>=width*(height-1)){
			cost(ejes[actual]) = abs(pixels[i]-pixels[i+1]);
			first(ejes[actual]) = i;
			second(ejes[actual]) = i+1;
			actual++;
		} else if(i % width == 0){
			cost(ejes[actual]) = abs(pixels[i]-pixels[i+1]);
			first(ejes[actual]) = i;
			second(ejes[actual]) = i+1;
			actual++;
			cost(ejes[actual]) = abs(pixels[i]-pixels[i+width]);
			first(ejes[actual]) = i;
			second(ejes[actual]) = i+width;
			actual++;
			cost(ejes[actual]) = abs(pixels[i]-pixels[i+width+1]);
			first(ejes[actual]) = i;
			second(ejes[actual]) = i+width+1;
			actual++;
		} else if((i+1) % width == 0){
			cost(ejes[actual]) = abs(pixels[i]-pixels[i+width]);
			first(ejes[actual]) = i;
			second(ejes[actual]) = i+width;
			actual++;
			cost(ejes[actual]) = abs(pixels[i]-pixels[i+width-1]);
			first(ejes[actual]) = i;
			second(ejes[actual]) = i+width-1;
			actual++;
		} else {
			cost(ejes[actual]) = abs(pixels[i]-pixels[i+1]);
			first(ejes[actual]) = i;
			second(ejes[actual]) = i+1;
			actual++;
			cost(ejes[actual]) = abs(pixels[i]-pixels[i+width]);
			first(ejes[actual]) = i;
			second(ejes[actual]) = i+width;
			actual++;
			cost(ejes[actual]) = abs(pixels[i]-pixels[i+1+width]);
			first(ejes[actual]) = i;
			second(ejes[actual]) = i+1+width;
			actual++;
			cost(ejes[actual]) = abs(pixels[i]-pixels[i+width-1]);
			first(ejes[actual]) = i;
			second(ejes[actual]) = i+width-1;
			actual++;
		}
	}
	return ejes;
}

vector<edge> takeinput_catedra(int& n, int& m, int& width, int& height){
    //Levanta los datos
    cin >> width >> height;
    n = width * height;
    vector<int> pixels(n);
    for(int i=0;i<pixels.size();i++){
        int value; cin >> value;
        pixels[i] = value;
    }
    //Se puede calcular m
    m = 4*(width-2)*(height-2) + 5*(width+height-4) + 6;
    vector<edge> ejes(m);
    //Armo la lista de ejes para ordenar
    int actual = 0;
    for(int i=0;i<pixels.size()-1;i++){
        if(i>=width*(height-1)){
            cost(ejes[actual]) = abs(pixels[i]-pixels[i+1]);
            first(ejes[actual]) = i;
            second(ejes[actual]) = i+1;
            actual++;
        } else if(i % width == 0){
            cost(ejes[actual]) = abs(pixels[i]-pixels[i+1]);
            first(ejes[actual]) = i;
            second(ejes[actual]) = i+1;
            actual++;
            cost(ejes[actual]) = abs(pixels[i]-pixels[i+width]);
            first(ejes[actual]) = i;
            second(ejes[actual]) = i+width;
            actual++;
            cost(ejes[actual]) = abs(pixels[i]-pixels[i+width+1]);
            first(ejes[actual]) = i;
            second(ejes[actual]) = i+width+1;
            actual++;
        } else if((i+1) % width == 0){
            cost(ejes[actual]) = abs(pixels[i]-pixels[i+width]);
            first(ejes[actual]) = i;
            second(ejes[actual]) = i+width;
            actual++;
            cost(ejes[actual]) = abs(pixels[i]-pixels[i+width-1]);
            first(ejes[actual]) = i;
            second(ejes[actual]) = i+width-1;
            actual++;
        } else {
            cost(ejes[actual]) = abs(pixels[i]-pixels[i+1]);
            first(ejes[actual]) = i;
            second(ejes[actual]) = i+1;
            actual++;
            cost(ejes[actual]) = abs(pixels[i]-pixels[i+width]);
            first(ejes[actual]) = i;
            second(ejes[actual]) = i+width;
            actual++;
            cost(ejes[actual]) = abs(pixels[i]-pixels[i+1+width]);
            first(ejes[actual]) = i;
            second(ejes[actual]) = i+1+width;
            actual++;
            cost(ejes[actual]) = abs(pixels[i]-pixels[i+width-1]);
            first(ejes[actual]) = i;
            second(ejes[actual]) = i+width-1;
            actual++;
        }
    }
    return ejes;
}