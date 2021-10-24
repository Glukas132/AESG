function [Nw_RS, H_RS, ZTD_RS, lat0, lon0, H0] = read_RS_data(file_RS)

% Reads RS data and computes wet refractivity
% Input:
% (1) file_RS: file name with RS data

%   Output:
% (1) Nw_RS: Wet refractivity at particular levels [ppm]
% (2) H_RS: Ellipsoidal height of particular levels [m]
% (3) ZTD_RS: Zenith total delay [m]
% (4) lat0: RS station lat [m]
% (5) lon0: RS station lon [ppm]
% (6) H0: RS station ellipsoidal height [m]
% epoch

%DoY and time
doy=125;
hh=0;

% Time 
date_matlab = doy2date(doy,2013);
dt_matlab = datetime(date_matlab,'ConvertFrom','datenum');
yyyy = year(dt_matlab);
mn = month(dt_matlab);
dm = day(dt_matlab);
clear date_matlab dt_matlab

%% Read RS
in    = fopen(file_RS,'r');
if in ~= -1
    frewind(in);
    tline = fgets(in);
    tline2 = fgets(in);
    header_dat = textscan(tline2,'%d %d %d %s %s %d %d'); 
    
    % lat [deg]/lon[deg]/H[m] RS 10548
    lat0 = str2double(cellfun(@(x) x(1:end-1), header_dat{4},'un',0));
    lon0 = str2double(cellfun(@(x) x(1:end-1), header_dat{5},'un',0));
    H0 = header_dat{6};
    
    dat   = textscan(in,'%d %f %f %f %f %f %f','HeaderLines',4); %Skip first 4 lines
    p_RS  = dat{2}./10; %[hPa]
    H_RS  = dat{3};     % [m] Convert to ??? -49.9m for Innsbruck
    T_RS  = dat{4}./10; % [oC]
    Td_RS = dat{5}./10; % [oC]
    fclose(in);
end
    
% Find end delete uncomplete records
id_del = unique([find(H_RS == 99999)',find(T_RS == 9999.9)',find(Td_RS == 9999.9)']);
p_RS(id_del) = [];
H_RS(id_del) = [];
T_RS(id_del) = [];
Td_RS(id_del) = [];
    
% Compute water vapour pressure from dewpoint temperature
e_RS = 6.112*exp(17.62*Td_RS./(243.12+Td_RS));
    
% Refractivity coefficients
Md  = 28.9645;       % [kg/kmol]
Mw  = 18.01528;      % [kg/kmol]
k1  = 77.689;        % [K/hPa]
k2  = 71.295;        % [K/hPa]
k3  = 375463;        % [K^2/hPa]
k2p = k2-k1*(Mw/Md); % [K/hPa] aprox. 22.1
    
% Compute wet refractivity
Nw_RS = k2p*e_RS./(T_RS+273.15)+k3*e_RS./(T_RS+273.15).^2;

% Calculating ZWD, ZHD and ZTD [m]
ZWD_RS = 10^-6 * sum(Nw_RS);
ZHD_RS = Saastamoinen_ZHD(p_RS(1),deg2rad(lat0),H_RS(1)); 
ZTD_RS = ZHD_RS + ZWD_RS;

end