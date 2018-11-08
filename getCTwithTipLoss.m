
%corrects the ct value based on expected loss of lift due to tip effects

function [CT_tip] = getCTwithTipLoss(CTnoTipLoss, B,dCT_drR, rR,n)

p = polyfit(rR, dCT_drR, n- 1);

tiploss = quadgk( (@(x) polyval(p,x)), B,1);

CT_tip = CTnoTipLoss - tiploss;

end