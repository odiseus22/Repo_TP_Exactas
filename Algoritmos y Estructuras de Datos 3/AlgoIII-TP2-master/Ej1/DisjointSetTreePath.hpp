#ifndef CODIGO_DISJOINTSETTREEPATH_H
#define CODIGO_DISJOINTSETTREEPATH_H

#include <vector>
#include <array>
#include <string>
#include <ostream>

using namespace std;

class DisjointSetTreePath {
public:

    DisjointSetTreePath(int n){
        _padres.assign(n,nadie); _size.assign(n,1);
    }

    void Unite(int i1, int i2){
        i1=find(i1); i2=find(i2);
        if(i1 != i2){
            if(_size[i1]<_size[i2]){ swap(i1,i2);}
            _size[i1] += _size[i2];
            _padres[i2]=i1;
        }
    }

    int find(int i){
        return _padres[i] == nadie ? i : (_padres[i] = find(_padres[i]));
    }

    int size(int i){
        return _size[i];
    }


private:

	const int nadie=-1;

    vector<int> _padres;
    vector<int> _size;

};



#endif //CODIGO_DISJOINTSETARRAY_H
