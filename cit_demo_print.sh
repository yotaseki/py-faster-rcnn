
# [1] Images dir
echo "---------------------"
LIST=`ls data/faster_rcnn_models/ |grep caffemodel | grep random |grep -v CIT`
for a in $LIST ;do
	echo $a
done
echo "---------------------"
echo -n "OK?(y/n)"
read c
if [ $c == 'y' ] ;then
	for MODEL in $LIST
	do
		FN=`echo ${MODEL} |sed "s/.caffemodel//" |sed "s/CIT_//"`
		mkdir ${FN}_predicts
		./tools/cit_print.py --gpu 1 $1 ${MODEL}
		mv $1*_predict.txt ${FN}_predicts
	done
fi
