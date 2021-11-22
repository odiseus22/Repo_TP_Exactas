#include "FuncionesAuxiliares.h"

int read_int() {
    string msg;
    cin >> msg;
    if (msg == "salir") {
        cout << "listo" << endl;
        exit(0);
    }
    return stoi(msg);
}

string read_str() {
    string msg;
    cin >> msg;
    if (msg == "salir") {
        cout << "listo" << endl;
        exit(0);
    }
    return msg;
}

void send(const std::string &msg) {
    std::cout << msg << std::endl;
}

void send(int msg) {
    std::cout << msg << std::endl;
}

/**
 * Calcula el winratio de haber jugado "n" veces.
 *
 * @return el porcentaje de partidas ganadas por nuestro jugador..
 */
double check_result() {
    string winratio;

    FILE *fp;
    char path[1035];
    fp = popen("python tools/check_results.py", "r");
    if (fp == NULL) {
        printf("Failed to run command\n");
        exit(1);
    }
    while (fgets(path, sizeof(path) - 1, fp) != NULL) {
        winratio = path;
    }
    winratio.pop_back();
    pclose(fp);

    return stod(winratio);
}

/**
 * Ejecuta un juego con nuestro jugador contra el jugador pasado por parametro.
 *
 * @param iterations Cantidad de iteraciones.
 * @param columns Cantidad de columnas.
 * @param rows Cantidad de filas.
 * @param p Cantidad de fichas.
 * @param c Cantidad de fichas en linea para ganar.
 * @param first Color del jugador con el primer turno.
 * @param opponent Nombre del ejecutable contra el que juega.
 * @return TBD.
 */
int jugar(const int &iterations, const int &columns, const int &rows, const int &p, const int &c, const string &first,
          const string &opponent) {
    if (opponent == "random") {
        string cmd = "python c_linea.py --blue_player ./greedy_player --first " + first + " --iterations " +
                     to_string(iterations) + " --columns " + to_string(columns) +
                     " --rows " + to_string(rows) + " --p " + to_string(p) + " --c " + to_string(c) +
                     " --red_player ./random_player >/dev/null 2>&1";
        system(cmd.c_str());
    }
    if (opponent == "goloso") {
        string cmd = "python c_linea.py --blue_player ./greedy_player --first " + first + " --iterations " +
                     to_string(iterations) + " --columns " + to_string(columns) +
                     " --rows " + to_string(rows) + " --p " + to_string(p) + " --c " + to_string(c) +
                     " --red_player ./greedy_player >/dev/null 2>&1";
        system(cmd.c_str());
    }

    double winratio = check_result();

    system("rm log/*.log");

    //TODO: Seguir a partir de aca.
}