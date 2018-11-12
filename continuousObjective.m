
function CQ = continuousObjective(x)

C = x(1);
theta0 = x(2);
thetaMin = x(3);

b = 4;
R = 0.5;
omega = 600;

datum = load('NACA0012_cl_cd_alpha.mat');

cl_cd_alpha = datum.cl_cd_alpha;

[thrust,fanThrust, powerReq, CT, CQ, CT_sigma,disk_loading, maxM] ...
    = rotorDataFromGeometry(b,R,C,omega,theta0,thetaMin,cl_cd_alpha);



end

