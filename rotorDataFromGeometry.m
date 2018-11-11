
%outputs: 
    %Thrust (Newtons),
    %Power Required (kiloWatts),

    %CT
    %CQ,        (make sure these 3 numbers are within expected range), 
    %CT/Sigma
    
    %, Disk loading (kg/m^2)
    %, max Mach number (must be below 0.7 for accuracy)

%inputs must be in METRIC
%outputs will be in metric

%inputs:
%b = number of blades usually between 2-4. 
%R = Radius in METERS
%C = Chord in METERS
%omega = ANGULAR velocity in rad/s DO NOT ALLOW Max Mach number TO BE > 0.7

%theta0 = collective pitch (angle at beginning of rotor MUST be chosen so no angle is ZERO

%thetaMin = angle at tip LINEAR TWIST ONLY (easier to manufacture)
%cl_cd_alpha: matrix with alpha in DEGREES in first column, cl in SECOND 
                        %and cd in third. [cl cd alpha]
                                                                          

function [thrust,fanThrust, powerReq, CT, CQ, CT_sigma,disk_loading, maxM] ...
    = rotorDataFromGeometry(b,R,C,omega,theta0,thetaMin,cl_cd_alpha) 

%ASSUMED CONSTANT SO FAR
rho_atm = 1.229; %kg/m^3
SpeedOfSound = 340; % m/s
%rho_atm = 23.777135; %;slug/ft^3
%SpeedOfSound = 1074.33; %ft/s



%  Rotor and ducted fan performance based on configuration
%  All units in SI

% Rotor geometry defines performance, will only use linear twist

% inputs: b,R, C,theta0, dtheta, cl vs alpha, cd vs alpha, omega)


% a = lift slope curve a = f(M) PER RADIAN 
% b = number of blades
% rR = r/R non dimensional chord ARRAY OF POINTS
% cR = c/R  non dimensional chord ARRAY OF POINTS
% local Mach M = (r/R)*[(omega*R)/SpeedOfSound] ARRAY OF POINTS
% local twist dtheta array of points
%  collective pitch =  theta0  note theta0 should be chosen so NEVER < 0

%  cl, cd will have to be inputed


alphazl = 0; %THIN AIRFOIL

cl = [cl_cd_alpha(:,1) .* ((pi)/180), cl_cd_alpha(:,2)];   %dconverts alpha to radians
cd = [cl_cd_alpha(:,1) .* ((pi)/180), cl_cd_alpha(:,3)];  % cd 

n = 10; % choice of number of blade elements (places to calculate along a blade)

rR = linspace(R/n, 1 - R/n,n); %tabulate R at the right number of points

%cR = linspace(C/n, 1 - C/n,n); %tabulate cR if chord changes

cR = C * ones(1,n);

M = (rR)*((omega*R)/SpeedOfSound); % Mach number at a point

maxM = M(end);
fprintf('Maximum mach number: %f \n', maxM);


dclda = diff(cl(:,2))./diff(cl(:,1));  
% ASSUMPTION: NO CL AFTER STALL GIVEN, DO NOT ENTER CL FOR STALLED WINGS


a = mean(dclda); %getting slope of lift curve from cl data


theta = linspace(theta0,thetaMin,n);

sigma = (b*C)/(pi*R);


%define get constant chord function



v1_omegar = getinduced_velocity(a,sigma,rR,theta);


alphas = getalpha(theta,v1_omegar);



%this finds minimun difference between our value for alpha and the one in
%the cl vs alpha curve
cLwithAlpha = zeros(10,1);
cDwithAlpha = zeros(10,1);

for i = 1:n %where n is the number of blade elements at the very top
    
    %disp(alphas(i))
    
    index = find(alphas(i) < cl(:,1));%matrix where index 1 is first time alpha is bigger
        
    indexCL = index(1) - 1; %we want the closest smallest value so we're not overestimating
    
    %disp(indexCL)
    
    cLwithAlpha(i) = cl(indexCL,2);
    cDwithAlpha(i) = cd(indexCL,2);
end


cLwithAlpha = cLwithAlpha';
cDwithAlpha = cDwithAlpha';
%8

dCT_drR = getRunningThrustLoading(b, rR, cR, cLwithAlpha);

%TODO 9 

CTnoTipLoss = getCTnoTipLoss(dCT_drR, rR); %changed to polyfit for integration 

%TODO 10
B = getTip_loss(CTnoTipLoss, b);


% 11

CT = getCTwithTipLoss(CTnoTipLoss, B,dCT_drR, rR,n); %CT For rotor

% 12

dCQ0_drR = getRunningProfileTorqueLoading(b, rR, cR, cDwithAlpha);


%  13
CQ0 = getProfileTorqueCoefficient(dCQ0_drR, rR); %changed to poly


% 14
dCQi_drR = getRunningInducedTorqueLoading(b,rR,cR,cLwithAlpha, v1_omegar);

   
x0 = 0.15; %x0 is the expected area near the base which will provide negligible lift thus neg cqi


CQi = getInducedTorqueCoefficient(dCQi_drR, rR, x0, B,n);


% 16 linear fit with data approx zero for CT < 0.007

%dCQ0 = getDQ0(swirl_i,thrust_i, CQ0);

linear_correction_129 = 0.018; %0.018 reasonable for Ct < 0.01

dCQi =  CQi * linear_correction_129;


% 17

disk_loading = getDiscLoading(CT, rho_atm, omega, R); 


% 18
CT_sigma = getCT_sigma(CT,b,C,R);


% best linear fit for correction factor 19 (fig 1.34)

linear_powercorrection = 1.02; %assume value its ok

% 20
CQ = (CQ0 + CQi + dCQi)*linear_powercorrection;


% 21
Area = pi*R*R;


thrust = rho_atm * Area * ((omega* R)^2) * CT; % Newton

fanThrust = rho_atm * Area * ((omega* R)^2) * CTnoTipLoss; %most optimistic scenario

powerReq = ((rho_atm * Area * ((omega* R)^3) * CQ))/1000; % kW






















 


