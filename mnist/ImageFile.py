#!/usr/bin/env python
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
import sys
import numpy as np

class ImageFile:
  "Class reads binary ImageFile and extracts data"
  def __init__(self, filename):
    "Read file and extract data"

    self.seek_ptr = 0
    self.nrows = 0
    self.ncols = 0
    self.nimages = 0
    self.byte_count = 0

    self.description = "Read MNIST image file {} and extract data".format(filename)

    with open(filename, "rb") as bfile:
      fptr = 0
      bfile.seek(fptr)  # goto beginning of file
      nbytes=4
      chunk = bfile.read(nbytes)
      chunki = map(ord, chunk)
      if chunki == [0,0,8,3]:
        self.magic = 0x00000803
        self.byte_count += nbytes
      else:
        sys.exit('file magic number 0x00000803 not found')

      fptr += nbytes
      nbytes=4
      chunk = bfile.read(nbytes)
      chunki = map(ord, chunk)
      chunki.reverse()
      scale = 1
      for d in chunki:
        self.nimages += d*scale
        scale *= 256
      self.byte_count += nbytes

      fptr += nbytes
      nbytes = 4
      chunk = bfile.read(nbytes)
      chunki = map(ord, chunk)
      chunki.reverse()
      scale = 1
      for d in chunki:
        self.nrows += d*scale
        scale *= 256
      self.byte_count += nbytes

      fptr += nbytes
      nbytes=4
      chunk = bfile.read(nbytes)
      chunki = map(ord, chunk)
      chunki.reverse()
      scale = 1
      for d in chunki:
        self.ncols += d*scale
        scale *= 256
      self.byte_count += nbytes

      # pointer to beginning of image data
      self.seek_image_ptr = fptr + nbytes

      # done reading metadata, now get image data
      # one image per row; row size is nrows * ncols
      self.image_size = self.nrows * self.ncols
      self.image_data = np.zeros(shape = (self.nimages, self.image_size))

      for i in xrange(self.nimages):
        fptr += nbytes
        # image size is nrows x ncols pixels; one byte per pixel
        nbytes = self.image_size
        pixels = bfile.read(nbytes)
        pixelsi = map(ord, pixels)
        self.byte_count += nbytes

        pixels_array = np.array(pixelsi)
        # store all image data in memory
        # for huge data sets do this in sets with
        # method (get_set) to populate next set
        # keeping track of where we are in the whole set
        self.image_data[i] = pixels_array

  def get_image_2d(self, k):
    image_1d = self.image_data[k]
    return np.reshape(image_1d, (self.nrows, self.ncols))


if __name__ == "__main__":
  #filename = "train-images-idx3-ubyte"
  filename = "t10k-images-idx3-ubyte"
  img = ImageFile(filename)

  print("Summary statisics on file: {}".format(filename))
  print("-----------------------------------------------")
  print("Number of images:\t{}".format(img.nimages))
  print("Image size (pixels):\t{}".format(img.image_size))
  print("Rows per image:\t{}".format(img.nrows))
  print("Columns per image:\t{}".format(img.ncols))
  print("File size in bytes:\t{}".format(img.byte_count))
  print("-----------------------------------------------")
  print("Image #100 pixel data")
  print("-----------------------------------------------")
  print(img.image_data[100])
