clear
clc
close all;

%% Load data and combine
load('goodData')
testSamples=1000;
data = [catData;dogData];
testData = [data(1:testSamples,:);data(end-testSamples+1:end,:)];
data(1:testSamples,:) = [];
data(end-testSamples+1:end,:) = [];

labels = [catLabels;dogLabels];
testLabels = [labels(1:testSamples,:);labels(end-testSamples+1:end,:)];
labels(1:testSamples,:) = [];
labels(end-testSamples+1:end,:) = [];
%% Fit SVM
Mdl = fitcsvm(data,labels,'KernelFunction','RBF');

%% Test predictor
testingAcc = mean(Mdl.predict(testData)==testLabels);