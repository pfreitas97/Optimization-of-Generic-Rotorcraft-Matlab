function [B] = getTip_loss(ct_ntip, b)
%FUNCTION DETAILS
%the purpose of this function is to calculate the tip loss factor

%Function takes inputs:
%ct_ntip: coefficient of no tip loss
%b

%Function outputs:
%B: tip loss factor

B = 1 - sqrt(2 * ct_ntip) / b;

end
