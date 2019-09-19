%% Script to delete the corrupt files
clear
clc
close all;

numData = 12499;
newSize = 50;

%% Parse Imagery
for i = 0:numData
    readCat = sprintf('../PetImages/Cat/%d.jpg',i);
    writeCat = sprintf('../ProcessedImages/Cat/%d.jpg',i);
    readDog = sprintf('../PetImages/Dog/%d.jpg',i);
    writeDog = sprintf('../ProcessedImages/Dog/%d.jpg',i);
    try
        A = imread(readCat);
        dim = size(A);
        assert(dim(3) == 3)
        A = imresize(A,[newSize newSize]);
        imwrite(A,writeCat)
    catch
        disp(readCat)
    end
    
    try
        A = imread(readDog);
        dim = size(A);
        assert(dim(3) == 3)
        A = imresize(A,[newSize newSize]);
        imwrite(A,writeDog)
    catch
        disp(readDog)
    end
end


