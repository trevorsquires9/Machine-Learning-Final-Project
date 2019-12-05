clear
clc
close all;

%% Algorithm Parameters
it = 50;

convexParam.maxIt = it;
beckParam.maxIt = it;
sgdParam.epochs = it;
sgdParam.miniBatchProp = 1/4;
sgdParam.maxIt = ceil(sgdParam.epochs/sgdParam.miniBatchProp);

dim = 35;

%% Run the algorithms
[convex, beck, sgd] = solvingTRS(dim,convexParam,beckParam,sgdParam);

%% Generate output statistics/plots
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