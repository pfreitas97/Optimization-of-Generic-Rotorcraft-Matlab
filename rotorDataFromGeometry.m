%outputs: 
    %Thrust (Newtons),
    %Power Required (kiloWatts),

    %CT
    %CQ,        (make sure these 3 numbers are within expected range), 
    %CT/Sigma
    
    %, Disk loading (kg/m^2)
    %, max Mach number (must be below 0.7 for accuracy)

%inputs must be in Metric
%outputs will be in Metric

%inputs:
%b = number of blades between 2-4. 5+ MIGHT be possible but research would be needed

%R = Radius in Meters

%C = Chord in Meters if chord changes please input the value of the chord
        %at every blade element point, default is 10

%omega = Angular velocity in rad/s   MAX Mach number should be > 0,7 for
                                                            %reliable results
                                                            
                                                            
%theta0 = collective pitch (angle at beginning of rotor MUST be chosen so no angle is below ZERO



%thetaMin = angle at tip Using Linear Twist Only (easier to manufacture)


%cl_cd_alpha: matrix with airfoil data 
    %Expected: Angle of attack alpha in degrees in first column 
               % cl in second 
               % cd in third. 
               % Dimensions: [n,3].
               
               
                        
                                                                          

function [thrust, powerReq, CT, CQ, CT_sigma,disk_loading, maxM] ...
    = rotorDataFromGeometry(b,R,C,omega,theta0,thetaMin,cl_cd_alpha) 

%% Step 1 Parsing data

%Assumed constant for a temperature of 20 Celsius ne

rho_atm = 1.225; %kg/m^3
SpeedOfSound = 340; % m/s


%  Rotor and ducted fan performance based on configuration
%  All units in SI

% Rotor geometry defines performance: will only use linear twist

% inputs: b,R, C,theta0, dtheta, cl vs alpha, cd vs alpha, omega)


% a = lift slope curve a = f(M) PER RADIAN

% b = number of blades

% rR = r/R non dimensional chord Blade element points

% cR = c/R  non dimensional chord Blade element points

% local Mach M = (r/R)*[(omega*R)/SpeedOfSound] Blade element points


% local twist dtheta Blade element points

%  collective pitch =  theta0  note theta0 should be chosen so NEVER < 0

%  cl, cd will have to be inputed




% Utilizing the angle of minimum |cl|  as zero lift angle please make sure
% zero lift angle is in file.

alphazlIndex = find(cl_cd_alpha(:,2) == min(abs(cl_cd_alpha(:,2))));

alphazl = cl_cd_alpha(alphazlIndex,1) * ((pi)/180); %Angle of zero lift is kept as radians



cl = [cl_cd_alpha(:,1) * ((pi)/180), cl_cd_alpha(:,2)];   %dconverts alpha to radians
cd = [cl_cd_alpha(:,1) * ((pi)/180), cl_cd_alpha(:,3)];  % cd 



%% Step 2 Select number of blade elements

n = 10; % choice of number of blade elements (places to calculate along a blade)



rR = linspace(R/n, 1 - R/n,n); %tabulate R at the right number of points


cR = C * ones(1,n);

%% Step 3 Obtaining lift slope and checking mach number

M = (rR)*((omega*R)/SpeedOfSound); % Mach number at a point

maxM = M(end);

if maxM > 0.7
    warning('Maximum mach number is greater than expected maximum results may not be accurate. Max Mach: %f \n', maxM)
end


%Utilizing the slope only until stall please make sure the airfoil does not
%stall with the chosen configuration

maxCLindex = find(cl_cd_alpha(:,2) == max(cl_cd_alpha(:,2)));

dclda = diff(cl(1:maxCLindex,2))./diff(cl(1:maxCLindex,1));  


a = mean(dclda); %getting slope of lift curve from cl data

%% Step 4 obtaing the effective angle at each blade element

theta = linspace(theta0,thetaMin,n) - alphazl;

% Solidity
sigma = (b*C)/(pi*R);


%define get constant chord function

%% Step 5 Obtaining Local inflow angles

v1_omegar = getinduced_velocity(a,sigma,rR,theta);



%% Step 6 Obtaining local angle of attack
alphas = getalpha(theta,v1_omegar);



%% Step 7 tabulating cl and cd value
%this finds minimun difference between our value for alpha and the one in
%the cl vs alpha curve
cLwithAlpha = zeros(10,1);
cDwithAlpha = zeros(10,1);

for i = 1:n %where n is the number of blade elements at the very top
    
        
    index = find(alphas(i) < cl(:,1)); %matrix where index 1 is first time alpha is bigger
        
    indexCL = index(1) - 1; %we want the closest smallest value so we're not overestimating
        
    cLwithAlpha(i) = cl(indexCL,2);
    cDwithAlpha(i) = cd(indexCL,2);
end


cLwithAlpha = cLwithAlpha';
cDwithAlpha = cDwithAlpha';

%% Step 8 Obtaining Running Thrust Loading

dCT_drR = getRunningThrustLoading(b, rR, cR, cLwithAlpha);

%% Step 9 Integrate numerically for Coefficient of thrust without tip loss

CTnoTipLoss = getCTnoTipLoss(dCT_drR, rR); 

%% Step 10 Accounting for Tip loss
B = getTip_loss(CTnoTipLoss, b);


%% Step 11 Obtaining an accurate CT for a rotor

%CT =  CTnoTipLoss; %Uncomment for no tip loss assumption if using Fan

CT = getCTwithTipLoss(CTnoTipLoss, B,dCT_drR, rR,n); %CT For rotor


%% Step 12 Calculating Running profile torque loading

dCQ0_drR = getRunningProfileTorqueLoading(b, rR, cR, cDwithAlpha);


%% Step 13 Integrating for torque coefficient

CQ0 = getProfileTorqueCoefficient(dCQ0_drR, rR);


%% Step 14 Calculating Running induced torque loading

dCQi_drR = getRunningInducedTorqueLoading(b,rR,cR,cLwithAlpha, v1_omegar);


%% Step 15 integrating induced torque loading 
% x0 will be considered 0.15.

x0 = 0.15; %x0 is the expected area near the base which will provide negligible lift 
                                                            %thus negligible cqi


CQi = getInducedTorqueCoefficient(dCQi_drR, rR, x0, B,n);


%% Step 16 Obtaining estimate for Power losses due to Rotation Wake 

% Utilizing results from: 

% Wu, Sigman, & Goorjian. "Optimum performance of Hovering Rotors" NASA TMX 62138, 1972

%dCQ0 = getDQ0(swirl_i,thrust_i, CQ0);

ct_tested = linspace(0,0.05,11);

linearCorrection = [0 0.11, 0.28 0.4 0.53 0.64 0.75 0.83 0.92 1.0 1.1];

[~,~,index]=unique(round(abs(ct_tested - CT)),'stable'); %finding closest value ct
linear_correction_129= linearCorrection(index == 1);

dCQi =  CQi * linear_correction_129;


%% Step 17 Obtaining disk loading

disk_loading = getDiscLoading(CT, rho_atm, omega, R); 


%% Step 18 Coefficient of Thrust by solidity
CT_sigma = getCT_sigma(CT,b,C,R);


%% Step 19 Obtain best linear fit for correction factor 19 (fig 1.34)

% utilizing Disk Loading * Coefficient of Thrust divided by solidity

% Correction factor derived in Helicopter Performance, Stability and Control Prouty R.W
                            
DL_X_CT_sigma = disk_loading * CT_sigma;



% linear correction can be changed to fit model more accurately if more data is available

linear_powercorrection = 0.94 + (1.06 * DL_X_CT_sigma); 

%% Step 20 Calculate total torque coefficient
CQ = (CQ0 + CQi + dCQi)*linear_powercorrection;


%% Step 21 Outputs can be changed to return what is required
Area = pi*R*R;

thrust = rho_atm * Area * ((omega* R)^2) * CT; % Newton

powerReq = ((rho_atm * Area * ((omega* R)^3) * CQ))/1000; % kW



















 


