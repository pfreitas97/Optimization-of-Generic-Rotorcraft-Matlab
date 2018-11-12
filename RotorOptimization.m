

A = [];
b = [];
Aeq = [];
beq = [];

%Decision variables C theta0 thetaMin

lb = [0.05; deg2rad(0); deg2rad(0)];
ub = [0.3; deg2rad(20); deg2rad(20)];

x0 = [0.1; deg2rad(15); deg2rad(15)];

options = optimoptions('fmincon','Display','iter');


[xstar fval exitFlag] = fmincon('continuousObjective',x0,A,b,Aeq,beq,lb,ub,'continuousConstraint',options)


