%% function description
%{
The function is for equation 15 on the outline.  It will compute the
induced torque coefficient.
dcli_dr_R and dr_R are already calculated.
a and x0 are constants we choose???
*********************************
underscores are representing a division in the actual code
%}

function [cli] = getInducedTorqueCoefficient(dcli_dr_R, dr_R, x0, B,n)
     
    p = polyfit(dr_R,dcli_dr_R, n - 1);
    
    cli = quadgk((@(x) polyval(p,x) ), x0, B); %Computationally expensive AF
    
    %cli = trapz(dr_R,dcli_dr_R);%not sure what I should make the step size for the x rangegetInducedTorqueCoefficient
end