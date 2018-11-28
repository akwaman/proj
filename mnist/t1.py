#!/usr/bin/env python

# MNIST tutorial from
# https://www.oreilly.com/learning/not-another-mnist-tutorial-with-tensorflow

from tensorflow.examples.tutorials.mnist import input_data
import matplotlib.pyplot as plt
import numpy as np
import random as ran
import tensorflow as tf
import sys

# command line arg to disable plottin
doplot = True
if len(sys.argv) > 1:
  if sys.argv[1] == '-np':
    doplot = False


mnist = input_data.read_data_sets('MNIST_data', one_hot=True)

'''
define a couple of functions that will assign the amount
of training and test data we'll load from the data set.
'''

def TRAIN_SIZE(num):
    print ('Total Training Images in Dataset = ' +
           str(mnist.train.images.shape))
    print ('--------------------------------------------------')
    x_train = mnist.train.images[:num,:]
    print ('x_train Examples Loaded = ' + str(x_train.shape))
    y_train = mnist.train.labels[:num,:]
    print ('y_train Examples Loaded = ' + str(y_train.shape))
    print('')
    return x_train, y_train

def TEST_SIZE(num):
    print ('Total Test Examples in Dataset = ' +
           str(mnist.test.images.shape))
    print ('--------------------------------------------------')
    x_test = mnist.test.images[:num,:]
    print ('x_test Examples Loaded = ' + str(x_test.shape))
    y_test = mnist.test.labels[:num,:]
    print ('y_test Examples Loaded = ' + str(y_test.shape))
    return x_test, y_test

# simple functions for resizing and displaying the data

def display_digit(num):
    print(y_train[num])
    label = y_train[num].argmax(axis=0)
    image = x_train[num].reshape([28,28])
    plt.title('Example: %d  Label: %d' % (num, label))
    plt.imshow(image, cmap=plt.get_cmap('gray_r'))
    if doplot:
      plt.show()

def display_mult_flat(start, stop):
    images = x_train[start].reshape([1,784])
    for i in range(start+1,stop):
        images = np.concatenate((images, x_train[i].reshape([1,784])))
    plt.imshow(images, cmap=plt.get_cmap('gray_r'))
    if doplot:
      plt.show()

'''
define variables with how many training and test examples
we would like to load. For now, we will load all the data
but we will change this value later on to save resources:
'''

x_train, y_train = TRAIN_SIZE(55000)

'''
Total Training Images in Dataset = (55000, 784)
x_train Examples Loaded = (55000, 784)
y_train Examples Loaded = (55000, 10)

In our data set, there are 55,000 examples of handwritten
digits from zero to nine. Each example is a 28x28 pixel
image flattened in an array with 784 values representing
each pixel's intensity. The examples need to be flattened
for TensorFlow to make sense of the digits linearly. This
shows that in x_train we have loaded 55,000 examples each
with 784 pixels. Our x_train variable is a 55,000 row and
784 column matrix.

The y_train data is the associated labels for all the x_train
examples. Rather than storing the label as an integer, it
is stored as a 1x10 binary array with the one representing
the digit. This is also known as one-hot encoding.

Now pull up a random image using one of our custom
functions that takes the flattened data, reshapes it,
displays the example, and prints the associated label
'''

display_digit(ran.randint(0, x_train.shape[0]))

'''
Here is what multiple training examples look like to
the classifier in their flattened form. Of course,
instead of pixels, our classifier sees values from
zero to one representing pixel intensity:
'''

display_mult_flat(0,500)

#---------------------------------------------------------------------
# TensorFlow learning algorithm
#---------------------------------------------------------------------
sess = tf.Session()

# input stream is pushed into a placeholder
x = tf.placeholder(tf.float32, shape=[None, 784])

'''
define y_ which will be used to feed y_train
This will be used later so we can compare the
ground truths to our predictions.
We can also think of our labels as classes
'''

y_ = tf.placeholder(tf.float32, shape=[None, 10])

# define trainable weight and bias parameters - init to 0
W = tf.Variable(tf.zeros([784,10]))
b = tf.Variable(tf.zeros([10]))

'''
define y which is our classifier function.
This particular classifier is also known as multinomial
logistic regression. We make our prediction by
multiplying each flattened digit by our weight and
then adding our bias:

Y = W*X + B   (linear regression - apply output Y to softmax)
'''

y = tf.nn.softmax(tf.matmul(x,W) + b)

'''
x_train, y_train = TRAIN_SIZE(3)
sess.run(tf.global_variables_initializer())
# sess.run(tf.initialize_all_variables()) # for TensorFlow v0.12
print(sess.run(y, feed_dict={x: x_train}))
'''

'''
create the cross_entropy function, also known as a loss
or cost function. It measures how good (or bad) of a
job we are doing at classifying. The higher the cost,
the higher the level of inaccuracy. It calculates
accuracy by comparing the true values from y_train
to the results of our prediction y for each example.
The goal is to minimize your loss:
'''

cross_entropy = tf.reduce_mean(-tf.reduce_sum(y_ * tf.log(y),
                                              reduction_indices=[1]))

'''
This function is taking the log of all our predictions
y (whose values range from 0 to 1) and element wise
multiplying by the example's true value y_. If the log
function for each value is close to zero, it will make
the value a large negative number (i.e., -np.log(0.01) = 4.6)
and if it is close to 1, it will make the value a small
negative number (i.e., -np.log(0.99) = 0.1).

We are essentially penalizing the classifier with a
very large number if the prediction is confidently
incorrect and a very small number if the prediction
is confidendently correct.
'''
x_train, y_train = TRAIN_SIZE(5500)
x_test, y_test = TEST_SIZE(10000)
LEARNING_RATE = 0.1
TRAIN_STEPS = 2500

init = tf.global_variables_initializer()
sess.run(init)

'''
Now, we need to train our classifier using gradient descent.
We first define our training method and some variables for
measuring our accuracy. The variable training will perform
the gradient descent optimizer with a chosen LEARNING_RATE
in order to try to minimize our loss function cross_entropy:
'''

training = tf.train.GradientDescentOptimizer(LEARNING_RATE).minimize(cross_entropy)
correct_prediction = tf.equal(tf.argmax(y,1), tf.argmax(y_,1))
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))

'''
Now, we define a loop that repeats TRAIN_STEPS times;
for each loop, it runs training, feeding in values from
x_train and y_train using feed_dict. In order to calculate
accuracy, it will run accuracy to classify the unseen data
in x_test by comparing its y and y_test. It is vitally
important that our test data was unseen and not used for
training data.
'''

for i in range(TRAIN_STEPS+1):
    sess.run(training, feed_dict={x: x_train, y_: y_train})
    if i%100 == 0:
        print('Training Step:' + str(i) + '  Accuracy =  ' + str(sess.run(accuracy, feed_dict={x: x_test, y_: y_test})) + '  Loss = ' + str(sess.run(cross_entropy, {x: x_train, y_: y_train})))

for i in range(10):
    plt.subplot(2, 5, i+1)
    weight = sess.run(W)[:,i]
    plt.title(i)
    plt.imshow(weight.reshape([28,28]), cmap=plt.get_cmap('seismic'))
    frame1 = plt.gca()
    frame1.axes.get_xaxis().set_visible(False)
    frame1.axes.get_yaxis().set_visible(False)

if doplot:
  plt.show()

'''
This is a visualization of our weights from 0-9. This
is the most important aspect of our classifier. The bulk
of the work of machine learning is figuring out what the
optimal weights are; once they are calculated, you have
the "cheat sheet" and can easily find answers. (This is
part of why neural networks can be readily ported to mobile
devices; the model, once trained, doesn't take up that much
room to store or computing power to calculate.) Our classifier
makes its prediction by comparing how similar or different
the digit is to the red and blue. I like to think the
darker the red, the better of a hit; white as neutral;
and blue as misses.

So, now that we have our cheat sheet, let's load one
example and apply our classifier to that one example:
'''

x_train, y_train = TRAIN_SIZE(1)
display_digit(0)

# Let's look at our predictor y:

answer = sess.run(y, feed_dict={x: x_train})
print(answer)

'''
This gives us a (1x10) matrix with each column
containing one probability

But this is not very useful for us. So, we use the
argmax function to return the position of the highest
value and that gives us our prediction.
'''

answer.argmax()

'''
So, let's now take our knowledge to create a function
to make predictions on a random digit in this data set:
'''

def display_compare(num):
    # THIS WILL LOAD ONE TRAINING EXAMPLE
    x_train = mnist.train.images[num,:].reshape(1,784)
    y_train = mnist.train.labels[num,:]
    # THIS GETS OUR LABEL AS A INTEGER
    label = y_train.argmax()
    # THIS GETS OUR PREDICTION AS A INTEGER
    prediction = sess.run(y, feed_dict={x: x_train}).argmax()
    plt.title('Prediction: %d Label: %d' % (prediction, label))
    plt.imshow(x_train.reshape([28,28]), cmap=plt.get_cmap('gray_r'))
    if doplot:
      plt.show()

display_compare(ran.randint(0, 55000))

'''
one can see the limitations of a linear classifier;
at a certain point, feeding it more data does not help
increase your accuracy drastically. What do you think
would happen if we tried to classify a "1" that was
drawn on the very left side of the square? It would
have a very hard time classifying it because in all of
its training examples, the 1 was very close to the center.
'''
