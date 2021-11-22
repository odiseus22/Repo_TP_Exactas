fname = "../../log/player_communicator_rojo.log"

wins = 0
losses = 0

with open(fname, 'r') as f:
    for line in f:
        words = line.split()
        for word in words:
            if word == "ganaste":
                wins += 1
            if word == "perdiste":
                losses += 1


print(wins)
