format long


A = [];
b = [];
Aeq = [];
beq = [];

nVars = 7;

%Decision vars
% nrot L b, C, theta0, thetaMin, Airfoil
%int : nrot b airfoil

lb = [4; 1;  2; 0.05; deg2rad(0); deg2rad(0); 0];
ub = [8; 1.5; 6 ; 0.3; deg2rad(14); deg2rad(14); 1];

x0 = [6; 1; 0.15; deg2rad(10); deg2rad(10); 0];

options = optimoptions('ga','Display','iter')

[x, fval, exitflag] = ga(@continuousObjective,nVars,A,b,Aeq,beq,lb,ub,@continuousConstraint,[1 3 7],options)


[thrust, powerReq, CT, CQ, weightAircraft, ThrustEnvelope, SizeConstraint]  = performanceResults(x)


