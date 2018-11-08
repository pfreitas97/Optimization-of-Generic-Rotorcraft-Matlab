function [Disc_Loading] = getDiscLoading(Coeff_T,rho,omega,R)

%% - - Initializations - - %%
CT = Coeff_T; %Thrust Coefficient [unitless]
rho = rho; %Density of Air [kg/m^3]
omega = omega; %Angular Velocity [Rad/Sec]
R = R; %Radius [Meters]

%% - - Calculations - - %%
Disc_Loading = CT*rho*(omega*R)^2;

end