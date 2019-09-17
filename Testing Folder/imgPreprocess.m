%% Script to delete the corrupt files
clear
clc
close all;

numData = 12499;

%% Parse Imagery
for i = 1:numData
    fileNameCat = sprintf('PetImages/Cat/%d.jpg',i);
    fileNameDog = sprintf('PetImages/Dog/%d.jpg',i);
    try
        A = imread(fileNameCat);
        dim = size(A);
        assert(dim(3) == 3)
    catch
        delete(fileNameCat);
        fprintf('Cat %d\n',i);
    end
    
    try
        A = imread(fileNameDog);
        dim = size(A);
        assert(dim(3) == 3)
    catch
        delete(fileNameDog);
        fprintf('Dog %d\n',i);
    end
end


