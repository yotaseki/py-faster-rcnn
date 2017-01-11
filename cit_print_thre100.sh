
# [1] Images dir
echo "---------------------"
LIST="$LIST "
#LIST="$LIST "
#LIST="$LIST "
for a in $LIST ;do
	basename $a
done
echo "---------------------"
echo -n "OK?(y/n)"
read c
if [ $c == 'y' ] ;then
	for MODEL in $LIST
	do
		MODEL=`basename $MODEL`
		FN=`basename ${MODEL} |sed "s/.caffemodel//" |sed "s/CIT_//"`
		mkdir ${FN}_predicts
		./tools/cit_print_thre100.py --gpu 1 $1 ${MODEL}
		mv $1*_predict.txt ${FN}_predicts
	done
fi
