if exist("GO513138.TRO.mat", "file")
    load("GO513138.TRO.mat");
    load("GO513138.data_all.mat");
else
    [stations, data_all] = read_TRO_files("1_DATA\GO513138.TRO");
    save("GO513138.TRO.mat", "stations");
    save("GO513138.data_all.mat", "data_all");
end
if exist("raob_soundings14969.txt.mat", "file")
    load("raob_soundings14969.txt.mat");
else
    RS = read_RS_data("raob_soundings14969.txt");
    save('raob_soundings14969.txt.mat', "RS");
end
ZHD = Saastamoinen_ZHD(1013.25, stations.lat, stations.H);
ZTD = data_all.ZTD;
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