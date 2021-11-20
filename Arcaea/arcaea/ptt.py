

file = open("ptt.txt","r",encoding="utf-8")
data=[]
for i in file:
    data.append(i.strip())


while True:
    raw=input("< ")
    
    for i in data:
        if raw.lower() in i.lower():
            print(i)
