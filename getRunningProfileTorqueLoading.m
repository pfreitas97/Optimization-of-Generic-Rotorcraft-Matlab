%% function description
%{
The function is for equation 12 on the outline.  It will calculate the
running profile torque loading.
b, r/R, c/R, cd are all known.
*********************************
underscores are representing a division in the code below
%}

function [dcl0_dr_R] = getRunningProfileTorqueLoading(b, r_R, c_R, cd)
    dcl0_dr_R = (b .* (r_R).^3 .* c_R .* cd) / (2 * pi);
end