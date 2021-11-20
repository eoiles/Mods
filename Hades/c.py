import sjson

with open("C:/Users/stary/Desktop/Hades/HelpText.zh-CN.sjson","r",encoding="utf-8") as file:
    file=file.read()
    data=sjson.loads(file)

print(data)