function [ succes ] = Make_EPS_time_series(Namelist)
%Read in the ECMWF EPS time serie, convert the wind for all ensemble members to power and finds verifing observations 
%   Detailed explanation goes here
%load time series
[power_curve ] = get_power_curve( Namelist );
in_file=[Namelist{1}.ecmwf_eps_dir_in,'\eps_sprogoe_time_series.txt']
[Init valid U V ensemble_nr lead]=textread(in_file, '%s%s%f%f%u%u','whitespace',' ','headerlines',3);
header_lines=textread(in_file, '%s',35);
WSPD=(U.^2+V.^2).^0.5;
time_serie_length=length(U)
% choose hearvy air production as it is winter assuming air density = 1.283  kg/m^3
air_density_index=12
    for i=1:time_serie_length
        [min_difference, windspeed_index]   = min(abs(power_curve{1,2} - WSPD(i)));
        POWER(i)=power_curve{1,3}{air_density_index}(windspeed_index);
    end
    Power=double(POWER)';
 % find verifering observations
 % Any nwp time serie from the verification period can be taken 
 % but needed for every turbine 
 diri='C:\Users\jnini\MATLAB\work\AnEn\data\workspace\WRF\Out\experiments\Mahal_exp_Weighting_1_2010-10-31 12_00_2012-03-02 00_00_domaine_1';
 load([diri,'\turbine_time_series_for_nr_analogs_10'])
 %now start 
[m n]=size(turbine_time_series)
date_num_turbine=datenum(turbine_time_series(1,1).data{2,1},'dd-mm-yyyy HH:MM');
date_num_ecmwf=datenum(char(valid),'yyyymmddHH');
nr_ecmwf=length(date_num_ecmwf);
nr_verifing_obs=length(date_num_turbine);
Power_obs(1:nr_ecmwf,1:n)=Namelist{1}.missing_value;
for i=1:n
    for j=1:nr_verifing_obs
        verif_obs_idx=find(abs(date_num_turbine(j)-date_num_ecmwf)<Namelist{1}.minutes_in_fraction_of_a_day);
        Power_obs_verif(i,j)=turbine_time_series(1,i).data{2,15}(j);
        if not(isempty(verif_obs_idx))
            Power_obs(verif_obs_idx,i)=Power_obs_verif(i,j);
        end 
    end 
end

fout=[Namelist{1}.forecast_data_file_sprogoe,'\eps_sprogoe_time_series_and_power_obs.txt']
fid=fopen(fout,'w')

%generate output_strings
        seperator=' '
        out_string_header_1= [header_lines{1},seperator,header_lines{2},seperator,header_lines{3},seperator,header_lines{4},seperator,header_lines{5},seperator,header_lines{6},seperator,header_lines{7},seperator,header_lines{8},seperator,header_lines{9},seperator,header_lines{10},seperator]
        out_string_header_2=[header_lines{11},seperator,header_lines{12},seperator,header_lines{13},seperator,header_lines{14},seperator,header_lines{15},seperator,header_lines{16},seperator]
        out_string_header_3=[header_lines{1},seperator,'Missing value=-999']
        out_string_header_4= ['Init (utc)',seperator,'Valid (utc)',seperator,'Ecmwf_U_wind (m/s)',...
        seperator,'Ecmwf_V_wind (m/s)',seperator,'Ensemble_member',seperator,'Lead_hour',...
        seperator,'Predicted_power (kw)',seperator,'obs_power_turbine_1 (kw)',seperator,...
        'obs_power_turbine_2 (kw)',seperator,'obs_power_turbine_3 (kw)',seperator,'obs_power_turbine_4 (kw)',...
        seperator,'obs_power_turbine_5 (kw)',seperator,'obs_powe_turbine_6 (kw)',seperator,'obs_power_turbine_7 (kw)']  
    fprintf(fid,'%s\n',out_string_header_1)
    fprintf(fid,'%s\n',out_string_header_2)
    fprintf(fid,'%s\n',out_string_header_3)
    fprintf(fid,'%s\n',out_string_header_4)
    
    for i=1:nr_ecmwf
        out_string= [Init{i},seperator,valid{i},seperator,sprintf('%05.2f',U(i)),seperator,sprintf('%05.2f',V(i)), ...
        seperator,sprintf('%03u',ensemble_nr(i)),seperator,sprintf('%02u',lead(i)),seperator,sprintf('%07.2f',...
        POWER(i)),seperator  sprintf('%07.2f',Power_obs(i,1)),seperator,sprintf('%07.2f',Power_obs(i,2)), ...
        seperator,sprintf('%07.2f',Power_obs(i,3)),seperator,sprintf('%07.2f',Power_obs(i,4)),...
        seperator,sprintf('%07.2f',Power_obs(i,5)),seperator,sprintf('%07.2f',Power_obs(i,6)),...
        seperator,sprintf('%07.2f',Power_obs(i,7)) ];
        fprintf(fid,'%s\n',out_string);
        clear out_string
        i
    end 

% now

fclose(fid);
 succes=true;
end

