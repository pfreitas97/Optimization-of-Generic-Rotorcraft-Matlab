%v1 = induced velocity [ft/sec]
%sigma = solidity of rotor
%r = radius of blade element [ft]
%a = slope of lift curve [1/rad, 1/deg]
%R = rotor radius [ft]
%theta = blade pitch [rad,deg]

function [v1_o_sigmar] = getinduced_velocity(a,sigma,rR,theta)

v1_o_sigmar = (( a .* sigma ) ./ (16 .* rR)) .* (-1 + sqrt(1 + (32 .* theta .* rR) ./(a .* sigma)  ) ) ;

end