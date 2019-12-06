clear
clc
close all;

cd LinuxCVX
cd cvx
cvx_setup
cd ..
cd ..


%% Visualizing nonconvexity
dim = 2;
A = diag([-5 5]);
[q,~] = qr(randn(dim));
A = q'*A*q;
b = zeros(dim,1);

f = @(x) 0.5*x'*A*x+b'*x;
dist = linspace(-1,1,100);
mesh = zeros(length(dist));
for i = 1:length(dist)
    for j= 1:length(dist)
        x = [dist(i);dist(j)];
        mesh(i,j) = f(x);
    end
end
surf(dist,dist,mesh)
save('visualization.mat', 'mesh') 

%% Single Trial Run
clear
clc

% Algorithm Parameters
it = 100;
dim = 35;
convexParam.maxIt = it;
beckParam.maxIt = it;
sgdParam.epochs = it;
sgdParam.miniBatchProp = 1/4;
sgdParam.maxIt = ceil(sgdParam.epochs/sgdParam.miniBatchProp);

A = rand(dim);
A = A+A';
b = rand(dim,1);

[convex, beck, sgd,sdp] = solvingTRS(A,b,dim,convexParam,beckParam,sgdParam,[]);

% Generate output statistics/plots
figure();
subplot(2,2,1)
plot(1:convexParam.maxIt,convex.objVal)
title('TRS Using Convex Reformulation')

subplot(2,2,2)
plot(1:beckParam.maxIt, beck.objValX)
hold on
plot(1:beckParam.maxIt, beck.objValY)
title('TRS Using Double-Start FOCM')
legend('Starting at 0','Starting at random point','location','best')

subplot(2,2,3)
plot(1:sgdParam.maxIt,sgd.objVal)
title('TRS Using Stochastic Projected Gradient Descent')
save('iterationComparison','convex','beck','sgd','sdp')

%% Multiple Trial Run
clear
clc

% Algorithm Parameters
it = 200;
dim = 35;
convexParam.maxIt = it;
beckParam.maxIt = it;
sgdParam.epochs = it;
sgdParam.miniBatchProp = 1/4;
sgdParam.maxIt = ceil(sgdParam.epochs/sgdParam.miniBatchProp);
trials = 50000;

% Algorithm Instances
optVals = zeros(trials,3);
for j = 1:trials
    A = rand(dim);
    A = A+A';
    b = zeros(dim,1);
    [convex, beck, sgd] = solvingTRS(A,b,dim,convexParam,beckParam,sgdParam,[]);
    optVals(j,:) = [convex.optVal,beck.optVal,sgd.optVal];
end
relError = abs(optVals(:,1)-optVals(:,3))./optVals(:,1);
worstErr = max(relError);
save('ErrorAnalysis','relError','worstErr')

%% Large Dimension Run
clear
clc

% Algorithm Parameters
it = 70;
dim = [10,25,50,100,250,500,750];
timings = zeros(length(dim),4);
convexParam.maxIt = it;
beckParam.maxIt = it;
sgdParam.epochs = it;
sgdParam.miniBatchProp = 1/4;
sgdParam.maxIt = ceil(sgdParam.epochs/sgdParam.miniBatchProp);
sdpParam.run = 1;
 
for i = 1:length(dim)
    A = rand(dim(i));
    A = A+A';
    b = zeros(dim(i),1);
    
    [convex, beck, sgd, sdp] = solvingTRS(A,b,dim(i),convexParam,beckParam,sgdParam,sdpParam);
    timings(i,:) = [convex.time, beck.time,sgd.time,sdp.time];
end
save('Timings','timings')
