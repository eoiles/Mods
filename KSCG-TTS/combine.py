
from PIL import Image

import os


imgs=[]
for i in os.listdir("D:\\Desktop\\KSCG\\image"):
    i="D:\\Desktop\\KSCG\\image\\"+i
    imgs.append(Image.open(i))



#w, h = 229,314
w, h = 229,314
cols,rows=40,14

grid = Image.new('RGB', size=(cols*w, rows*h))
grid_w, grid_h = grid.size

for i, img in enumerate(imgs):
    grid.paste(img, box=(i%cols*w, i//cols*h))

grid.save('D:\\Desktop\\KSCG\\all.png')


