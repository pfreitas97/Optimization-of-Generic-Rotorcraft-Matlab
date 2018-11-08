%C_T = thrust coefficient
%sigma = solidity of rotor
%b = number of blades
%c = chord of blade [ft]
%R = rotor of radius [ft]

function [C_Tosigma] = getCT_sigma(C_T,b,c,R)

C_Tosigma = (C_T*pi*R)/(b*c);

end