%ASSUMED CONSTANT SO FAR
rho_atm = 1.229; %kg/m^3
SpeedOfSound = 340; % m/s




%  Rotor and ducted fan performance based on configuration
%  All units in SI

% Rotor geometry defines performance

% function definition 
% outputs [thrust, power] 


% a = lift slope curve a = f(M) PER RADIAN 
% b = number of blades
% rR = r/R non dimensional chord ARRAY OF POINTS
% cR = c/R  non dimensional chord ARRAY OF POINTS
% local Mach M = (r/R)*[(omega*R)/SpeedOfSound] ARRAY OF POINTS
% local twist dtheta ARRAY OF POINTS
%  collective pitch =  theta0  note theta0 should be chosen so NEVER < 0

%  cl, cd will have to be inputed




M = (r/R)*((omega*R)/SpeedOfSound);


%define get constant chord function




% TODO 5


v1_omegar = getLocalInflowConstant(a,sigma,rR,theta);


%TODO 6
alpha = getAlpha(theta,v1_omegar);

%MUST extract this data from UIUC ---  7
% cl = get cl
% cd = get cd
%get cl and cd ARRAY for given configuration based on M or Re and blade elements


%8

dCT_drR = getRunningThrustLoading(b, rR, cR, cl);

%TODO 9 

CTnoTipLoss = getCTnoTipLoss(dCT_drR, rR);

%TODO 10
B = getTipLoss(CTnoTipLoss, b);


%TODO 11

CT = getCTwithTipLoss(CTnoTipLoss, B,dCT_drR, rR);


%TODO 12

dCQ0_drR = getRunningTorqueLoading(b, rR, cR, cd);


% TODO 13
CQ0 = getCQ0(dCQ0_drR, rR);


% 14
dCQi_drR = getRunningInducedTorqueLoading(b,rR,cR,cl, v1_omegar);


%TODO x0 will be considered zero for now -- 15
CQi = getCQi(dCQi_drR, rR, x0, B);


% TODO 16 linear fit with data
dCQ0 = getDQ0(swirl_i,thrust_i, CQ0);



% tODO 17

disk_loading = getDiskLoading(CT, rho_atm, omega, R); 


% TODO 18
CT_sigma = getCT_sigma(CT,b,c,R);

% best linear fit for correction factor 19



%TODO CHECK  20
CQ = CQ0 + CQi + dCQ0;



% 21
Thrust = rho_atm * Area * ((omega* R)^2) * CT;

horsePower = (rho_atm * Area * ((omega* R)^3) * CQ)/(550);




















 


