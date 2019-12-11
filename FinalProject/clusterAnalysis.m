clear
clc
close all;

%% Load Data
load timings
load errorAnalysis


%% Error Analysis
tmp = min([optVals(:,2) optVals(:,3)],[],2);
relErrorBeck = abs(optVals(:,1)-tmp)./abs(optVals(:,1));
relErrorSGD = abs(optVals(:,1)-optVals(:,4))./abs(optVals(:,1));

subplot(1,2,1)
histogram(relErrorBeck);
title('Relative Errors via Double-Start')
xlabel('Relative Error')
ylabel('Frequency')

subplot(1,2,2)
histogram(relErrorSGD);
title('Relative Errors via SGD')
xlabel('Relative Error')
ylabel('Frequency')

%% Timing
figure();
hold on
plot(dim,timings(:,1),'g')
plot(dim,timings(:,2),'b')
plot(dim,timings(:,3),'r')
plot(dim,timings(:,4),'k')
legend('Convex','Double-Start','SGD','SDP')
title('Runtime Analysis')
xlabel('Dimension')
ylabel('Seconds')

figure();
hold on
plot(dim,timings(:,1),'g')
plot(dim,timings(:,2),'b')
plot(dim,timings(:,3),'r')
legend('Convex','Double-Start','SGD')
title('Runtime Analysis without SDP')
xlabel('Dimension')
ylabel('Seconds')