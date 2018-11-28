import numpy as np
import matplotlib.pyplot as plt


def display_digit_image(k, img, lbl):
  '''Plot one handwritten digit from file at index k'''
  label = lbl.label_data[k]
  print(label)
  image_2d = img.get_image_2d(k)
  imgplot = plt.imshow(image_2d, cmap='gray_r') # reverse colormap
  plt.title("Digit: {}".format(label))
  plt.show()

def display_nxndigits_image(n, k, img, lbl):
  '''Plot a matrix of nxn handwritten digits from file starting at index k'''
  fig = plt.figure()
  for i in range(n*n):
    sp=fig.add_subplot(n,n,i+1)
    label = lbl.label_data[k+i]
    print("display digit for label: {}". format(label))
    image_2d = img.get_image_2d(k+i)
    imgplot = plt.imshow(image_2d, cmap='gray_r') # reverse colormap
    plt.title("Digit: {}".format(label))
  plt.show()
