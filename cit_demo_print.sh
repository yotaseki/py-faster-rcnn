mkdir bbox_predicts
rm bbox_predicts/*
./tools/cit_print.py $1
mv $1*_predict.txt bbox_predicts
