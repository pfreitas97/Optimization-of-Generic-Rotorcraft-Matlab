function f = continuousObjective(x)


%Decision variables
% nrot L b, C, theta0, thetaMin, Airfoil



%Fixed variables
R = 0.5;
omega = 600; %RPM = 4774
g = 9.8;



%Decision variables
nrot = x(1);
L = x(2);
b = x(3);
C = x(4);
theta0 = x(5);
thetaMin = x(6);
airfoil = x(7);


if airfoil == 0
    datum = load('NACA0012_cl_cd_alpha.mat'); %Airfoil encoding
    cl_cd_alpha = datum.cl_cd_alpha;
    
end

if airfoil == 1
    datum = load('NACA0015_cl_cd_alpha.mat');
    cl_cd_alpha = datum.NACA0015XFLR;
    
end


[thrust,fanThrust, powerReq, CT, CQ, CT_sigma,disk_loading, maxM] ...
    = rotorDataFromGeometry(b,R,C,omega,theta0,thetaMin,cl_cd_alpha);



wLBS = 300 + 25*nrot + 100*L;

lbs2KG = 0.453592;

w = (wLBS*lbs2KG); %conversion from 500 lb to N divided by n rotors

g1 = 1 - ((nrot*thrust)/(w*g));

%Drone Aircraft Radius
%Rotor Radius



g2 = ( (L*L)/(R) )*(cosd(360/nrot) - 1) + 1; 


f = CQ*nrot + 100 * max(0,g1) + 100 * max(0,g2);

%f = CQ*nrot;

end

