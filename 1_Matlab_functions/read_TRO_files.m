function   [site_ell,data_all] =  read_TRO_files( file_path,file_name)

%This function reads .TRO files

%   Output:
% (1) site_ell: Ellipsoidal coordinates (lat, lon, H) of all GNSS stations in file)
% (2) data_all: All tropospheric data (e.g. TROTOT == ZTD) depending on the
% epoch

file_path=[file_path file_name];
f = fopen(file_path);
tline = fgetl(f);
line_num_test=1;

% Station coordinates & Data
while ischar(tline)
    switch tline
        case '+TROP/STA_COORDINATES'
            %disp('Next lines are for stations coordinates');
            line_num_stat_beginn=line_num_test;
        case '-TROP/STA_COORDINATES'
            %disp('End of stations coordinates')
            line_num_stat_end=line_num_test;
        case '+TROP/SOLUTION'
            %disp('Trop solution')
            line_num_sol_beginn=line_num_test;
        case '-TROP/SOLUTION'
            %disp('End of trop solution')
            line_num_sol_end=line_num_test;
    end
    tline = fgetl(f);
    line_num_test = line_num_test + 1;
end
fclose(f);

f = fopen(file_path);
tline = fgetl(f);
line_num=1;
header_num=1;
site_num=1;
sections_num=1;
sol_num=1;
end_num=1;
while ischar(tline)
    % Read header
    if line_num <= line_num_stat_beginn+1
        header{header_num,1} = tline;
        header_num = header_num+1;
        % Read stations coordinates
    elseif line_num > line_num_stat_beginn+1 && line_num < line_num_stat_end
        %disp(tline);
        data_site{site_num} = textscan(tline,'%4s  %1s %d %1s %f %f %f %6s %3s','whitespace','','MultipleDelimsAsOne',1,'Delimiter',' ');
        site_num = site_num + 1;
        % Read the lines finishing and starting new section in the file
    elseif line_num >= line_num_stat_end && line_num <= line_num_sol_beginn+1
        sections_div{sections_num,1} = tline;
        sections_num = sections_num + 1;
        % Read data
    elseif line_num > line_num_sol_beginn+1 && line_num < line_num_sol_end
        %disp(tline);
        data_sol{sol_num} = textscan(tline,'%4s %12s %f %f %f %f %f %f','whitespace','','MultipleDelimsAsOne',1,'Delimiter',' ');
        sol_num = sol_num + 1;
    elseif line_num >= line_num_sol_end
        end_line{end_num,1} = tline;
        end_num = end_num +1;
    end
    tline = fgetl(f);
    line_num = line_num + 1;
end
fclose(f);

for i=1:length(data_site)
    site(i) = cell2struct(data_site{i},{'name' 'pt' 'soln' 't' 'X' 'Y' 'Z' 'system' 'remrk'},2);
end
for i=1:length(data_sol)
    sol(i) = cell2struct(data_sol{i},{'name' 'epoch' 'TROTOT' 'STDDEV_tro' 'TGNTOT' 'STDDEV_tgn' 'TGETOT' 'STDDEV_tge'},2);
end

%Convert cartesian coordinates to ellipsoidal coordinates
[site_ell.lat,site_ell.lon,site_ell.H] = kart2ell(cell2mat({site.X}),cell2mat({site.Y}),cell2mat({site.Z}));
site_ell.name = {site.name};

%Connect site coordinates (lat, lon, H) and data
num=1;
for i=1:length(site)
    for j=1:length(sol)
        if strcmp(char(site_ell.name{i}), char(sol(j).name))
            data_conn=[site_ell.name{i} site_ell.lat(i) site_ell.lon(i) site_ell.H(i) sol(j).epoch sol(j).TROTOT];
            data_all(num)=cell2struct(data_conn,{'name' 'lat' 'lon' 'H' 'epoch' 'ZTD'},2);
            num=num+1;
        end
    end
end


end

