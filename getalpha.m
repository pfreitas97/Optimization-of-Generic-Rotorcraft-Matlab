%alpha = angle of attack [deg]
%theta = blade pitch [rad,deg]
%v1 = induced velocity [ft/sec]
%sigma = solidity of rotor
%r = yaw rate [rad/sec]

function [alpha] = getalpha(theta,v1)

induced_angle = atan2(v1, 1);
alpha =  theta - induced_angle;

end