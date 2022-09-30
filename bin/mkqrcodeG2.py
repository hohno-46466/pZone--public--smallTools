#!/opt/homebrew/opt/coreutils/libexec/gnubin/env python3

# mkqrcode-tmp.py

# First version: Thu Sep 15 07:19:30 JST 2022

import os
import sys
import qrcode

HOME=os.environ['HOME'];
QRcode='https://goo.gl/bgEJB9' # <-- default URL
outfile = HOME + "/tmp/QRoutput.gif"
#outfile = HOME + "/tmp/qrsample.gif"

args=sys.argv
if (len(args) >= 2): QRcode=args[1]
print("URL: " + QRcode)

qr = qrcode.QRCode(version=3, error_correction=qrcode.constants.ERROR_CORRECT_L, box_size=6, border=4)
#qr.add_data('https://bit.ly/3bzbn0T')
qr.add_data(QRcode)

img = qr.make_image(fill_color="black", back_color="white")
img.save(outfile)

print("output: " + outfile)

# FYI: See slso https://engineer-lifestyle-blog.com/code/python/qrcode-generator-save-reader-with-sample-code/

