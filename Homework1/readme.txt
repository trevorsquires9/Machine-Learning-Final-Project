Math 9880 - Homework 1 Approach

This folder solves the cats and dogs classification via transfer learning from the alexnet award winning neural network. 
Alexnet is a pretrained neural network that can classify images into over 1000 different categories.  The idea of transfer learning
is to use the pretrained layers as some sort of feature extraction and then train a new neural network over the features extracted
from the pretrained network.  

In the case of alexnet, all but the last 3 layers transform a 30x30 image into a 4096x1 vector of features.
This folder trains its own network over the 4096x1 features and achieves a 97% validation accuracy.  