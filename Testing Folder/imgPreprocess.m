%% Script to read images into cell arrays
clear
clc
close all;

numData = 12499;
imSize = [100 100];
features = prod(imSize)*3;
catData = zeros(numData,features);
dogData = zeros(numData,features);


%% Load Imagery
%% Cat
bad = [];
for i = 1:numData
    fileName = sprintf('../Homework 1/PetImages/Cat/%d.jpg',i);
    try
        tmp = double(imread(fileName));
        tmp = imresize(tmp,imSize);
        tmp = tmp(:);
        catData(i,:) = tmp;
        
    catch
        bad = [bad i]; % god someone please fix this
    end
end
catData(bad,:,:) = [];


%% Dog
bad = [];
for i = 1:numData
    fileName = sprintf('PetImages/Dog/%d.jpg',i);
    try
        tmp = double(imread(fileName));
        tmp = imresize(tmp,imSize);
        tmp = tmp(:);
        dogData(i,:) = tmp;
    catch
        bad = [bad i];
    end
end
dogData(bad,:,:) = [];

