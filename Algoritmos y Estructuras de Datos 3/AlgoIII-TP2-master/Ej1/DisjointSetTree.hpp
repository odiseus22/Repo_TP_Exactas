#ifndef CODIGO_DISJOINTSETTREE_H
#define CODIGO_DISJOINTSETTREE_H

#include <vector>
#include <array>
#include <string>
#include <ostream>

using namespace std;

class DisjointSetTree {
public:

    DisjointSetTree(int n) {
        _padres.assign(n, 0);
        _size.assign(n, 1);
        for(int i=0;i<_padres.size();i++){
            _padres[i]=i;
        }
    }

    void Unite(int i1, int i2) {
        i1 = find(i1); i2 = find(i2);
        _size[i2] += _size[i1];
        _padres[i1] = _padres[i2];    
    }

    int find(int i) {
        if(i==_padres[i]) 
            return i;
        return find(_padres[i]);
    }

    int size(int i){
        return _size[find(i)];
    }


private:

    vector<int> _padres;
    vector<int> _size;

};


#endif //CODIGO_DISJOINTSETARRAY_H
