clear
clc
close all;

%% Load data and combine
load('goodData')
testSamples=1000;

catTestInd = randi(length(catData),testSamples,1);
catTrainInd = setdiff(1:length(catData),catTestInd);

catTestData = catData(catTestInd,:);
catTrainData = catData(catTrainInd,:);
catTestLabels = catLabels(catTestInd);
catTrainLabels = catLabels(catTrainInd);


dogTestInd = randi(length(dogData),testSamples,1);
dogTrainInd = setdiff(1:length(dogData),dogTestInd);

dogTestData = dogData(dogTestInd,:);
dogTrainData = dogData(dogTrainInd,:);
dogTestLabels = dogLabels(dogTestInd);
dogTrainLabels = dogLabels(dogTrainInd);

data = [catTrainData;dogTrainData];
testData = [catTestData;dogTestData];
labels = [catTrainLabels;dogTrainLabels];
testLabels = [catTestLabels;dogTestLabels];

%% Fit SVM
svmModel = fitcsvm(data,labels,'KernelFunction','RBF');

%% Test predictor
testingAcc = mean(svmModel.predict(testData)==testLabels);

%% Save model and testing accuracy
save('svmModel','testingAcc','svmModel')
