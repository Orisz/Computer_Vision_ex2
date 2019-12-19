# -*- coding: utf-8 -*-
"""CV_HW2_PART_A_test.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/12OIsHl7U9gYh8GXWlFL1AMNRNJemM6sB

# **Section A - Training a simple CNN**
"""

!pip install -q tensorflow==2.0.0-alpha0

from __future__ import absolute_import, division, print_function, unicode_literals

# TensorFlow and tf.keras
import tensorflow as tf
from tensorflow import keras

# Helper libraries
import math
import numpy as np
import matplotlib.pyplot as plt

print(tf.__version__)

# Section 1
mnist = keras.datasets.mnist

(train_images, train_labels), (test_images, test_labels) = mnist.load_data()

#print some info on the dataset
print('Train set size:{}'.format(train_labels.size))
print('Test set size:{}'.format(test_labels.size))

# Section 1
class_names = ['Zero', 'One', 'Two', 'Three', 'Four',
               'Five', 'Six', 'Seven', 'Eight', 'Nine']

# Section 1
#scale the images to the range of [0,1] and adjust the shape
train_images = train_images.reshape((60000, 28, 28, 1))
test_images = test_images.reshape((10000, 28, 28, 1))

train_images = train_images / 255.0

test_images = test_images / 255.0

# Section 1
#some ploting to verify the datas range and to get some sensation of it
plt.figure(figsize=(10,10))
for i in range(25):
    plt.subplot(5,5,i+1)
    plt.xticks([])
    plt.yticks([])
    plt.grid(False)
    plt.imshow(train_images[i,:,:,-1], cmap=plt.cm.binary)
    plt.colorbar()
    plt.xlabel(class_names[train_labels[i]])
plt.show()

# Section 2
#define the layers of the network as requested in the pdf.
def init_architecutre():
  model = tf.keras.Sequential([
      tf.keras.layers.Conv2D(8, (3,3), strides=(1, 1), padding='same',
                            input_shape=(28, 28, 1)),
      tf.keras.layers.BatchNormalization(),
      tf.keras.layers.Activation('relu'),
      tf.keras.layers.MaxPooling2D((2, 2), strides=2),
      tf.keras.layers.Conv2D(16, (3,3), strides=(1, 1), padding='same'),
      tf.keras.layers.BatchNormalization(),
      tf.keras.layers.Activation('relu'),
      tf.keras.layers.MaxPooling2D((2, 2), strides=2),
      tf.keras.layers.Conv2D(32, (3,3), strides=(1, 1), padding='same'),
      tf.keras.layers.BatchNormalization(),
      tf.keras.layers.Activation('relu'),
      tf.keras.layers.Flatten(),
      tf.keras.layers.Dense(10,  activation='softmax')
  ])
  return model

# Section 3
#set the keras 'SGD' optimizer to use the momentum method mentioned in the pdf
model = init_architecutre()
sgd = keras.optimizers.SGD(lr=0.01, decay=1e-6, momentum=0.9, nesterov=True)
model.compile(optimizer=sgd,
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])

# Section 4
BATCH_SIZE = 128
EPOCHS = 8
validation_split_ratio = 1.0 / 12.0
#train the CNN

history = model.fit(train_images, train_labels, batch_size=BATCH_SIZE, epochs=EPOCHS,
                    validation_split=validation_split_ratio)

def plot_loss_accuracy(history, lr):
  plt.figure(figsize=(12,6))
  plt.subplot(1,2,1)
  plt.plot(history.history['loss'])
  plt.plot(history.history['val_loss'])
  plt.title('model loss lr = {}'.format(lr))
  plt.ylabel('loss')
  plt.xlabel('epoch')
  plt.legend(['train', 'validation'], loc='upper left')
  plt.grid(True)

  #plot the accuracy of the train set and the validation set as a function of the 
  # iteration
  plt.subplot(1,2,2)
  plt.plot(history.history['accuracy'])
  plt.plot(history.history['val_accuracy'])
  plt.title('model accuracy lr = {}'.format(lr))
  plt.ylabel('accuracy')
  plt.xlabel('epoch')
  plt.legend(['train', 'validation'], loc='upper left')
  plt.grid(True)
  
  plt.show()

# Section 5
#plot the loss of the train set and the validation set as a function of the 
# iteration
lr = 0.01
plot_loss_accuracy(history, lr)

# Section 6 - evaluate the net on the test set.
test_loss, test_acc = model.evaluate(test_images, test_labels)
print('Test loss:', test_loss)
print('Test accuracy:', test_acc)

# Section 7 repeat section 4-5 with LR of 0.1 - big
model2 = init_architecutre()
sgd_big_lr = keras.optimizers.SGD(lr=0.1, decay=1e-6, momentum=0.9, nesterov=True)
model2.compile(optimizer=sgd_big_lr,
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])

# Set some constants
BATCH_SIZE = 128
EPOCHS = 8
validation_split_ratio = 1.0 / 12.0

#train the CNN

history2 = model2.fit(train_images, train_labels, batch_size=BATCH_SIZE, epochs=EPOCHS,
                    validation_split=validation_split_ratio)

# Section 7 repeat section 4-5 with LR of 0.1 - big

lr = 0.1
plot_loss_accuracy(history2, lr)

# Section 7 repeat section 4-5 with LR of 0.001 - small
model3 = init_architecutre()
sgd_small_lr = keras.optimizers.SGD(lr=0.001, decay=1e-6, momentum=0.9, nesterov=True)
model3.compile(optimizer=sgd_small_lr,
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])

# Set some constants
BATCH_SIZE = 128
EPOCHS = 8
validation_split_ratio = 1.0 / 12.0

#train the CNN

history3 = model3.fit(train_images, train_labels, batch_size=BATCH_SIZE, epochs=EPOCHS,
                    validation_split=validation_split_ratio)

# Section 7 repeat section 4-5 with LR of 0.001 - small
lr = 0.001
plot_loss_accuracy(history3, lr)

# convert the labels to 'one hot' vectors using the to_categorical function
num_classes = 10
categorical_train_labels = tf.keras.utils.to_categorical(train_labels, num_classes)
print('train lables size = {}'.format(train_labels.shape))
print('categorical train lables size = {}'.format(categorical_train_labels.shape))
#categorical_test_labels = tf.keras.utils.to_categorical(test_labels, num_classes)

# Section 7 repeat section 3-5 with LR of 0.01 - regular and lose - L2 norm


model4 = init_architecutre()
sgd = keras.optimizers.SGD(lr=0.01, decay=1e-6, momentum=0.9, nesterov=True)
model4.compile(optimizer=sgd,
              loss='mean_squared_error',
              metrics=['accuracy'])

# Set some constants
BATCH_SIZE = 128
EPOCHS = 8
validation_split_ratio = 1.0 / 12.0

#train the CNN

history4 = model4.fit(train_images, categorical_train_labels, batch_size=BATCH_SIZE, epochs=EPOCHS,
                    validation_split=validation_split_ratio)

# Section 7 repeat section 3-5 with LR of 0.01 - regular and lose - L2 norm
lr = 0.01
plot_loss_accuracy(history4, lr)

# Section 8 - repeat sections 2-5 with the following architecture
# 8.2
model5 = tf.keras.Sequential([
    tf.keras.layers.Conv2D(2, (3,3), strides=(1, 1), padding='same',
                          input_shape=(28, 28, 1)),
    tf.keras.layers.BatchNormalization(),
    tf.keras.layers.Activation('relu'),
    tf.keras.layers.MaxPooling2D((2, 2), strides=2),
    tf.keras.layers.Conv2D(4, (3,3), strides=(1, 1), padding='same'),
    tf.keras.layers.BatchNormalization(),
    tf.keras.layers.Activation('relu'),
    tf.keras.layers.MaxPooling2D((2, 2), strides=2),
    tf.keras.layers.Conv2D(8, (3,3), strides=(1, 1), padding='same'),
    tf.keras.layers.BatchNormalization(),
    tf.keras.layers.Activation('relu'),
    tf.keras.layers.Flatten(),
    tf.keras.layers.Dense(10,  activation='softmax')
])

# 8.3
sgd = keras.optimizers.SGD(lr=0.01, decay=1e-6, momentum=0.9, nesterov=True)
model5.compile(optimizer=sgd,
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])
# 8.4
BATCH_SIZE = 128
EPOCHS = 8
validation_split_ratio = 1.0 / 12.0
#train the CNN

history5 = model5.fit(train_images, train_labels, batch_size=BATCH_SIZE, epochs=EPOCHS,
                    validation_split=validation_split_ratio)

# 8.5
lr = 0.01
plot_loss_accuracy(history5, lr)

test_loss5, test_acc5 = model5.evaluate(test_images, test_labels)
print('Test loss:', test_loss5)
print('Test accuracy:', test_acc5)