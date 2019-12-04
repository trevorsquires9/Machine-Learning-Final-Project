%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solves Trust Region subproblem various through various optimization
% techniques.
%
% Author
%   Trevor Squires
%
% Details
%   Solves TRS via 4 different approaches:
%   - SDP reformulation
%   - Convex reformulation/relaxation
%   - Stochastic gradient descent
%   - Double-Start FOCM (Beck)
%
% Notes
%   - Output is not correct
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc
close all;

%% Problem setting
rng(100)
dim = 35;

eigVal = randi(10,dim,1);
negEigValInd = randi(dim,floor(dim/2),1);
eigVal(negEigValInd) = -eigVal(negEigValInd);
eigMin = min(eigVal);
[eigVec,~] = qr(randn(dim));
A = eigVec'*diag(eigVal)*eigVec;

b = randn(dim,1);

f = @(x) 0.5*x'*A*x + b'*x;
gradf = @(x) A*x+b;
L = norm(A,2);


%% TRS via convex reformulation
g = @(x) f(x) - 0.5*eigMin*norm(x,2)^2;
gradg = @(x) gradf(x) + eigMin*x;

maxIt = 100;
x = zeros(dim,maxIt+1);
objVal = zeros(maxIt+1,1);

x(:,1) = randn(dim,1);
x(:,1) = x(:,1)/norm(x(:,1),2);

for i = 2:maxIt+1
    x(:,i) = x(:,i-1) - 1/(L+eigMin)*gradg(x(:,i-1));
    tmp = norm(x(:,i));
    if tmp > 1
        x(:,i) = x(:,i)/tmp;
    end
    objVal(i) = g(x(:,i));
end
solu = x(:,end);

% Map solution to equivalent one with norm  = 1
%can't figure out how to do this

% Minimizer is the same as the original problem, but objective value is not
optVal = f(solu);

% Store useful variables in a structure
conRef.obj = g;
conRef.gradObj = gradg;
conRef.objVal = objVal;
conRef.x = x;
conRef.solu = solu;
conRef.optVal = optVal;

%% TRS via Beck paper
maxIt = 100;
x = zeros(dim,maxIt+1);
y = zeros(dim,maxIt+1);
objValX = zeros(maxIt+1,1);
objValY = zeros(maxIt+1,1);


% First pass
y(:,1) = randn(dim,1);
y(:,1) = y(:,1)/norm(y(:,1),2);
for i = 2:maxIt+1
    y(:,i) = y(:,i-1) - 1/L*gradf(y(:,i-1));
    tmp = norm(y(:,i));
    if tmp > 1
        y(:,i) = y(:,i)/tmp;
    end
    objValY(i) = f(y(:,i));
end
soluY = y(:,end);

% Second pass
x(:,1) = zeros(dim,1);
for i = 2:maxIt+1
    x(:,i) = x(:,i-1) - 1/L*gradf(x(:,i-1));
    tmp = norm(x(:,i));
    if tmp > 1
        x(:,i) = x(:,i)/tmp;
    end
    objValX(i) = f(x(:,i));
end
soluX = x(:,end);

% Store useful objects in structure
bec.obj = f;
beck.gradObj = gradf;
beck.objValX = objValX;
beck.objValY = objValY;

% Pick best solution 
if f(soluX)<f(soluY)
    beck.x = x;
    beck.solu = soluX;
    beck.optVal = f(soluX);
else
    beck.x = y;
    beck.solu = soluY;
    beck.optVal = f(soluY);
end

%% TRS via STochastic Gradient Descent
maxIt = 5000;
miniBatchSize = floor(dim/4);

x = zeros(dim,maxIt+1);
objVal = zeros(maxIt+1,1);

x(:,1) = randn(dim,1);
x(:,1) = x(:,1)/norm(x(:,1),2);

for i = 2:maxIt+1
    %Compute partial gradient
    miniBatchInd = randi(dim,miniBatchSize,1);
    partialGrad = b;
    for j = 1:miniBatchSize
        partialGrad = partialGrad + A(:,miniBatchInd(j))*x(miniBatchInd(j),i-1);
    end
    %Update using partial gradient
    x(:,i) = x(:,i-1) - 1/(L+eigMin)*partialGrad;
    tmp = norm(x(:,i));
    if tmp > 1
        x(:,i) = x(:,i)/tmp;
    end
    objVal(i) = f(x(:,i));
end
solu = x(:,end);

% Store useful objects in structures
sgd.obj = f;
sgd.gradObj = gradf;
sgd.objVal = objVal;
sgd.x = x;
sgd.solu = solu;
sgd.optVal = optVal;