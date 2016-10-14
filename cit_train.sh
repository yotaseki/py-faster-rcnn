#!/bin/sh
./tools/train_faster_rcnn_alt_opt.py --gpu 0 --net_name CIT_Ball --weights data/imagenet_models/VGG_CNN_M_1024.v2.caffemodel --imdb cit_train --cfg models/config.yml
