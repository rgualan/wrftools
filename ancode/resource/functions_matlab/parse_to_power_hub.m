function [ counts out_filename ] = parse_to_power_hub(Namelist,Availabilty_vector)
%PARSE_TO_POWER_HUB Summary of this function goes here
%   Detailed explanation goes here

load([Namelist{2}.forecast_in_dir,'\power_forecast'])
[m nr_turbines]=size(power_forecast)
[m nr_leads]=size(power_forecast{1,1})
if exist(Namelist{1,2}.forecast_out_dir)
else
    mkdir(Namelist{1,2}.forecast_out_dir)
end
out_filename=[Namelist{1,2}.forecast_out_dir,'\','fct_pow_',power_forecast{1,1}(1,1).valid_dates(1:length(power_forecast{1,1}(1,1).valid_dates)-6)]
fid = fopen(out_filename,'w');
total_power=0;
lower_power_limit=0 % after morten Birk advice set to lowest possible power production
for i=1:nr_leads
    formatSpec = '%s \n';
    for j=1:nr_turbines
        total_power=power_forecast{1,j}(1,i).deterministic_power_forecast+total_power
    end
    %filestring=[power_forecast{1,1}(1,i).valid_dates ',' sprintf('%4.2f',lower_power_limit) ',' sprintf('%4.2f',total_power)]
    %28/09
    filestring=[power_forecast{1,1}(1,i).valid_dates ',' sprintf('%04.0f',lower_power_limit) ',' sprintf('%04.0f',total_power)]
    counts=fprintf(fid,formatSpec,filestring)
    total_power=0;
end
succes=1
fclose(fid)

end

