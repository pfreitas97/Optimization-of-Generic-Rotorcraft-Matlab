%C_T = coefficient of thrust
%rho = density of air [slug/ft^3]
%Omega = rotational speed of rotor [rad/sec]
%R = rotor radius [ft]

function [disk_loading]=getdisk_loading(C_T,rho,omega,R)

disk_loading = C_T*rho*(omega*R).^2;

end