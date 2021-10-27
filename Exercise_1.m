if exist("GO513138.TRO.mat", "file")
    load("GO513138.TRO.mat");
else
    TRO = read_TRO_files("1_DATA\GO513138.TRO");
    save("GO513138.TRO.mat", "TRO")
end
if exist("raob_soundings14969.txt.mat", "file")
    load("raob_soundings14969.txt.mat")
else
    RS = read_RS_data("raob_soundings14969.txt");
    save('raob_soundings14969.txt.mat', "RS");
end

ZHD = Saastamoinen_ZHD(1013.25, TRO.lat, TRO.H);
ZTD = ZHD;
%%
figure
geoscatter(TRO.lat, TRO.lon);
legend('GNSS stations');
title('Distribution of GNSS stations')
%%
figure
geoscatter(TRO.lat, TRO.lon, [], TRO.H, 'filled');
colorbar;
title('H values')
%%
figure
geoscatter(TRO.lat, TRO.lon, [], ZTD, 'filled');
colorbar;
title('ZTD values')