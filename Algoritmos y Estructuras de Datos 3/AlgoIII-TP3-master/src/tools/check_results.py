fname = "../log/player_communicator_rojo.log"

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

print "Numero de partidas ganadas: " + str(wins)
print "Numero de partidas perdidas: " + str(losses)
win_ratio = round((float(wins) / (float(wins) + float(losses))) * 100, 2)
print "Win ratio: "
print str(win_ratio)
