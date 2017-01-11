#!/usr/bin/env python

# --------------------------------------------------------
# Faster R-CNN
# Copyright (c) 2015 Microsoft
# Licensed under The MIT License [see LICENSE for details]
# Written by Ross Girshick
# --------------------------------------------------------

"""
Demo script showing detections in sample images.

See README.md for installation instructions before running.
"""

import _init_paths
from fast_rcnn.config import cfg
from fast_rcnn.test import im_detect
from fast_rcnn.nms_wrapper import nms
from utils.timer import Timer
import matplotlib.pyplot as plt
import numpy as np
import scipy.io as sio
import caffe, os, sys, cv2
import argparse
import glob

CLASSES = ('__background__',
            'ball')

NETS = {'vgg16': ('VGG16',
                  'VGG16_faster_rcnn_final.caffemodel'),
        'zf': ('ZF',
                  'ZF_faster_rcnn_final.caffemodel'),
        'cit':('CIT_ZF',
#                  'CIT_142rotate_faster_rcnn_final.caffemodel')
#                  'CIT_Ball_faster_rcnn_final.caffemodel')
#                  'CIT_VGAcompose_faster_rcnn_final.caffemodel')
#                  'CIT_142rand_faster_rcnn_final.caffemodel')
#                  'CIT_af1300_faster_rcnn_final.caffemodel')
#                  'CIT_af1300_ZF_faster_rcnn_final.caffemodel')
                  'CIT_VGA_ZF_faster_rcnn_final.caffemodel')
}

def vis_detections(image_name, im, class_name, dets, thresh=0.5):
    """Draw detected bounding boxes."""
    print(" * THRESHOLD: " + str(thresh))
    NUM = ('%01.3f' % thresh)
    inds = np.where(dets[:, -1] >= thresh)[0]
    filename = image_name.rstrip('.jpg')
    filename = filename.rstrip('.png')
    filename = filename + '_predict_th'+NUM+'.txt'
    fp = open(filename,'w')
    if len(inds) == 0:
#        im_ = im[:, :, (2, 1, 0)]
#        fig, ax = plt.subplots(figsize=(12, 12))
#        ax.imshow(im_, aspect='equal')
#        ax.set_title('{}\n The ball does not exist'.format(image_name))
#        plt.axis('off')
#        plt.tight_layout()
#        plt.draw()
        fp.write('-1 -1 -1 -1 -1 ')
        fp.close()
        return
    
#    im_ = im[:, :, (2, 1, 0)]
#    fig, ax = plt.subplots(figsize=(12, 12))
#    ax.imshow(im_, aspect='equal')
    for i in inds:
        bbox = dets[i, :4]
        score = dets[i, -1]
        
        fp.write('0 '+str(int(bbox[0]))+' '+str(int(bbox[1]))+' '+str(int(bbox[2]))+' '+str(int(bbox[3]))+' \n')
#        
#        ax.add_patch(
#            plt.Rectangle((bbox[0], bbox[1]),
#                          bbox[2] - bbox[0],
#                          bbox[3] - bbox[1], fill=False,
#                          edgecolor='red', linewidth=3.5)
#            )
#        ax.text(bbox[0], bbox[1] - 2,
#                '{:s} {:.3f}'.format(class_name, score),
#                bbox=dict(facecolor='blue', alpha=0.5),
#                fontsize=14, color='white')
#    
    fp.close()
#    ax.set_title(('{}\n{} detections with '
#                  'p({} | box) >= {:.1f}').format(image_name, class_name, class_name,
#                                                  thresh),
#                  fontsize=14)
#    plt.axis('off')
#    plt.tight_layout()
#    plt.draw()

def demo(net, image_name):
    """Detect object classes in an image using pre-computed object proposals."""
    print '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    print 'Demo for {}'.format(image_name)
    # Load the demo image
    #im_file = os.path.join(cfg.DATA_DIR, 'data/train', image_name)
    im = cv2.imread(image_name)

    # Detect all object classes and regress object bounds
    timer = Timer()
    timer.tic()
    scores, boxes = im_detect(net, im)
    timer.toc()
    print ('Detection took {:.3f}s for '
           '{:d} object proposals').format(timer.total_time, boxes.shape[0])

    # Visualize detections for each class
    CONF_THRESH = args.thresh
    NMS_THRESH = 0.3
    for cls_ind, cls in enumerate(CLASSES[1:]):
        cls_ind += 1 # because we skipped background
        cls_boxes = boxes[:, 4*cls_ind:4*(cls_ind + 1)]
        cls_scores = scores[:, cls_ind]
        dets = np.hstack((cls_boxes,
                          cls_scores[:, np.newaxis])).astype(np.float32)
        keep = nms(dets, NMS_THRESH)
        dets = dets[keep, :]
        for i_thre in range(101):
            if i_thre == 0:
                CONF_THRESH = 0.0
            elif i_thre == 100:
                CONF_THRESH = 1.0
            else:
                CONF_THRESH = float(i_thre)/100
            vis_detections(image_name, im, cls, dets, thresh=CONF_THRESH)

def parse_args():
    """Parse input arguments."""
    parser = argparse.ArgumentParser(description='Faster R-CNN demo')
    parser.add_argument('images')
    parser.add_argument('model')
    parser.add_argument('--dev', dest='fvideo', help='Demo webcam',
                        default=-1, type=int)
    parser.add_argument('--gpu', dest='gpu_id', help='GPU device id to use [0]',
                        default=0, type=int)
    parser.add_argument('--cpu', dest='cpu_mode',
                        help='Use CPU mode (overrides --gpu)',
                        action='store_true')
    parser.add_argument('--net', dest='demo_net', help='Network to use [vgg16]',
                        choices=NETS.keys(), default='cit')
    parser.add_argument('--thresh', dest='thresh', help='threshold',
                        choices=NETS.keys(), default=.8)

    args = parser.parse_args()

    return args

if __name__ == '__main__':
    cfg.TEST.HAS_RPN = True  # Use RPN for proposals

    args = parse_args()

    prototxt = os.path.join(cfg.MODELS_DIR, NETS[args.demo_net][0],
                            'faster_rcnn_alt_opt', 'faster_rcnn_test.pt')
    caffemodel = os.path.join(cfg.DATA_DIR, 'faster_rcnn_models',
                              args.model)

    if not os.path.isfile(caffemodel):
        raise IOError(('{:s} not found.\nDid you run ./data/script/'
                       'fetch_faster_rcnn_models.sh?').format(caffemodel))

    if args.cpu_mode:
        caffe.set_mode_cpu()
    else:
        caffe.set_mode_gpu()
        caffe.set_device(args.gpu_id)
        cfg.GPU_ID = args.gpu_id
    net = caffe.Net(prototxt, caffemodel, caffe.TEST)

    print '\n\nLoaded network {:s}'.format(caffemodel)

    # Warmup on a dummy image
    im = 128 * np.ones((300, 500, 3), dtype=np.uint8)
    for i in xrange(2):
        _, _= im_detect(net, im)

    fn_filter = ''
    im_names = glob.glob(args.images + fn_filter +'*.jpg')
    im_names += glob.glob(args.images + fn_filter +'*.png')
    im_names.sort()
    for im_name in im_names:
        demo(net, im_name)
    #plt.show()
