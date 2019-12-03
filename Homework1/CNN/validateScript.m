clear
clc
close all;

load 'cnnResults'

accuracy = mean(YPred == YValidation);
confusionMat = zeros(2);

for i = 1:length(YValidation)
    if YValidation(i) == 'Cat'
        k = 1;
    else
        k = 2;
    end
    if YPred(i) == 'Cat'
        j = 1;
    else
        j = 2;
    end
    confusionMat(j,k) = confusionMat(j,k)+1;
end