#!/bin/bash
# ${1} ZF
echo "LIST:"
# --- ここに学習させたいテキストのフルパスを追加 ---
#LIST="$LIST ~/a.txt" #example
LIST="$LIST "

# --------------------------------------------------
IMAGESETS="data/CIT_Ball_devkit/data/ImageSets/"

for i in ${LIST};do
        echo "*******************"
	echo "TRAINTXT: ${i}"
	rm ${IMAGESETS}/train.txt
        ln -s ${i} ${IMAGESETS}/train.txt
        echo -n "SYMLINK:"
        file ${IMAGESETS}/train.txt
done
echo -n "OK?(y/n)"
read c

if [ $c == 'y' ] ;then
	for i in ${LIST} ;do
		OUTPUT=`basename ${i} |sed "s/.txt//"`
                export LOG="${OUTPUT}.log"
		OUTPUT=${1}_${OUTPUT}.caffemodel
		rm ${IMAGESETS}/train.txt
		ln -s ${i} ${IMAGESETS}/train.txt
		#echo $OUTPUT
		#file ${IMAGESETS}/train.txt
		rm data/cache/train_gt_roidb.pkl
		./tools/train_faster_rcnn_alt_opt.py --gpu 1 --net_name CIT_Ball_${1} --weights data/imagenet_models/${1}.v2.caffemodel --imdb cit_train --cfg models/config.yml > ${LOG}
		mv output/default/train/CIT_Ball_ZF_faster_rcnn_final.caffemodel data/faster_rcnn_models/${OUTPUT}
	done
fi
