import websocket
import brotli
import json

def query(uid: str):

    keys=['song_id', 'difficulty','score','perfect_count','shiny_perfect_count', 'near_count','miss_count', 'constant', 'rating']
    
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

            if obj['cmd'] == 'songtitle':
                songnamedict = obj['data']

            
            if obj['cmd'] == 'userinfo':
                result = obj['data']['recent_score'][0]
                result=[result[i] for i in keys] 
    
    return result,songnamedict

def calc(pure,bpure,far,lost,songptt):
    eoscore=0
    eoptt=0
    
    bit=10000000/(pure+far+lost)/4
    eoscore=4*bpure*bit+\
           3*(pure-bpure)*bit+\
           2*far*bit
    
    eoptt=(songptt+2)*eoscore/10000000

    return eoscore,eoptt

def diff(x:int):
    if x==0:
        return "PST"
    elif x==1:
        return "PRS"
    elif x==2:
        return "FTR"

def formata(infotuple:tuple):
    
    info=infotuple[0]

    spure=0
    pure,bpure,far,lost=info[3:7]
    
    spure=pure-bpure
    
    songnamedict=infotuple[1]

    songname=""
    songname=songnamedict[info[0]]['en']
    
    result = songname+" "+diff(info[1])+"\n"+str(info[2])\
             +" "+str(info[7])+"->"+str(round(info[8],2))\
             +"\n"+str(pure)+" "+str(bpure)+"+"+str(spure)\
             +" "+str(far)+" "+str(lost)


    return result

def formatb(info:list):

    result = info[0]+"["+diff(info[1])+"]\n"+str(info[2])+str(calc(*info[3:8]))
    return result

def querya(uid:str):
    return formata(query('224746807'))


def bind(qq:str,uid:str):
    with open("uid.txt","r") as file:
        d=json.load(file)
        d[qq]=uid
    with open("uid.txt","w") as file:
        json.dump(d, file)

def queryafromqq(qq:str):
    uid=""
    res=""
    with open("uid.txt","r") as file:
        d=json.load(file)
        try:
            uid=d[qq]
            res=querya(uid)
        except:
            res="user not found\n`bind uid to bind"
            
    return res            
        
