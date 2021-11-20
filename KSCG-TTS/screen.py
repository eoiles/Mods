import pyautogui
import keyboard 
import pytesseract
import random


def savecard(image,x,y):
    

    left = x
    top = y
    right = left+229
    bottom = top+314

    im = image.crop((left, top, right, bottom))

    im1=im.crop((21,15,209,40))
    name=pytesseract.image_to_string(im1).strip()

    if name:
        path="D:\\Desktop\KSCG\\image\\" + name+".png"
        im.save(path)


points=[[301,280],[544,280],[787,280],[1030,280],
        [301,640],[544,640],[787,640],[1030,640]]

def takeashot():


    myScreenshot = pyautogui.screenshot()

    for x,y in points:
        savecard(myScreenshot,x,y)

    print(random.random())
    

keyboard.add_hotkey('z', takeashot, args =())

keyboard.wait('esc') 