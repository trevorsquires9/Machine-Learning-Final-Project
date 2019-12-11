clear
clc
close all;

cd LinuxCVX
cd cvx
cvx_setup
cd ..
cd ..

%% Multiple Trial Run
clear
clc

% Algorithm Parameters
it = 200;
dim = 35;
convexParam.maxIt = it;
beckParam.maxIt = it;
sgdParam.epochs = it;
sgdParam.miniBatchProp = 0.1;
sgdParam.maxIt = ceil(sgdParam.epochs/sgdParam.miniBatchProp);
sdpParam.run = 1;
trials = 50000;
failedRelaxation = 0;

% Algorithm Instances
optVals = zeros(trials,4);
for j = 1:trials
    A = rand(dim);
    A = A+A';
    b = rand(dim,1);
    [convex, beck, sgd] = solvingTRS(A,b,dim,convexParam,beckParam,sgdParam,sdpParam);
    optVals(j,:) = [convex.optVal,beck.objValX(end),beck.objValY(end),sgd.optVal];
    if abs(1-norm(convex.solu,2)) > eps
        failedRelaxation = failedRelaxation+1;
    end
end

failedProp = failedRelaxation/trials;

save('errorAnalysis','optVals','failedProp')

%% Large Dimension Run
clear
clc

% Algorithm Parameters
it = 70;
dim = [10,25,50,100,250,500,750,1000];
timings = zeros(length(dim),4);
convexParam.maxIt = it;
beckParam.maxIt = it;
sgdParam.epochs = it;
sgdParam.miniBatchProp = 0.1;
sgdParam.maxIt = ceil(sgdParam.epochs/sgdParam.miniBatchProp);
sdpParam.run = 1;
 
for i = 1:length(dim)
    A = rand(dim(i));
    A = A+A';
    b = zeros(dim(i),1);
    
    [convex, beck, sgd, sdp] = solvingTRS(A,b,dim(i),convexParam,beckParam,sgdParam,sdpParam);
    timings(i,:) = [convex.time, beck.time,sgd.time,sdp.time];
end
save('timings','timings','dim')
