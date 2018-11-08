

function [CT_notip] = getCTnoTipLoss(dCT_drR, rR)

p = polyfit(rR,dCT_drR,9);

CT_notip = quadgk( (@(x) polyval(p,x)), 0,1);

%CT_notip = trapz(rR, dCT_drR);



end