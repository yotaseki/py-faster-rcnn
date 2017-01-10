#!/bin/bash
echo "LIST:"

# --- 学習に使うモデル --- #
MODEL=ZF
#MODEL=VGG16

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
		OUTPUT=${MODEL}_${OUTPUT}.caffemodel
		rm ${IMAGESETS}/train.txt
		ln -s ${i} ${IMAGESETS}/train.txt
		#echo $OUTPUT
		#file ${IMAGESETS}/train.txt
		rm data/cache/train_gt_roidb.pkl
		./tools/train_faster_rcnn_alt_opt.py --gpu 1 --net_name CIT_Ball_${MODEL} --weights data/imagenet_models/${MODEL}.v2.caffemodel --imdb cit_train --cfg models/config.yml # > ${LOG}
		mv output/default/train/CIT_Ball_ZF_faster_rcnn_final.caffemodel data/faster_rcnn_models/${OUTPUT}
	done
fi
