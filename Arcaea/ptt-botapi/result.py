
import websocket
import brotli
import json

def query(uid: str):

    
    ws = websocket.create_connection("wss://arc.estertion.win:616/")
    ws.send(uid)
    buffer = ""

    result=[]

    while buffer != "bye":
        try:
            buffer = ws.recv()
        except websocket._exceptions.WebSocketConnectionClosedException:
            ws = websocket.create_connection("wss://arc.estertion.win:616/")
            ws.send(uid)
        if type(buffer) == type(b''):

            obj = json.loads(str(brotli.decompress(buffer), encoding='utf-8'))

            result.append(obj)
    
    return result

with open("result.txt","w",encoding="UTF-8") as file:
    raw=query("224746807 11.1 11.5")
    file.write(str(raw))

'''
keys=['song_id','difficulty','score','shiny_perfect_count','perfect_count','near_count','miss_count','rating','constant']
with open("result.txt","r",encoding="utf-8") as file:
    res=[]
    a=eval(file.read())
    for i in a :
        if i['cmd']=='scores':
            for j in i['data']:
                res.append(j)

result={}
r=[]
for i in res:
    if i["song_id"] in res:
        print("\nsame\n")
    result[i["song_id"]+str(i["difficulty"])]=i["constant"]
    
'''     
    
