#include <vector>
#include <iostream>
#include <queue>
#include <tuple>
#include <limits>
#include <utility>

#ifndef __DEFINES_
#define __DEFINES_

using namespace std;
using graph = vector<pair<vector<pair<int, int>>,int>>;

const int maxFuel = 60;

using qElem = tuple<int, int, int>;
using matrix = vector<vector<int> >;

const int none = -1;

const int inf = numeric_limits<int>::max()/2;

#endif