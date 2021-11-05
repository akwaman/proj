#!/usr/bin/env python

# Evaluate performance of different methods of vector dot product
# simple loops
# map
# list comprehension
# C extension with Swig
# numpy
# tensor flow

import numpy as np
import tensorflow as tf
import time
import matplotlib.pyplot as plt
import sys
import re
from random import randint

def print_help():
  print("\nEvaluate performance of different methods of vector dot product")
  print("  dotprod [nmax] <option>")
  print("  nmax : maximum size is 2**nmax, default is 20")
  print("  options:")
  print("  -h")
  print("  -plot\n")


doplot = 0
nmax = 22

for a in sys.argv:
  print( sys.argv)
  if re.search(r'\d+', a):
    print( "nmax = %s" % a)
    nmax = int(a)+1
  if a == "-plot":
    doplot = 1
  if a == "-h":
    print(_help())
    sys.exit()

iters = 5 # number of samples for mean execution time

def time_fun(fun, *arg, **kwarg):
  # calculate mean execution time of number of iterations
  sum = 0
  for i in range(iters):
    start_time = time.time()
    fun(*arg,**kwarg)
    sum += time.time()-start_time
  return sum/iters

def dprod_loop(a,b):
  acc = 0
  for i in range(len(a)):
    acc += a[i]*b[i]
  return acc

def dprod_map(a,b):
  return sum(map(lambda x: x[0]*x[1], zip(a,b)))

def dprod_comprehension(a,b):
  return sum([a[i]*b[i] for i in range(len(a))])

def dprod_numpy(a,b):
  return np.inner(np.array(a), np.array(b))

def dprod_tf(a,b):
  n=len(a)
  x = tf.placeholder(tf.int32, shape=(n))
  y = tf.placeholder(tf.int32, shape=(n))

  dot_x_y = tf.tensordot(x, y, 1)

  with tf.Session() as sess:
    start_time = time.time()
    dp = dot_x_y.eval(feed_dict={x: a, y: b})
    etime = time.time()-start_time

  return (dp, etime)


# test
n = 100
a = range(n)
b = [randint(0,9) for i in range(n)]
dp_loop = dprod_loop(a,b)
print("loop dot product: %d" % (dp_loop))
dp_map = dprod_map(a,b)
print("map dot product: %d" % (dp_map))
dp_comp = dprod_comprehension(a,b)
print("list comprehension dot product: %d" % (dp_comp))
dp_tf = dprod_tf(a,b)
print("tensor flow dot product: %d" % (dp_tf[0]))


if (dp_loop != dp_map or
    dp_loop != dp_comp or
    dp_loop != dp_tf[0] ):  # tensor flow func returns a tuple
  print("FAIL: Dot product calculation mismatch!")
  sys.exit()


exec_times = []

for i in range(nmax):
  exec_time = []
  n=2**i # size of the vector
  a = range(n)
  b = [randint(0,9) for i in range(n)]

  print("n = %d" % n)

  dp_time = time_fun(dprod_loop, a, b)
  print("  loop time: %f" % (dp_time))
  exec_time.append(dp_time)

  dp_time = time_fun(dprod_map, a, b)
  print("  map time: %f" % (dp_time))
  exec_time.append(dp_time)

  dp_time = time_fun(dprod_comprehension, a, b)
  print("  comp time: %f" % (dp_time))
  exec_time.append(dp_time)

  dp_time = time_fun(dprod_numpy, a, b)
  print("  numpy time: %f" % (dp_time))
  exec_time.append(dp_time)

  #dp_time = time_fun(dprod_tf, a, b)
  dp_time = dprod_tf(a, b)
  print("  tensorflow time: %f" % (dp_time[1]))
  exec_time.append(dp_time[1])

  exec_times.append((i, exec_time))


uzet = zip(*exec_times)
n = uzet[0]

uzet1 = zip(*uzet[1])
l = uzet1[0]
m = uzet1[1]
c = uzet1[2]
np = uzet1[3]
tf = uzet1[4]


if doplot:
    plt.plot(n, l, marker="o", label="simple loop")
    #plt.plot(n, m, marker="*", label="map")
    plt.plot(n, c, marker="v", label="list comprehension")
    plt.plot(n, np, marker=".", label="numpy inner product")
    plt.plot(n, tf, marker="+", label="tensorflow inner product")
    plt.legend()
    plt.show()
