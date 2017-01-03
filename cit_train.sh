#!/bin/bash
# ${1} ZF
# ${2} train.txt dir
echo "LIST:"
LIST=`ls -d ${2}/* |grep random |grep -v list |grep -v train`
for i in ${LIST};do
	echo " ${i}"
done
echo -n "OK?(y/n)"
read c

if [ $c == 'y' ] ;then
	for i in ${LIST} ;do
		OUTPUT=`basename ${i} |sed "s/.txt//"`
		OUTPUT=${1}_${OUTPUT}_increase.caffemodel
		rm ${2}/train.txt
		ln -s ${i} ${2}/train.txt
		#echo $OUTPUT
		#file ${2}/train.txt
		rm data/cache/train_gt_roidb.pkl
		./tools/train_faster_rcnn_alt_opt.py --gpu 1 --net_name CIT_Ball_${1} --weights data/imagenet_models/${1}.v2.caffemodel --imdb cit_train --cfg models/config.yml
		mv output/default/train/CIT_Ball_ZF_faster_rcnn_final.caffemodel data/faster_rcnn_models/${OUTPUT}
	done
fi
