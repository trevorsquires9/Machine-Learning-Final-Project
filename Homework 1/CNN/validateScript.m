clear
clc
close all;

imds = imageDatastore('../ProcessedImages', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.7,'randomized');

load 'cnnResults'

[YPred,scores] = classify(netTransfer,augimdsValidation);
YValidation = imdsValidation.Labels;
accuracy = mean(YPred == YValidation);