rm gif/*
./tools/cit_gif.py $1
rename "s;gif/;gif/00;" gif/?.png
rename "s;gif/;gif/0;" gif/??.png
convert -delay 30 gif/*.png result.gif
rm gif/*
eog result.gif

