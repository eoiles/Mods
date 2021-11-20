
from slpp import slpp as lua

path = "C:/Users/stary/Desktop/Hades/"
with open(path+"TraitData.txt", "r", encoding="utf-8") as file:
    data = file.read()

    data = lua.decode(data)

with open(path+"GUIAnimations.txt", "r", encoding="utf-8") as file:
    links = file.read()

    links = lua.decode(links)

    if links[-1] == "/":

        links = links[:-1]


# with open(path+"HelpText.en.txt", "r", encoding="utf-8") as file:
#     descriptions = file.read()

#     descriptions=descriptions.replace("\n",",")

#     descriptions = lua.decode(descriptions)


traitdict = {}

for i in data:

    try:
        name = data[i]["Icon"]

        if name not in traitdict:
            traitdict[i]=[]
            traitdict[i].append(name+"_Large")

    except:
        pass




for i in traitdict:


    for j in links:

        try:
            
            if j["Name"] == traitdict[i][0]:
                
                traitdict[i].append(j["FilePath"])

        except:
            pass

resdict={}
for i in traitdict:
    if len(traitdict[i])==2:
        resdict[i]=traitdict[i]

print(len(traitdict))

imgpath="C:\\Users\\stary\\Desktop\\Hades\\GUI\\textures\\"


with open("C:/Users/stary/Desktop/Hades/data.csv","w",encoding="utf-8") as file:
    for i in resdict:
        print(i)

        line='{"'+i+'","'+imgpath+resdict[i][1]+'.png"},\n'
        line=line.replace('\\','/')
        file.write(line)

