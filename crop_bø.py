import Image
from glob import glob
import os
import sys

os.system("mkdir %s/cropped" % (sys.argv[1]))

for img_number, img_name in enumerate(sorted(glob("%s/*.png" % (sys.argv[1])))):
    img_obj = Image.open(img_name)
    left = 198
    top = 148
    width = 1090
    height = 1090
    box = (left, top, left+width, top+height)
    img_obj.crop(box).save("%s/cropped/image%05d.png" % (sys.argv[1], img_number))
