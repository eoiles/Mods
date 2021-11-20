lines = []
string = ""

with open("a.csv", "r", encoding="utf-8") as file:
    for line in file:
        line = line.replace("\n","").split(",")
        lines.append(line)
    for line in lines:
        string += '"'+line[0]+'","'+line[1]+'","'+line[2]+'"'+"\n"

with open("out.csv", "w", encoding="utf-8") as file:
    file.write(string)