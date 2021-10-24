function  [ZHD] = Saastamoinen_ZHD(p,B,H) 

%function designed to calculate Zenith Hydrostatic Delay from Saastamoinen equation

%__________INPUT_________
% p - pressure [hPa]
% B - latitude [rad]
% H - height [m]
%_________OUTPUT__________
% ZHD - the ZHD[m]

%symvar p B H mB mH mp 
ZHD=(0.002267*p)/(1-0.00266*cos(2*(B))-0.00000028*H); %Saastamoinen equation

end
