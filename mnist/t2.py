#!/usr/bin/env python

import sys
import numpy as np
import random as ran
import tensorflow as tf
import matplotlib.pyplot as plt
from ImageFile import *
from LabelFile import *
from util import *

fn_trn_img = "train-images-idx3-ubyte"
fn_trn_lbl = "train-labels-idx1-ubyte"
fn_tst_img = "t10k-images-idx3-ubyte"
fn_tst_lbl = "t10k-labels-idx1-ubyte"

trn_img = ImageFile(fn_trn_img)
trn_lbl = LabelFile(fn_trn_lbl)
tst_img = ImageFile(fn_tst_img)
tst_lbl = LabelFile(fn_tst_lbl)

# plot aggregated first N image vectors
N=400
imgplot = plt.imshow(trn_img.image_data[:N], cmap='gray_r')
plt.show()

# plot a single digit
display_digit_image(k=80, img=tst_img, lbl=tst_lbl)


# data augmentation routines
def rotate(img):
  # TODO
  return img

def translate(img):
  # TODO
  return img

def skew(img):
  # TODO
  return img

def bin_noise(img, k):
  img_1d = img.image_data[k]
  # binary noise vector
  #  n = np.random.randint(low=0, high=2, size=img_1d.size)
  n = np.random.randint(low=0, high=2, size=784)
  noisy_image = n * img_1d
  return (noisy_image, img.nrows, img.ncols)

def noise(img, k):
  img_1d = img.image_data[k]
  # binary noise vector
  #  n = np.random.randint(low=0, high=2, size=img_1d.size)
  max_val = 1<<8
  n = np.random.randint(low=0, high=max_val, size=784)
  noisy_image = (n * img_1d) / max_val
  noisy_image.astype(int)
  return (noisy_image, img.nrows, img.ncols)

# experimental - add noise
noisy_image, nrows, ncols = noise(tst_img, k=80)
noisy_image_2d = np.reshape(noisy_image, (nrows, ncols))
imgplot = plt.imshow(noisy_image_2d, cmap='gray_r')
plt.show()



def display_digits(img_list, img, lbl):
  fig = plt.figure()
  nimages = len(img_list)

  for i in nimages:
    sp=fig.add_subplot(1,nimages,i+1)
    label = lbl.label_data[k+i]
    print("display digit for label: {}". format(label))
    image_2d = img_list[i]
    imgplot = plt.imshow(image_2d, cmap='gray_r') # reverse colormap
    plt.title("Digit: {}".format(label))
  plt.show()


# experiment - plot a list of digits
img_list = [noisy_image_2d, noisy_image_2d]
display_digits(img_list(), img=tst_img, lbl=tst_lbl)


def bnd_box(img):
  nw = (0,0)
  se = (0,0)
  return (nw, sw)


'''
norm_image_data = normalize(trn_img.image_data)
'''
