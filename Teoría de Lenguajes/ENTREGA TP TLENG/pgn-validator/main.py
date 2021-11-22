import click
from dependencies import lex, yacc

# ------------------------------------------------------------------------------------------------------------------------------------------------------------
# Comienza parte 1: Lexer
# ------------------------------------------------------------------------------------------------------------------------------------------------------------

tokens = (
    'ENUM_CONTINUE',
    'ENUM',
    'HEADER_ITEM',
    'MOVE',
    'RESULT',
    'O_BRACE',
    'C_BRACE',
    'O_PARENTHESIS',
    'C_PARENTHESIS',
    'TEXT'
)

DEBUG_LEX = False
DEBUG_YACC = False


# Tokens

def t_ENUM_CONTINUE(t):
    r'\d+\.\.\.'
    if DEBUG_LEX:
        print(f'ENUM_CONTINUE = {t.value}')
    t.value = {"value": int(t.value[0:-3])}
    return t


def t_ENUM(t):
    r'\d+\.'
    if DEBUG_LEX:
        print(f'ENUM = {t.value}')
    t.value = {"value": int(t.value[0:-1])}
    return t


def t_HEADER_ITEM(t):
    r'\[[^"\[\]{}\(\)\s]+\s"[^"]*"\]'
    t.value = {"value": str(t.value)}
    if DEBUG_LEX:
        print(f'HEADER ITEM = {t.value}')
    return t


def t_MOVE(t):
    r'([a-h][18]\=[NBRQ]|(([PNBRQK]?[a-h]?[1-8]?)?x?([a-h][1-8])|O-O(-O)?))[+#]?[\!\?]?'
    is_capture = 'x' in t.value
    if DEBUG_LEX:
        print(f'MOVE = {t.value} capture?:{is_capture}')
    t.value = {"value": str(t.value), "is_capture": is_capture}
    return t


def t_RESULT(t):
    r'1-0|0-1|1/2-1/2'
    if DEBUG_LEX:
        print(f'RESULT = {t.value}')
    t.value = {"value": str(t.value)}
    return t


def t_O_BRACE(t):
    r'\{'
    if DEBUG_LEX:
        print(f'OPEN BRACE = {t.value}')
    t.value = {"value": str(t.value)}
    return t


def t_C_BRACE(t):
    r'\}'
    if DEBUG_LEX:
        print(f'CLOSE BRACE = {t.value}')
    t.value = {"value": str(t.value)}
    return t


def t_O_PARENTHESIS(t):
    r'\('
    if DEBUG_LEX:
        print(f'OPEN PARENTHESIS = {t.value}')
    t.value = {"value": str(t.value)}
    return t


def t_C_PARENTHESIS(t):
    r'\)'
    if DEBUG_LEX:
        print(f'CLOSE PARENTHESIS = {t.value}')
    t.value = {"value": str(t.value)}
    return t


def t_TEXT(t):
    r'[^{}\(\)\s]+'
    # print(f'TEXT = {t.value}')
    t.value = {"value": str(t.value)}
    return t

def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

def t_error(t):
    print('Illegal character {}'.format(t.value[0]))
    t.lexer.skip(1)


def t_eof(t):
    return None


t_ignore_SPACE = r'\s'

# Build the lexer
lex.lex()
# ------------------------------------------------------------------------------------------------------------------------------------------------------------
# Comienza parte 2
# ------------------------------------------------------------------------------------------------------------------------------------------------------------
# move: Representa la ronda incluyendo número de ronda, movidas de los jugadores y la recursión de otra ronda.
# MOVE: Son las movidas de cada jugador
# ------------------------------------------------------------------------------------------------------------------------------------------------------------
variables = {}

# Print result
def p_print_result(p):
    'print : file'

    p[1].reverse()

    for index in range(0, len(p[1])):
        print("Partida {}. Cantidad de capturas: {}".format(index + 1, p[1][index]))

# Producción leer partidas iterativamente
def p_multi_game_file_expr(p):
    'file : header game file'

    p[3].append(p[2]["cant_captures"])
    p[0] = p[3]


# Producción leer la última partida
def p_file_expr(p):
    'file : header game'

    p[0] = list()
    p[0].append(p[2]["cant_captures"])


# Producción para consumir la partida
def p_game(p):
    'game : move RESULT'

    p[0] = {
        "cant_captures": p[1]["cant_captures"]
    }

    if p[1]["move_no"] != 1:
        print("La partida no empieza en 1.")


# Producción para continuacion de header
def p_header(p):
    'header : HEADER_ITEM header'


# Producción para header final
def p_final_header(p):
    'header : HEADER_ITEM'


# Produccion para Move caso normal
def p_move_normal_case(p):
    'move : ENUM MOVE MOVE move'

    p[0] = {
        "cant_captures": p[4]["cant_captures"] + int(p[2]["is_capture"]) + int(p[3]["is_capture"]),
        "move_no": p[1]["value"]
    }

    if DEBUG_YACC:
        print(f"move_normal_case: {p[0]}")

    if p[1]["value"] != p[4]["move_no"] - 1:
        print("Número de movidas contiguas no matchean {} != {}".format(p[1]["value"], p[4]["move_no"] - 1))


# Produccion para Move caso con comentario de movida blanca
def p_move_white_move_comment_case(p):
    'move : ENUM MOVE comment ENUM_CONTINUE MOVE move'

    p[0] = {
        "cant_captures": p[6]["cant_captures"] + int(p[2]["is_capture"]) + int(p[5]["is_capture"]) + p[3]["cant_captures"],
        "move_no": p[1]["value"]
    }

    if DEBUG_YACC:
        print(f"move_white_move_comment_case: {p[0]}")

    if p[1]["value"] != p[4]["value"]:
        print("Número de movidas con comentario intermedio no matchean {} != {}".format(p[1]["value"], p[4]["value"]))
    elif p[1]["value"] != p[6]["move_no"] - 1:
        print("Número de movidas contiguas no matchean {} != {}".format(p[1]["value"], p[6]["move_no"] - 1))


# Caso multiples comentarios en la ultima ronda
def p_move_double_comment_case(p):
    'move : ENUM MOVE comment ENUM_CONTINUE MOVE comment move'
    p[0] = {
        "cant_captures": p[7]["cant_captures"] + int(p[2]["is_capture"]) + int(p[5]["is_capture"]) + p[3][
            "cant_captures"] + p[6]["cant_captures"],
        "move_no": p[1]["value"]
    }

    if DEBUG_YACC:
        print(f"move_double_comment_case: {p[0]}")

    if p[1]["value"] != p[4]["value"]:
        print("Número de movidas con comentario intermedio no matchean {} != {}".format(p[1]["value"], p[4]["value"]))
    elif p[1]["value"] != p[7]["move_no"] - 1:
        print("Número de movidas contiguas no matchean {} != {}".format(p[1]["value"], p[7]["move_no"] - 1))


# Produccion para Move caso com comentario de movida negra
def p_move_black_move_comment_case(p):
    'move : ENUM MOVE MOVE comment move'

    p[0] = {
        "cant_captures": p[5]["cant_captures"] + int(p[2]["is_capture"]) + int(p[3]["is_capture"]) + p[4][
            "cant_captures"],
        "move_no": p[1]["value"]
    }

    if DEBUG_YACC:
        print(f"move_black_move_comment_case: {p[0]}")

    if p[1]["value"] != p[5]["move_no"] - 1:
        print("Número de movidas contiguas no matchean {} != {}".format(p[1]["value"], p[5]["move_no"] - 1))


# Produccion para Move caso ultima jugada del blanco caso 1
def p_move_last_white_move_case1(p):
    'move : ENUM MOVE'

    p[0] = {
        "cant_captures": int(p[2]["is_capture"]),
        "move_no": p[1]["value"]
    }

    if DEBUG_YACC:
        print(f"move_last_white_move_case1: {p[0]}")


# Produccion para Move caso ultima jugada del blanco caso 2
def p_move_last_white_move_case2(p):
    'move : ENUM MOVE comment'

    p[0] = {
        "cant_captures": int(p[2]["is_capture"]) + p[3]["cant_captures"],
        "move_no": p[1]["value"]
    }

    if DEBUG_YACC:
        print(f"move_last_white_move_case2: {p[0]}")


# Produccion para Move caso ultima jugada del negro caso 1
def p_move_last_black_move_case1(p):
    'move : ENUM MOVE MOVE'

    p[0] = {
        "cant_captures": int(p[2]["is_capture"]) + int(p[3]["is_capture"]),
        "move_no": p[1]["value"]
    }

    if DEBUG_YACC:
        print(f"move_last_black_move_case1: {p[0]}")


# Produccion para Move caso ultima jugada del negro caso 2
def p_move_last_black_move_case2(p):
    'move : ENUM MOVE comment ENUM_CONTINUE MOVE'

    p[0] = {
        "cant_captures": int(p[2]["is_capture"]) + int(p[5]["is_capture"]) + p[3]["cant_captures"],
        "move_no": p[1]["value"]
    }

    if p[1]["value"] != p[4]["value"]:
        print("Número de movidas con comentario intermedio no matchean {} != {}".format(p[1]["value"], p[4]["value"]))

    if DEBUG_YACC:
        print(f"move_last_black_move_case2: {p[0]}")



# Produccion para Move caso ultima jugada del negro caso 3
def p_move_last_black_move_case3(p):
    'move : ENUM MOVE MOVE comment'

    p[0] = {
        "cant_captures": int(p[2]["is_capture"]) + int(p[3]["is_capture"]) + p[4]["cant_captures"],
        "move_no": p[1]["value"]
    }

    if DEBUG_YACC:
        print(f"move_last_black_move_case3: {p[0]}")

# Produccion para Move caso ultima jugada del negro caso 4
def p_move_last_black_move_case4(p):
    'move : ENUM MOVE comment ENUM_CONTINUE MOVE comment'

    p[0] = {
        "cant_captures": int(p[2]["is_capture"]) + p[3]["cant_captures"] + int(p[5]["is_capture"]) + p[6]["cant_captures"],
        "move_no": p[1]["value"]
    }

    if DEBUG_YACC:
        print(f"move_last_black_move_case4: {p[0]}")

    if p[1]["value"] != p[4]["value"]:
        print("Número de movidas con comentario intermedio no matchean {} != {}".format(p[1]["value"], p[4]["value"]))


# Produccion para comentario con llaves
def p_brace_comment(p):
    'comment : O_BRACE comment_body C_BRACE'
    p[0] = {"cant_captures": p[2]["cant_captures"]}

    if DEBUG_YACC:
        print(f"brace_comment: {p[0]}")


# Produccion para comentario con llaves
def p_parenthesis_comment(p):
    'comment : O_PARENTHESIS comment_body C_PARENTHESIS'
    p[0] = {"cant_captures": p[2]["cant_captures"]}

    if DEBUG_YACC:
        print(f"parenthesis_comment: {p[0]}")


# Produccion para cuerpo de comentario con texto
def p_comment_body_any(p):
    '''comment_body : TEXT comment_body
                    | ENUM comment_body
                    | ENUM_CONTINUE comment_body
                    | RESULT comment_body'''
    p[0] = {
        "cant_captures": p[2]["cant_captures"]
    }

    if DEBUG_YACC:
        print(f"comment_body_any: {p[0]}")


# Produccion para cuerpo de comentario con texto
def p_comment_body_move(p):
    'comment_body : MOVE comment_body'

    p[0] = {
        "cant_captures": int(p[1]["is_capture"]) + p[2]["cant_captures"]
    }

    if DEBUG_YACC:
        print(f"comment_body_move: {p[0]}")


# Produccion para cuerpo de comentario con comentario anidado
def p_comment_body_comment(p):
    'comment_body : comment comment_body'

    p[0] = {
        "cant_captures": p[1]["cant_captures"] + p[2]["cant_captures"]
    }

    if DEBUG_YACC:
        print(f"comment_body_comment: {p[0]}")


# Produccion para cuerpo de finalizacion de comentario con algo
def p_comment_body_final_any(p):
    '''comment_body : TEXT
                    | ENUM
                    | ENUM_CONTINUE
                    | RESULT'''
    p[0] = {
        "cant_captures": 0
    }

    if DEBUG_YACC:
        print(f"comment_body_final_any: {p[0]}")


# Produccion para cuerpo de finalizacion de comentario con jugada
def p_comment_body_final_move(p):
    'comment_body : MOVE'

    p[0] = {
        "cant_captures": int(p[1]["is_capture"])
    }

    if DEBUG_YACC:
        print(f"comment_body_final_move: {p[0]}")


# Produccion para cuerpo de finalizacion de comentario con comentario
def p_comment_body_final_comment(p):
    'comment_body : comment'

    p[0] = {
        "cant_captures": p[1]["cant_captures"]
    }

    if DEBUG_YACC:
        print(f"comment_body_final_comment: {p[0]}")


def p_error(token):
    if token is not None:
        print("Line %s, illegal token '%s'" % (token.lineno, token.value["value"]))
    else:
        print('Unexpected end of input')


yacc.yacc()


def parse_str(str):
    if DEBUG_YACC:
        print(f'Procesando {str}...')
    else:
        print(f'Procesando ...')
    yacc.parse(str)


@click.group()
@click.option("--debug/--no-debug", default=False)
def cli(debug):
    global DEBUG
    DEBUG = debug
    pass


@cli.command()
@click.argument("file_path", default="examples/partida1.pgn")
def process_file(file_path):
    """
    Lee y procesa un archivo dado
    """
    file = open(file_path, errors="ignore")
    flatten_str = file.read()
    parse_str(flatten_str)


@cli.command()
@click.argument("str")
def process_str(str):
    """
    Procesa el string suministrado
    """
    parse_str(str)


if __name__ == "__main__":
    cli()
