#!/bin/sh
rm data/cache/train_gt_roidb.pkl
./tools/train_faster_rcnn_alt_opt.py --gpu 0 --net_name CIT_Ball_${1} --weights ${2} --imdb cit_train --cfg models/config.yml
