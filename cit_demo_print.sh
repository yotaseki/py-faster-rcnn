mkdir pos_result
rm pos_result/*
./tools/cit_print.py $1
mv $1*_result.txt pos_result/
