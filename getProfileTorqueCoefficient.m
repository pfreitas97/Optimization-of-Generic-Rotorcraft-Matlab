%% function description
%{
The function is for equation 13 on the outline.  It will integrate for the
profile torque coefficient.
d_Cl0_dr_R and dr_R are both previously calculated.
*********************************
underscores are representing a division in the code below

*********************************************************************
I'm unsure if this code will work as I would need the previously calculated
functions to be able to run through the numerical integrator.  I think i
just need the variable to put in but im unsure of what the variable is.
Function runs when an x is put in function line though so general syntax is
right.
when i try to run this one it just gives values of zero but idk whats
different from the other numerical integrator
%}

function [c_l0] = getProfileTorqueCoefficient(d_Cl0_dr_R, dr_R)

p = polyfit(dr_R,d_Cl0_dr_R,9);

c_l0 = quadgk( (@(x) polyval(p,x)), 0,1);

 %c_l0 = trapz(dr_R,d_Cl0_dr_R);
end