
# [1] Images dir
echo "DIRNAME ----------------"
DIRNAME=thresh_af1300
echo "CAFFEMODEL--------------"
LIST="$LIST "
#LIST="$LIST "
#LIST="$LIST "
for a in $LIST ;do
	basename $a
done
echo "---------------------"
echo -n "OK?(y/n)"
read c
mkdir ${DIRNAME}
if [ $c == 'y' ] ;then
    for MODEL in $LIST ;do
        for i in `seq 0 101` ;do
                NUM=`printf "%03d" ${i}`
		MODELBASE=`basename ${MODEL}`
		FN=`basename ${MODEL} |sed "s/.caffemodel//" |sed "s/CIT_//"`
                SUB_DIR="${FN}_thre${NUM}_predicts"
		./tools/cit_print.py --gpu 1 --thresh ${i} $1 ${MODEL}
		mkdir ${DIRNAME}/${SUB_DIR}
		mv $1/*_predict.txt ${DIRNAME}/${SUB_DIR}
	done
    done
fi
