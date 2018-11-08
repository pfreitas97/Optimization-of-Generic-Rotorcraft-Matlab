%% function description
%{
The function is for equation 14 on the outline.  It will compute the
running induced torque loading.
b is wingspan?, r/R , c/R , cl, (v1/ohmr) have all been calculated
previously.
*********************************
underscores are representing a division in the code below
%}

function [dCl_dr_R] = getRunningInducedTorqueLoading(b, r_R, c_R, cl, v1_ohmr)
    dCl_dr_R = (b * (r_R).^3 .* c_R .* cl .* v1_ohmr) / (2 * pi);
end