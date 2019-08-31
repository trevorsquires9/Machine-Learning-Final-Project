%% Script to read images into cell arrays
clear
clc
close all;

numData = 12499;
catData = zeros(numData,4,3);
dogData = zeros(numData,4,3);

%% Load Imagery and save
%% Cat
bad = [];
for i = 1:numData
    fileName = sprintf('PetImages/Cat/%d.jpg',i);
    try
        tmp = double(imread(fileName));
        [m,n,~] = size(tmp);
        tmp = reshape(tmp,[m*n,3]);
        
        catData(i,1,:) = mean(tmp);
        catData(i,2,:) = median(tmp);
        catData(i,3,:) = std(tmp);
        catData(i,4,:) = skewness(tmp);
    catch
        bad = [bad i];
    end
end
catData(bad,:,:) = [];
catData = reshape(catData,[length(catData) 12]);

%% Dog
bad = [];
for i = 1:numData
    fileName = sprintf('PetImages/Dog/%d.jpg',i);
    try
        tmp = double(imread(fileName));
        [m,n,~] = size(tmp);
        tmp = reshape(tmp,[m*n,3]);
        
        dogData(i,1,:) = mean(tmp);
        dogData(i,2,:) = median(tmp);
        dogData(i,3,:) = std(tmp);
        dogData(i,4,:) = skewness(tmp);
    catch
        bad = [bad i];
    end
end
dogData(bad,:,:) = [];
dogData = reshape(dogData,[length(dogData) 12]);

%% Save data
catLabels = zeros(length(catData),1);
dogLabels = ones(length(dogData),1);

save('goodData','catData','catLabels','dogData','dogLabels')
