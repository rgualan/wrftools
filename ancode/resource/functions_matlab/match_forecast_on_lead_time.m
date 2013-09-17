function [ dates weights ] = match_forecast_on_lead_time(Historical_forecast_vector,forecast_vector,Namelist,leadtime,good_turbine_data,num_obs_dates)
%MATCH_FORECAST_ON_LEAD_TIME Summary of this function goes here
%   Detailed explanation goes here

% first compute all distances

distance_on_lead_time=get_distance_on_lead_time(Historical_forecast_vector,forecast_vector,Namelist,leadtime);
% now get the index for the 10 best analogs 
    [analog_dis analog_idx]=sort(distance_on_lead_time);
    
% now get the sorted dates for the
% Namelist{5}.Analog.number_of_analogs_search_for best analogs 1 is the one
% best matching option tomake sure good observation exist for the found dates else take new ones 
    dates='01-09-2010 12:00';
    date_counter=1;
    dummy=1;
    done=0;
if Namelist{6}.make_sure_obs_exist_for_each_analog
    while not(done)& dummy<=length(Historical_forecast_vector.var_data{2,1}(analog_idx,:))
        %find index for analogs in observation
        idx=find(datenum(Historical_forecast_vector.var_data{2,1}(analog_idx(dummy),:),Namelist{1}.datstr_general_format)...
            ==num_obs_dates);
        % check good observation exists
        if good_turbine_data{1,1}(idx)>Namelist{7}.minimum_turbines_producing_for_analogs...
           & good_turbine_data{1,4}(idx)<25 & ~isempty(idx)% make sure wind speed is below cutout tresshold
            dates(date_counter,:)=Historical_forecast_vector.var_data{2,1}(analog_idx(dummy),:);
    %        test(date_counter,:)=Historical_forecast_vector.var_data{2,1}(analog_idx(date_counter),:);
            date_counter=date_counter+1;
            dummy=dummy+1;
        else
            dummy=dummy+1;
        end
          [m n] =size(dates);
          if m==Namelist{5}.Analog.number_of_analogs_search_for
              done=1;
          end
    end
else
    dates=Historical_forecast_vector.var_data{2,1}(analog_idx(1:Namelist{5}.Analog.number_of_analogs_search_for),:);
end
% make sure good observation exist for the found dates else take new ones 

%now get the sorted Weights for the
% Namelist{5}.Analog.number_of_analogs_search_for best analogs 1 is the one
% best matching
% 2 is hard coded becaouse first analog it the forecast itself Change when
% going to reel time 
norm_factor=1./analog_dis(2:Namelist{5}.Analog.number_of_analogs_search_for);
    for i=2:Namelist{5}.Analog.number_of_analogs_search_for
        weights(i)=((1/analog_dis(i)))/sum(norm_factor);
    end
 % check the results 
 analogmtx(1,:)=Historical_forecast_vector.var_data{2,2}(analog_idx(1:Namelist{5}.Analog.number_of_analogs_search_for)); %wspd
 analogmtx(2,:)=Historical_forecast_vector.var_data{2,3}(analog_idx(1:Namelist{5}.Analog.number_of_analogs_search_for)); %wdirection
 analogmtx(3,:)=Historical_forecast_vector.var_data{2,4}(analog_idx(1:Namelist{5}.Analog.number_of_analogs_search_for)); % sea level preasure
 analogmtx(4,:)=Historical_forecast_vector.var_data{2,5}(analog_idx(1:Namelist{5}.Analog.number_of_analogs_search_for)); %Air density
 
 if Namelist{7}.analog_plot
     subplot(4,1,1)
     hist(analogmtx(1,:));legend(strcat('True:',num2str(forecast_vector.var_data{2,2}),' m/s'));grid on;
     subplot(4,1,2)
     hist(analogmtx(2,:));legend(strcat('True:',num2str(forecast_vector.var_data{2,3}),' Degree north'));grid on;
     subplot(4,1,3)
     hist(analogmtx(3,:));legend(strcat('True:',num2str(forecast_vector.var_data{2,4}),' hpa'));grid on;
     subplot(4,1,4)
     hist(analogmtx(4,:));legend(strcat('True:',num2str(forecast_vector.var_data{2,5}),' kg/m3'));grid on;
     filename=strcat(Namelist{1}.plots_data_dir,'Analog_ditribution on lead_',num2str(leadtime),Namelist{5}.Analog.now)
     print('-djpeg',filename)

 end % if 
 
 
 




end

