import os


res=""
for i in os.listdir("D:\\Desktop\\KSCG\\image"):
    if i[-4:]==".png":

        i=i[:-4]
        
        res+='{"'+i+'",'+'"file:///D:/Desktop/KSCG/image/'+i+'.png"'+'},'+'\n'
        print(i)

with open('D:\Desktop\KSCG\list.txt','w',encoding="UTF-8") as l:
    l.write(res)