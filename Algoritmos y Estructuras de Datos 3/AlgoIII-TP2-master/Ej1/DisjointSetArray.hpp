#ifndef CODIGO_DISJOINTSETARRAY_H
#define CODIGO_DISJOINTSETARRAY_H

#include <vector>
#include <array>
#include <string>
#include <ostream>

using namespace std;

class DisjointSetArray {
public:

    DisjointSetArray(int n) {
        _padres.assign(n, 0);
        _size.assign(n, 1);
        for(int i=0; i<_padres.size(); i++){
            _padres[i]=i;
        }
    }

    void Unite(int i1, int i2) {
        i1 = find(i1);
        i2 = find(i2);
        _size[i1]+=_size[i2];
        for(int j=0;j<_padres.size();j++){
            if(_padres[j]==i2){
                _padres[j]=i1;
            }
        }       
    }

    int find(int i) {
        return _padres[i];
    }

    int size(int i){
        return _size[_padres[i]];
    }


private:

    vector<int> _padres;
    vector<int> _size;

};


#endif //CODIGO_DISJOINTSETARRAY_H
