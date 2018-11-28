#!/usr/bin/env python

import sys
import numpy as np
import matplotlib.pyplot as plt

if len(sys.argv) > 1:
  filename = sys.argv[1]
else:
  print("Warning: no read file specified")

'''
Read the spec (below) and inspect a binary file:
hexdump -C train-images-idx3-ubyte |more
-----------------------------------------------------------
TRAINING SET IMAGE FILE (train-images-idx3-ubyte):

[offset] [type]          [value]          [description]
0000     32 bit integer  0x00000803(2051) magic number
0004     32 bit integer  60000            number of images
0008     32 bit integer  28               number of rows
0012     32 bit integer  28               number of columns
0016     unsigned byte   ??               pixel
0017     unsigned byte   ??               pixel
........
xxxx     unsigned byte   ??               pixel
Pixels are organized row-wise. Pixel values are 0 to 255.
0 means background (white), 255 means foreground (black).
-----------------------------------------------------------
'''
byte_ctr = 0
img_ctr = 0
state = 0

with open(filename, "rb") as bfile:
    fptr = 0
    bfile.seek(fptr)  # goto beginning of file
    nbytes=4
    chunk = bfile.read(nbytes)
    chunki = map(ord, chunk)
    print(chunki)
    if chunki == [0,0,8,3]:
      state += 1
      byte_ctr += nbytes
    else:
      sys.exit('file magic number 0x00000803 not found')

    fptr += nbytes
    nbytes=4
    chunk = bfile.read(nbytes)
    chunki = map(ord, chunk)
    chunki.reverse()
    nimages = 0
    scale = 1
    for d in chunki:
      nimages += d*scale
      scale *= 256
    print("number of images: {}".format(nimages))
    byte_ctr += nbytes
    state += 1

    fptr += nbytes
    nbytes=4
    chunk = bfile.read(nbytes)
    chunki = map(ord, chunk)
    chunki.reverse()
    nrows = 0
    scale = 1
    for d in chunki:
      nrows += d*scale
      scale *= 256
    print("number of rows per image: {}".format(nrows))
    byte_ctr += nbytes
    state += 1

    fptr += nbytes
    nbytes=4
    chunk = bfile.read(nbytes)
    chunki = map(ord, chunk)
    chunki.reverse()
    ncols = 0
    scale = 1
    for d in chunki:
      ncols += d*scale
      scale *= 256
    print("number of cols per image: {}".format(ncols))
    byte_ctr += nbytes
    state += 1

    nagg=400
    aggregate_pixels = np.zeros(shape=(nagg, nrows*ncols))

    for i in xrange(nimages):
      fptr += nbytes
      nbytes=28*28
      pixels = bfile.read(nbytes)
      pixelsi = map(ord, pixels)
      byte_ctr += nbytes

      pixels_array = np.array(pixelsi)
      if i<nagg:
        aggregate_pixels[i] = pixels_array


    print("Total number of bytes read from file: {}".format(byte_ctr))

    # plot last image in file just for illustration
    # ref: https://matplotlib.org/users/image_tutorial.html
    pixels_2d = np.reshape(pixels_array, (nrows,ncols))
    print(pixels_2d)
    imgplot = plt.imshow(pixels_2d, cmap='gray_r') # reverse colormap
    plt.show()

    # plot last image as a 1D array
    x = np.arange(nrows*ncols)
    plt.plot(x, pixels_array)
    plt.show()

    # plot aggregated first 400 image vectors
    imgplot = plt.imshow(aggregate_pixels, cmap='gray_r')
    plt.show()
