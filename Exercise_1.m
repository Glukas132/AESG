if exist("GO513138.TRO.mat", "file")
    load("GO513138.TRO.mat");
    load("GO513138.data_all.mat");
else
    [stations, data_all] = read_TRO_files("1_DATA\GO513138.TRO");
    save("GO513138.TRO.mat", "stations");
    save("GO513138.data_all.mat", "data_all");
end
[Nw_RS, H_RS, ZTD_RS, lat0, lon0, H0] = read_RS_data("raob_soundings14969.txt");
%ZHD = Saastamoinen_ZHD(1013.25, stations.lat, stations.H);
ZTD = [data_all.ZTD];
ZTD = ZTD(1:24:end);
%%
figure
geoscatter(stations.lat, stations.lon);
legend('GNSS stations');
title('Distribution of GNSS stations')
%%
figure
geoscatter(stations.lat, stations.lon, [], stations.H, 'filled');
colorbar;
title('H values')
%%
figure
geoscatter(stations.lat, stations.lon, [], ZTD, 'filled');
colorbar;
title('ZTD values')
%%
figure
subplot(2,1,1)
scatter([1:254], stations.H,'.')
subplot(2,1,2)
scatter([1:254], ZTD,'.')
%%
temp = [data_all.ZTD];
figure
scatter([1:24],temp(1:24))
%%
figure
plot(Nw_RS, H_RS)
%%
len = zeros(1,254);
C = zeros(255,3);
C(:,3) = 1;
for i = 1:254
    len(i) = distance(lat0,lon0, stations.lat(i), stations.lon(i));
end
[m, idx] = min(len);
lats = [lat0, stations.lat];
lons = [lon0, stations.lon];
C(1,:) = [1 0 0]; % RS station: Rot
C(idx+1,:) = [0 0 0]; % nächste GNSS station: schwarz
figure
gx = geoaxes('Basemap','colorterrain');
geoscatter(gx, lats, lons, [], C)