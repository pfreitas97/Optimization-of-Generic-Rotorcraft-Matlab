%% function description
%{
The function is for equation 8 on the outline.  It will compute the running
thrust loading.
b is wingspan?, r/R and c/R are already calculated, cl is already
calculated.
*********************************
underscores are representing a division in the code below
%}

function [dCT_dr_R] = getRunningThrustLoading(b, r_R, c_R, cl)

    dCT_dr_R = (b .* (r_R).^2 .* (c_R) .* cl) ./ (2 * pi);
end