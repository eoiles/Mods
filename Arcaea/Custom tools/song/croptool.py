import re
import os
import sys
from pydub import AudioSegment

def formatrawsongmap(raw):
    raw=raw.split("\n")
    head="\n".join(raw[0:3])+"\n"
    rest="\n".join(raw[3:])
    return {'head':head,'rest':rest}


def slicesongmap(songmap,a,b):
    output=[]
    songmap=songmap.split('\n')
    
    timere="(.*[(])(\d+)(,.+)"

    for i in songmap:
        time= int(re.match(timere,i).group(2))
        if a <= time and time < b:
            output.append(i)
            
    songmap="\n".join(output)

    #reset songmap position to beagin
    shift=a
    songmap=offsetsongmap(songmap,-shift)
    
    
    return songmap


def repeatsongmap(songmap,n,reallength):

    output=[]

    for i in range(n):
        output.append(offsetsongmap(songmap,i*reallength))
        
    output="\n".join(output)
    
    return output


def offsetsongmap(songmap,n):

    def plus(s,y):
        return str(int(s)+y)
    
    arc="(arc[(])([\d]+)(,)([\d]+)"
    def arcr(s):
        
        a=plus(s.group(2),n)
        b=plus(s.group(4),n)
            
        return s.group(1)+a+s.group(3)+b


    arctap="(arctap[(])([\d]+)"
    def arctapr(s):

        a=plus(s.group(2),n)

        return s.group(1)+a

    tap="([(])([\d]+)([,][\d][)][;])"
    def tapr(s):
        a=plus(s.group(2),n)
        return s.group(1)+a+s.group(3)

    hold="(hold[(])([\d]+)(,)(\d+)"
    def holdr(s):

        a=plus(s.group(2),n)
        b=plus(s.group(4),n)

        return s.group(1)+a+s.group(3)+b

    timing="(timing[(])(\d+)"
    def timingr(s):

        a=plus(s.group(2),n)

        return s.group(1)+a
    
    
    res=songmap
    res=re.sub(arc,arcr,res)
    res=re.sub(arctap,arctapr,res)
    res=re.sub(tap,tapr,res)
    res=re.sub(hold,holdr,res)
    res=re.sub(timing,timingr,res)
    return res

def scalesongmap(songmap,n):

    n=1/n
    
    def times(s,y):
        return str(int(int(s)*y))
    
    arc="(arc[(])([\d]+)(,)([\d]+)"
    def arcr(s):
        
        a=times(s.group(2),n)
        b=times(s.group(4),n)
            
        return s.group(1)+a+s.group(3)+b


    arctap="(arctap[(])([\d]+)"
    def arctapr(s):

        a=times(s.group(2),n)

        return s.group(1)+a

    tap="([(])([\d]+)([,][\d][)][;])"
    def tapr(s):
        a=times(s.group(2),n)
        return s.group(1)+a+s.group(3)


    hold="(hold[(])([\d]+)(,)(\d+)"
    def holdr(s):

        a=times(s.group(2),n)
        b=times(s.group(4),n)

        return s.group(1)+a+s.group(3)+b

    
    timing="(timing[(])(\d+)"
    def timingr(s):

        a=times(s.group(2),n)

        return s.group(1)+a
    
    res=songmap
    res=re.sub(arc,arcr,res)
    res=re.sub(arctap,arctapr,res)
    res=re.sub(tap,tapr,res)
    res=re.sub(hold,holdr,res)
    res=re.sub(timing,timingr,res)
    return res

def scalemusic(sound, speed=1.0):

    sound_with_altered_frame_rate = sound._spawn(sound.raw_data, overrides={
         "frame_rate": int(sound.frame_rate * speed)})

    return sound_with_altered_frame_rate.set_frame_rate(sound.frame_rate)


def absongmap(rawsongmap,a,b,n):
    formatted=formatrawsongmap(rawsongmap)


    def gettiminglist(rawsongmap):
        timing="timing[(](\d+)(.+)"

        #(time,timing)
        timinglist=re.findall(timing,rawsongmap)

        return timinglist

    def privioustimingrest(timinglist,time):

        #(time:str,timingrest)
        #timingrest =210.00,4.00);
        rest=timinglist[0][1]
        for i in timinglist:
            
            itime=int(i[0])
            irest=i[1]
            
            if itime <= time:
                rest=irest
            else:
                return rest
        return rest
        
    #used external variable rawsongmap,a
    def replaceheadtiming(head):

        res=head
        timing="(timing[(])(\d+)(.+)"

        timinglist=gettiminglist(rawsongmap)
        time=a
        timingr="timing(0"+privioustimingrest(timinglist,time)

        res=re.sub(timing,timingr,head)
        return res

    head=formatted['head']
    head=replaceheadtiming(head)
    
    rest=formatted['rest']

    
    chip=slicesongmap(rest,a,b)
    length=b-a
    rest=repeatsongmap(chip,n,length)

    output=head+rest

    return output



def abmusic(rawmusic,a,b,n):
    chip = rawmusic[a:b]

    outmusic=chip
    for i in range(0,n-1):
        outmusic=outmusic+chip

    return outmusic


def absong(songpath,a,b,n,scale=1,songmapname="",musicname="",name=""):

    os.chdir(songpath)

    def getaudiooffset(raw):
        aor="(AudioOffset:)(.+)"
        audiooffset=int(re.match(aor,raw).group(2))
        return audiooffset

    def resetsongmap(raw):
        raw=raw.split("\n")
        raw[0]="AudioOffset:0"
        raw="\n".join(raw)
        return raw

    def resetmusic(raw,offset):

        length=abs(offset)
        blank=AudioSegment.silent(duration=length)
        
        if offset>0:
            raw=raw[length:]+blank
            
        elif offset<0:
            raw=blank+raw

        return raw
            
    #initialize song
    song={"songmap":None,"music":None}

    #didn't specify songmap and music name, grab all by defalut.
    if songmapname+musicname=="":
        filelist = os.listdir(songpath)
        for i in filelist:
            if '+' not in i:
                if '.aff' in i:
                    song["songmap"]=i
                    
                elif '.ogg' in i:
                    song["music"]=i
                    
    #specify songmap and music name
    elif songmapname!="" and musicname!="":
        song["songmap"]=songmapname+".aff"
        song["music"]=musicname+".ogg"

    #import songmap and music
    rawsongmap=open(song["songmap"]).read()
    rawmusic = AudioSegment.from_file(song["music"],format="ogg")

    #calibrate songmap and music
    songmap=resetsongmap(rawsongmap)
    music=resetmusic(rawmusic,getaudiooffset(rawsongmap))

    #convert songmap and music
    songmap=absongmap(songmap,a,b,n)
    music=abmusic(music,a,b,n)

    #scale songmap and music
    if scale!=1:
        songmap=scalesongmap(songmap,scale)
        music=scalemusic(music,scale)
        
    #export songmap and music
    with open(name+"+"+song["songmap"],"w") as outsongmap:
            outsongmap.write(songmap) 
    music.export(name+"+"+song["music"], format="ogg")

    return True



file = sys.argv[1]

path=""
songmapname=""
musicname=""
outputname=""
a=0
b=0
n=0
scale=0

if os.path.isfile(file):
    file = open(file).read()
    lines=file.split("\n")
    for i in lines:
        if i[0] == "[" and i[-1] == "]":
            path=i[1:-1]
            
        elif i.count(",") == 1:
            songmapname,musicname=i.split(",")
            
        elif i.count(",") == 3:
            data=i.split(",")
            
            a=int(int(data[0])*1000)
            b=int(int(data[1])*1000)
                  
            n=int(data[2])
            scale=float(data[3])

            outputname=i.replace(",","+")
            absong(path,a,b,n,scale,songmapname,musicname,name=outputname)
            
    
