#!/usr/bin/env python
'''
Read the spec (below) and inspect a binary file:
hexdump -C train-images-idx3-ubyte |more
-----------------------------------------------------------
TRAINING SET LABEL FILE (train-labels-idx1-ubyte):

[offset] [type]          [value]          [description]
0000     32 bit integer  0x00000801(2049) magic number (MSB first)
0004     32 bit integer  60000            number of items
0008     unsigned byte   ??               label
0009     unsigned byte   ??               label
........
xxxx     unsigned byte   ??               label
The labels values are 0 to 9.
-----------------------------------------------------------
'''
import sys
import numpy as np

class LabelFile:
  "Class reads binary ImageFile and extracts data"
  def __init__(self, filename):
    "Read file and extract data"

    self.seek_ptr = 0
    self.nimages = 0
    self.byte_count = 0

    self.description = "Read MNIST label file {} and extract data".format(filename)

    with open(filename, "rb") as bfile:
      fptr = 0
      bfile.seek(fptr)  # goto beginning of file
      nbytes=4
      chunk = bfile.read(nbytes)
      chunki = map(ord, chunk)
      if chunki == [0,0,8,1]:
        self.magic = 0x00000801
        self.byte_count += nbytes
      else:
        sys.exit('file magic number 0x00000801 not found')

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

      # pointer to beginning of image label data
      self.seek_image_ptr = fptr + nbytes

      # done reading metadata, now get image label data bytes
      self.label_size = 1
      self.label_data = []

      for i in xrange(self.nimages):
        fptr += nbytes
        # image size is nrows x ncols pixels; one byte per pixel
        nbytes = self.label_size
        label = ord(bfile.read(nbytes))
        self.label_data.append(label)
        self.byte_count += nbytes

if __name__ == "__main__":
  filename = "t10k-labels-idx1-ubyte"
  label = LabelFile(filename)

  print("Summary statisics on file: {}".format(filename))
  print("-----------------------------------------------")
  print("Number of image labels:\t{}".format(label.nimages))
  print("File size in bytes:\t{}".format(label.byte_count))
  print("-----------------------------------------------")
  print("Image #100-104 label data")
  print(label.label_data[100])
  print(label.label_data[101])
  print(label.label_data[102])
  print(label.label_data[103])
