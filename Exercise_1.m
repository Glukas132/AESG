clc
clear
[stations, data_all] = read_TRO_files("1_DATA\GO513138.TRO");
[Nw_RS, H_RS, ZTD_RS, lat0, lon0, H0] = read_RS_data("raob_soundings14969.txt");
%ZHD = Saastamoinen_ZHD(1013.25, stations.lat, stations.H);
ZTD = [data_all.ZTD];
%%
figure
geoscatter(stations.lat, stations.lon);
legend('GNSS stations');
title('Distribution of GNSS stations')
%%
figure
geoscatter(stations.lat, stations.lon, [], ZTD(1:24:end), 'filled');
colorbar;
title('ZTD [mm] of stations for epoch 13:138:01800')
%%
figure
geoscatter(stations.lat, stations.lon, [], stations.H, 'filled');
colorbar;
title('Height [m] of stations')
%%
figure
subplot(2,1,1)
scatter([1:254], stations.H,'.')
title('Station heights & ZTD values for epoch 13:138:01800')
ylabel('H [m]')
subplot(2,1,2)
scatter([1:254], ZTD(1:24:end),'.')
ylabel('ZTD [mm]')
xlabel('Station')
%%
temp_ZTD = [data_all.ZTD];
temp_epoch = {data_all.epoch};
temp_epoch = temp_epoch(331:354);
for i = 1:24
    epoch_str = char(temp_epoch(i));
    s = seconds(str2num(epoch_str(8:end)));
    s.Format = 'hh:mm:ss.SSS';
    temp_date(i) = datetime('2013-05-18') + s;
end
figure
scatter(temp_date, temp_ZTD(331:354))
title('CRAK')
ylabel('ZTD [mm]')
xlabel('Date & Time')
%%
figure
plot(Nw_RS, H_RS./1000, 'LineWidth',1.5)
title('10548 DOY: 138')
ylabel('Height [km]')
xlabel('Nw [ppm]')
%%
len = zeros(1,254);
C = zeros(255,3);
C(:,3) = 1;
ref_ell = referenceEllipsoid('wgs84');
for i = 1:254
    len(i) = distance(lat0,lon0, stations.lat(i), stations.lon(i), ref_ell);
end
[m, idx] = min(len);
lats = [stations.lat, lat0];
lons = [stations.lon, lon0];
C(end,:) = [1 0 0]; % RS station: Rot
C(idx,:) = [0 1 0]; % nächste GNSS station: schwarz
figure
gx = geoaxes('Basemap','colorterrain');
geoscatter(gx, lats, lons, [], C, '.')
title('Distribution of GNSS and RS stations')