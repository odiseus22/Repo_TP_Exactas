#include <iostream>
#include "DisjointSetArray.hpp"
#include "DisjointSetTree.hpp"
#include "DisjointSetTreePath.hpp"
#include "takeInput.cpp"
#include <algorithm>
#include <fstream>
#include <experimental/filesystem>

using edge = tuple<int, int, int>;

int k = 10000;


//Podria ser float
int lim(int C) {
    return k / C;
}

int max2(int a, int b) {
    if (a > b)
        return a;
    return b;
}

int max3(int a, int b, int c) {
    return max2(a, max2(b, c));
}


void array_catedra() {
    int n, m, w, h; //w = width, h = height
    vector<edge> E = takeinput_catedra(n, m, w, h);

    /*  --  Kruskal  --  */
    //Sort
    sort(E.begin(), E.end());
    //Estructuras
    DisjointSetArray ds(n);
    vector<int> Intern(n, 0);
    //Genero mi segmentacion
    for (int i = 1; i < E.size(); i++) {
        int v = ds.find(first(E[i]));
        int w = ds.find(second(E[i]));
        if (v != w) {
            int MInt = min(Intern[v] + lim(ds.size(v)),
                           Intern[w] + lim(ds.size(w)));
            if (cost(E[i]) <= MInt) {
                int temp = max3(Intern[v], Intern[w], cost(E[i]));
                ds.Unite(first(E[i]), second(E[i]));
                Intern[ds.find(first(E[i]))] = temp;
            }
        }
    }
    /*  --  Fin_Kruskal -- */

    //Guardo los resultados en un txt
    for (int i = 0; i < h; i++) {
        int off = i * w;
        for (int j = 0; j < w; j++) {
            cout << ds.find(off + j) << " ";
        }
        if (i != h - 1)
            cout << endl;
    }

}

void tree_catedra() {
    int n, m, w, h; //w = width, h = height
    vector<edge> E = takeinput_catedra(n, m, w, h);

    /*  --  Kruskal  --  */
    //Sort
    sort(E.begin(), E.end());
    //Estructuras
    DisjointSetTree ds(n);
    vector<int> Intern(n, 0);
    //Genero mi segmentacion
    for (int i = 1; i < E.size(); i++) {
        int v = ds.find(first(E[i]));
        int w = ds.find(second(E[i]));
        if (v != w) {
            int MInt = min(Intern[v] + lim(ds.size(v)),
                           Intern[w] + lim(ds.size(w)));
            if (cost(E[i]) <= MInt) {
                int temp = max3(Intern[v], Intern[w], cost(E[i]));
                ds.Unite(first(E[i]), second(E[i]));
                Intern[ds.find(first(E[i]))] = temp;
            }
        }
    }
    /*  --  Fin_Kruskal -- */

    //Guardo los resultados en un txt
    for (int i = 0; i < h; i++) {
        int off = i * w;
        for (int j = 0; j < w; j++) {
            cout << ds.find(off + j) << " ";
        }
        if (i != h - 1)
            cout << endl;
    }

}

void path_catedra() {
    int n, m, w, h; //w = width, h = height
    vector<edge> E = takeinput_catedra(n, m, w, h);

    /*  --  Kruskal  --  */
    //Sort
    sort(E.begin(), E.end());
    //Estructuras
    DisjointSetTreePath ds(n);
    vector<int> Intern(n, 0);
    //Genero mi segmentacion
    for (int i = 1; i < E.size(); i++) {
        int v = ds.find(first(E[i]));
        int w = ds.find(second(E[i]));
        if (v != w) {
            int MInt = min(Intern[v] + lim(ds.size(v)),
                           Intern[w] + lim(ds.size(w)));
            if (cost(E[i]) <= MInt) {
                int temp = max3(Intern[v], Intern[w], cost(E[i]));
                ds.Unite(first(E[i]), second(E[i]));
                Intern[ds.find(first(E[i]))] = temp;
            }
        }
    }
    /*  --  Fin_Kruskal -- */

    //Guardo los resultados en un txt
    for (int i = 0; i < h; i++) {
        int off = i * w;
        for (int j = 0; j < w; j++) {
            cout << ds.find(off + j) << " ";
        }
        if (i != h - 1)
            cout << endl;
    }

}

void driver_function() {
    system("mkdir results >/dev/null 2>&1");
    string path = "./images";
    for (const auto &entry : experimental::filesystem::directory_iterator(path)) {
        if (entry.path().extension().string() == ".gif" or entry.path().extension().string() == ".jpg" or
            entry.path().extension().string() == ".png") {
            std::cout << "Procesando " + entry.path().string() << std::endl;
            string cmd_path = "convert " + entry.path().string() +
                              " -type Palette -depth 8 -compress none pgm:- |sed '1d;3d;' > ./images/" +
                              entry.path().stem().string() +
                              ".pgm";
            const char *cmd = cmd_path.c_str();
            system(cmd);
            int n, m, w, h; //w = width, h = height
            string filename = "./images/" + entry.path().stem().string() + ".pgm";
            vector<edge> E = takeinput(n, m, w, h, filename);

            /*  --  Kruskal  --  */
            //Sort
            sort(E.begin(), E.end());
            //Estructuras
//            DisjointSetArray ds(n);
//            DisjointSetTree ds(n);
            DisjointSetTreePath ds(n);
            vector<int> Intern(n, 0);
            //Genero mi segmentacion
            for (int i = 1; i < E.size(); i++) {
                int v = ds.find(first(E[i]));
                int w = ds.find(second(E[i]));
                if (v != w) {
                    int MInt = min(Intern[v] + lim(ds.size(v)),
                                   Intern[w] + lim(ds.size(w)));
                    if (cost(E[i]) <= MInt) {
                        int temp = max3(Intern[v], Intern[w], cost(E[i]));
                        ds.Unite(first(E[i]), second(E[i]));
                        Intern[ds.find(first(E[i]))] = temp;
                    }
                }
            }
            /*  --  Fin_Kruskal -- */

            //Guardo los resultados en un txt
            std::ofstream output_file;
            output_file.open("./results/" + entry.path().stem().string() + ".txt");
            output_file << "ALGOIIITPII" << endl;
            for (int i = 0; i < h; i++) {
                int off = i * w;
                for (int j = 0; j < w; j++) {
                    output_file << ds.find(off + j) << " ";
                }
                if (i != h - 1)
                    output_file << endl;
            }
            output_file.close();

        }
    }
    cout << "Convirtiendo a imagenes..." << endl;
    system("rm -rf ./results/*.png");
    system("python convertTxtToImage.py");
}

void benchmark_functions_same_K() {
    string path = "./images";
    std::ofstream output_csv;
    output_csv.open("./tests/benchmark_same_K/benchmark_functions_same_k.csv");
    output_csv << "n,Array,Tree,TreePath" << endl;
    int pic_count = 0;
    int reps = 5;
    for (const auto &entry : experimental::filesystem::directory_iterator(path)) {
        if (entry.path().extension().string() == ".gif" or entry.path().extension().string() == ".jpg" or
            entry.path().extension().string() == ".png") {
            pic_count++;
            std::cout << "Procesando " + entry.path().stem().string() << std::endl;
            string cmd_path = "convert " + entry.path().string() +
                              " -type Palette -depth 8 -compress none pgm:- |sed '1d;3d;' > ./images/" +
                              entry.path().stem().string() +
                              ".pgm";
            const char *cmd = cmd_path.c_str();
            system(cmd);
            int n, m, w, h; //w = width, h = height
            string filename = "./images/" + entry.path().stem().string() + ".pgm";
            vector<edge> E = takeinput(n, m, w, h, filename);

            //Sort
            sort(E.begin(), E.end());

            //Estructuras
            double tiempo_promedio_array = 0.0;
            for (int i = 0; i < reps; i++) {
                DisjointSetArray ds(n);
                vector<int> Intern(n, 0);
                //Genero mi segmentacion
                auto startArray = chrono::steady_clock::now();
                for (int i = 1; i < E.size(); i++) {
                    int v = ds.find(first(E[i]));
                    int w = ds.find(second(E[i]));
                    if (v != w) {
                        int MInt = min(Intern[v] + lim(ds.size(v)),
                                       Intern[w] + lim(ds.size(w)));
                        if (cost(E[i]) <= MInt) {
                            int temp = max3(Intern[v], Intern[w], cost(E[i]));
                            ds.Unite(first(E[i]), second(E[i]));
                            Intern[ds.find(first(E[i]))] = temp;
                        }
                    }
                }
                auto endArray = chrono::steady_clock::now();
                auto diffArray = endArray - startArray;
                tiempo_promedio_array += chrono::duration<double, milli>(diffArray).count();
            }
            tiempo_promedio_array /= reps;

            //Estructuras
            double tiempo_promedio_tree = 0.0;
            for (int i = 0; i < reps; i++) {
                DisjointSetTree dst(n);
                vector<int> InternTree(n, 0);
                //Genero mi segmentacion
                auto startTree = chrono::steady_clock::now();
                for (int i = 1; i < E.size(); i++) {
                    int v = dst.find(first(E[i]));
                    int w = dst.find(second(E[i]));
                    if (v != w) {
                        int MInt = min(InternTree[v] + lim(dst.size(v)),
                                       InternTree[w] + lim(dst.size(w)));
                        if (cost(E[i]) <= MInt) {
                            int temp = max3(InternTree[v], InternTree[w], cost(E[i]));
                            dst.Unite(first(E[i]), second(E[i]));
                            InternTree[dst.find(first(E[i]))] = temp;
                        }
                    }
                }
                auto endTree = chrono::steady_clock::now();
                auto diffTree = endTree - startTree;
                tiempo_promedio_tree += chrono::duration<double, milli>(diffTree).count();
            }
            tiempo_promedio_tree /= reps;

            //Estructuras
            double tiempo_promedio_tree_path = 0.0;
            for (int i = 0; i < reps; i++) {
                DisjointSetTreePath dsTreePath(n);
                vector<int> InternTreePath(n, 0);
                //Genero mi segmentacion
                auto startTreePath = chrono::steady_clock::now();
                for (int i = 1; i < E.size(); i++) {
                    int v = dsTreePath.find(first(E[i]));
                    int w = dsTreePath.find(second(E[i]));
                    if (v != w) {
                        int MInt = min(InternTreePath[v] + lim(dsTreePath.size(v)),
                                       InternTreePath[w] + lim(dsTreePath.size(w)));
                        if (cost(E[i]) <= MInt) {
                            int temp = max3(InternTreePath[v], InternTreePath[w], cost(E[i]));
                            dsTreePath.Unite(first(E[i]), second(E[i]));
                            InternTreePath[dsTreePath.find(first(E[i]))] = temp;
                        }
                    }
                }
                auto endTreePath = chrono::steady_clock::now();
                auto diffTreePath = endTreePath - startTreePath;
                tiempo_promedio_tree_path += chrono::duration<double, milli>(diffTreePath).count();
            }
            tiempo_promedio_tree_path /= reps;

            output_csv << pic_count << "," << tiempo_promedio_array << "," << tiempo_promedio_tree << ","
                       << tiempo_promedio_tree_path << endl;
        }
    }
    output_csv.close();
}

void benchmark_functions_diff_K() {
    std::ofstream output_csv;
    output_csv.open("./tests/benchmark_diff_K/benchmark_functions_diff_k.csv");
    output_csv << "n,Array,Tree,TreePath" << endl;
    int reps = 36;
    k = 0;

    double tiempo_promedio_array = 0.0;
    double tiempo_promedio_tree = 0.0;
    double tiempo_promedio_tree_path = 0.0;

    for (int j = 0; j < reps; j++) {
        int n, m, w, h; //w = width, h = height
        string filename = "./tests/benchmark_diff_K/3096.pgm";
        vector<edge> E = takeinput(n, m, w, h, filename);

        //Sort
        sort(E.begin(), E.end());
        k += 500;
        cout << "K: " << k << endl;
        //Estructuras
        tiempo_promedio_array = 0.0;
        for (int i = 0; i < 5; i++) {
            DisjointSetArray ds(n);
            vector<int> Intern(n, 0);
            //Genero mi segmentacion
            auto startArray = chrono::steady_clock::now();
            for (int i = 1; i < E.size(); i++) {
                int v = ds.find(first(E[i]));
                int w = ds.find(second(E[i]));
                if (v != w) {
                    int MInt = min(Intern[v] + lim(ds.size(v)),
                                   Intern[w] + lim(ds.size(w)));
                    if (cost(E[i]) <= MInt) {
                        int temp = max3(Intern[v], Intern[w], cost(E[i]));
                        ds.Unite(first(E[i]), second(E[i]));
                        Intern[ds.find(first(E[i]))] = temp;
                    }
                }
            }
            auto endArray = chrono::steady_clock::now();
            auto diffArray = endArray - startArray;
            tiempo_promedio_array += chrono::duration<double, milli>(diffArray).count();
        }
        tiempo_promedio_array /= 5;

        //Estructuras
        tiempo_promedio_tree = 0.0;
        for (int i = 0; i < 5; i++) {
            DisjointSetTree dst(n);
            vector<int> InternTree(n, 0);
            //Genero mi segmentacion
            auto startTree = chrono::steady_clock::now();
            for (int i = 1; i < E.size(); i++) {
                int v = dst.find(first(E[i]));
                int w = dst.find(second(E[i]));
                if (v != w) {
                    int MInt = min(InternTree[v] + lim(dst.size(v)),
                                   InternTree[w] + lim(dst.size(w)));
                    if (cost(E[i]) <= MInt) {
                        int temp = max3(InternTree[v], InternTree[w], cost(E[i]));
                        dst.Unite(first(E[i]), second(E[i]));
                        InternTree[dst.find(first(E[i]))] = temp;
                    }
                }
            }
            auto endTree = chrono::steady_clock::now();
            auto diffTree = endTree - startTree;
            tiempo_promedio_tree += chrono::duration<double, milli>(diffTree).count();
        }
        tiempo_promedio_tree /= 5;

        //Estructuras
        tiempo_promedio_tree_path = 0.0;
        for (int i = 0; i < 5; i++) {
            DisjointSetTreePath dsTreePath(n);
            vector<int> InternTreePath(n, 0);
            //Genero mi segmentacion
            auto startTreePath = chrono::steady_clock::now();
            for (int i = 1; i < E.size(); i++) {
                int v = dsTreePath.find(first(E[i]));
                int w = dsTreePath.find(second(E[i]));
                if (v != w) {
                    int MInt = min(InternTreePath[v] + lim(dsTreePath.size(v)),
                                   InternTreePath[w] + lim(dsTreePath.size(w)));
                    if (cost(E[i]) <= MInt) {
                        int temp = max3(InternTreePath[v], InternTreePath[w], cost(E[i]));
                        dsTreePath.Unite(first(E[i]), second(E[i]));
                        InternTreePath[dsTreePath.find(first(E[i]))] = temp;
                    }
                }
            }
            auto endTreePath = chrono::steady_clock::now();
            auto diffTreePath = endTreePath - startTreePath;
            tiempo_promedio_tree_path += chrono::duration<double, milli>(diffTreePath).count();

            std::ofstream output_file;
            output_file.open("./tests/benchmark_diff_K/results/3096_" + to_string(k) + ".txt");
            output_file << "ALGOIIITPII" << endl;
            for (int i = 0; i < h; i++) {
                int off = i * w;
                for (int j = 0; j < w; j++) {
                    output_file << dsTreePath.find(off + j) << " ";
                }
                if (i != h - 1)
                    output_file << endl;
            }
            output_file.close();

        }
        tiempo_promedio_tree_path /= 5;

        output_csv << k << "," << tiempo_promedio_array << "," << tiempo_promedio_tree << ","
                   << tiempo_promedio_tree_path << endl;
    }
    output_csv.close();
    system("python tests/benchmark_diff_K/convertTxtToImage.py");
}

void complexity() {
    string path = "./tests/complexity/images";
    std::ofstream output_csv;
    output_csv.open("./tests/complexity/complexity.csv");
    output_csv << "n,m,Array,Tree,TreePath" << endl;
    int pic_count = 0;
    int reps = 15;
    for (int i = 0; i < 8; i++) {
        pic_count++;
        std::cout << "Procesando " << i << ".pgm" << endl;
        int n, m, w, h; //w = width, h = height
        string filename = "tests/complexity/images/" + to_string(i) + ".pgm";
        vector<edge> E = takeinput(n, m, w, h, filename);

        //Sort
        sort(E.begin(), E.end());

        //Estructuras
        double tiempo_promedio_array = 0.0;
        for (int i = 0; i < reps; i++) {
            DisjointSetArray ds(n);
            vector<int> Intern(n, 0);
            //Genero mi segmentacion
            auto startArray = chrono::steady_clock::now();
            for (int i = 1; i < E.size(); i++) {
                int v = ds.find(first(E[i]));
                int w = ds.find(second(E[i]));
                if (v != w) {
                    int MInt = min(Intern[v] + lim(ds.size(v)),
                                   Intern[w] + lim(ds.size(w)));
                    if (cost(E[i]) <= MInt) {
                        int temp = max3(Intern[v], Intern[w], cost(E[i]));
                        ds.Unite(first(E[i]), second(E[i]));
                        Intern[ds.find(first(E[i]))] = temp;
                    }
                }
            }
            auto endArray = chrono::steady_clock::now();
            auto diffArray = endArray - startArray;
            tiempo_promedio_array += chrono::duration<double, milli>(diffArray).count();
        }
        tiempo_promedio_array /= reps;

        //Estructuras
        double tiempo_promedio_tree = 0.0;
        for (int i = 0; i < reps; i++) {
            DisjointSetTree dst(n);
            vector<int> InternTree(n, 0);
            //Genero mi segmentacion
            auto startTree = chrono::steady_clock::now();
            for (int i = 1; i < E.size(); i++) {
                int v = dst.find(first(E[i]));
                int w = dst.find(second(E[i]));
                if (v != w) {
                    int MInt = min(InternTree[v] + lim(dst.size(v)),
                                   InternTree[w] + lim(dst.size(w)));
                    if (cost(E[i]) <= MInt) {
                        int temp = max3(InternTree[v], InternTree[w], cost(E[i]));
                        dst.Unite(first(E[i]), second(E[i]));
                        InternTree[dst.find(first(E[i]))] = temp;
                    }
                }
            }
            auto endTree = chrono::steady_clock::now();
            auto diffTree = endTree - startTree;
            tiempo_promedio_tree += chrono::duration<double, milli>(diffTree).count();
        }
        tiempo_promedio_tree /= reps;

        //Estructuras
        double tiempo_promedio_tree_path = 0.0;
        for (int i = 0; i < reps; i++) {
            DisjointSetTreePath dsTreePath(n);
            vector<int> InternTreePath(n, 0);
            //Genero mi segmentacion
            auto startTreePath = chrono::steady_clock::now();
            for (int i = 1; i < E.size(); i++) {
                int v = dsTreePath.find(first(E[i]));
                int w = dsTreePath.find(second(E[i]));
                if (v != w) {
                    int MInt = min(InternTreePath[v] + lim(dsTreePath.size(v)),
                                   InternTreePath[w] + lim(dsTreePath.size(w)));
                    if (cost(E[i]) <= MInt) {
                        int temp = max3(InternTreePath[v], InternTreePath[w], cost(E[i]));
                        dsTreePath.Unite(first(E[i]), second(E[i]));
                        InternTreePath[dsTreePath.find(first(E[i]))] = temp;
                    }
                }
            }
            auto endTreePath = chrono::steady_clock::now();
            auto diffTreePath = endTreePath - startTreePath;
            tiempo_promedio_tree_path += chrono::duration<double, milli>(diffTreePath).count();
        }
        tiempo_promedio_tree_path /= reps;

        output_csv << n << "," << m << "," << tiempo_promedio_array << "," << tiempo_promedio_tree << ","
                   << tiempo_promedio_tree_path << endl;
    }
    output_csv.close();
}

void qualitative_experiment() {
    for (int j = 0; j < 3; j++) {
        int n, m, w, h; //w = width, h = height
        string filename;
        if (j == 0) filename = "./tests/qualitative/00001.pgm";
        if (j == 1) filename = "./tests/qualitative/3096.pgm";
        if (j == 2) filename = "./tests/qualitative/14037.pgm";
        vector<edge> E = takeinput(n, m, w, h, filename);

        //Sort
        sort(E.begin(), E.end());
        //Estructuras
        for (k = 500; k < 50000; k += 500) {
            DisjointSetTreePath ds(n);
            vector<int> Intern(n, 0);
            //Genero mi segmentacion
            for (int i = 1; i < E.size(); i++) {
                int v = ds.find(first(E[i]));
                int w = ds.find(second(E[i]));
                if (v != w) {
                    int MInt = min(Intern[v] + lim(ds.size(v)),
                                   Intern[w] + lim(ds.size(w)));
                    if (cost(E[i]) <= MInt) {
                        int temp = max3(Intern[v], Intern[w], cost(E[i]));
                        ds.Unite(first(E[i]), second(E[i]));
                        Intern[ds.find(first(E[i]))] = temp;
                    }
                }
            }


            std::ofstream output_file;
            output_file.open("./tests/qualitative/results/" + to_string(j) +"_" + to_string(k) + ".txt");
            output_file << "ALGOIIITPII" << endl;
            for (int i = 0; i < h; i++) {
                int off = i * w;
                for (int j = 0; j < w; j++) {
                    output_file << ds.find(off + j) << " ";
                }
                if (i != h - 1)
                    output_file << endl;
            }
            output_file.close();
        }
    }
}

void qualitative_experiment_adhoc() {
    for (int j = 0; j < 3; j++) {
        int n, m, w, h; //w = width, h = height
        string filename = "./tests/qualitative/00001.pgm";
        vector<edge> E = takeinput(n, m, w, h, filename);
        k = 75000;
        //Sort
        sort(E.begin(), E.end());
        DisjointSetTreePath ds(n);
        vector<int> Intern(n, 0);
        //Genero mi segmentacion
        for (int i = 1; i < E.size(); i++) {
            int v = ds.find(first(E[i]));
            int w = ds.find(second(E[i]));
            if (v != w) {
                int MInt = min(Intern[v] + lim(ds.size(v)),
                               Intern[w] + lim(ds.size(w)));
                if (cost(E[i]) <= MInt) {
                    int temp = max3(Intern[v], Intern[w], cost(E[i]));
                    ds.Unite(first(E[i]), second(E[i]));
                    Intern[ds.find(first(E[i]))] = temp;
                }
            }
        }


        std::ofstream output_file;
        output_file.open("./tests/qualitative/results/00001_" + to_string(k) + ".txt");
        output_file << "ALGOIIITPII" << endl;
        for (int i = 0; i < h; i++) {
            int off = i * w;
            for (int j = 0; j < w; j++) {
                output_file << ds.find(off + j) << " ";
            }
            if (i != h - 1)
                output_file << endl;
        }
        output_file.close();
    }
}

void qualitative_experiment_same_image() {
    for (int j = 0; j < 3; j++) {
        int n, m, w, h; //w = width, h = height
        string filename;
        if (j == 0) filename = "./tests/qualitative/00002.pgm";
        if (j == 1) filename = "./tests/qualitative/00003.pgm";
        if (j == 2) filename = "./tests/qualitative/00004.pgm";
        vector<edge> E = takeinput(n, m, w, h, filename);

        //Sort
        sort(E.begin(), E.end());
        //Estructuras
        for (k = 500; k < 50000; k += 500) {
            DisjointSetTreePath ds(n);
            vector<int> Intern(n, 0);
            //Genero mi segmentacion
            for (int i = 1; i < E.size(); i++) {
                int v = ds.find(first(E[i]));
                int w = ds.find(second(E[i]));
                if (v != w) {
                    int MInt = min(Intern[v] + lim(ds.size(v)),
                                   Intern[w] + lim(ds.size(w)));
                    if (cost(E[i]) <= MInt) {
                        int temp = max3(Intern[v], Intern[w], cost(E[i]));
                        ds.Unite(first(E[i]), second(E[i]));
                        Intern[ds.find(first(E[i]))] = temp;
                    }
                }
            }


            std::ofstream output_file;
            output_file.open("./tests/qualitative/results/" + to_string(j+3) +"_" + to_string(k) + ".txt");
            output_file << "ALGOIIITPII" << endl;
            for (int i = 0; i < h; i++) {
                int off = i * w;
                for (int j = 0; j < w; j++) {
                    output_file << ds.find(off + j) << " ";
                }
                if (i != h - 1)
                    output_file << endl;
            }
            output_file.close();
        }
    }
}

int main() {
    cout << "Funcion driver para convertir imagenes" << endl;
    driver_function();
    cout << endl << "Primer experimento" << endl;
    benchmark_functions_same_K();
    cout << endl << "Segundo experimento" << endl;
    benchmark_functions_diff_K();
    cout << endl << "Complejidades" << endl;
    complexity();
    cout << endl << "Experimento cualitativo" << endl;
    qualitative_experiment();
    cout << endl << "Experimento cualitativo AD-HOC" << endl;
    qualitative_experiment_adhoc();
    cout << endl << "Experimento cualitativo misma imagen" <<endl;
    qualitative_experiment_same_image();
    return 0;
}
