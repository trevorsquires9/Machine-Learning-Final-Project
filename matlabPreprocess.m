%% Script for computing "4-number summary" for preprocessed images
clear
clc
close all;

sets = 25;
processedData = [];
for j = 1:sets
    tmpSet = load(sprintf('ProcessedPetImages/catSet%d',j));
    k = size(tmpSet);
    numberSummary = zeros(k,4,3);
    for i = 1:k
        tmpImage = tmpSet{i};
        [m,n,~] = size(tmpImage);
        tmpImage = reshape(tmpImage,[m*n,3]);
        numberSummary(i,1,:) = mean(tmpImage);
        numberSummary(i,2,:) = median(tmpImage);
        numberSummary(i,3,:) = std(tmpImage);
        numberSummary(i,4,:) = skewness(tmpImage);
    end
    processedData = [processedData numberSummary];
    
end