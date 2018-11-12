
function [g geq] = continuousConstraint(x)


C = x(1);
theta0 = x(2);
thetaMin = x(3);

b = 4;
R = 0.4;
omega = 600;
n = 6;

datum = load('NACA0012_cl_cd_alpha.mat');

cl_cd_alpha = datum.cl_cd_alpha;

[thrust,fanThrust, powerReq, CT, CQ, CT_sigma,disk_loading, maxM] ...
    = rotorDataFromGeometry(b,R,C,omega,theta0,thetaMin,cl_cd_alpha);

w = (500 * 4.448)/(n); %conversion from 500 lb to N divided by n rotors

g = 1 - (thrust/w);

if nargout > 1
    geq = 0;
end

end