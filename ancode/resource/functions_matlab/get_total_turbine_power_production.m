function [ total_turbine_power_production ] = get_total_turbine_power_production( Namelist,turbine_data )
%GET_TOTAL_PRODUCTION Summary of this function goes here
%   Detailed explanation goes here
n_obs=datenum(cell2mat(turbine_data{1,17}),Namelist{1}.datstr_turbine_input_format); % ''yyyy-mm-dd HH:MM');
disp(strcat('Observation started :',datestr(min(n_obs),Namelist{1}.datstr_turbine_input_format)));
disp(strcat('Observation ended :',datestr(max(n_obs),Namelist{1}.datstr_turbine_input_format)));

num_start_time=min(n_obs);
num_current_time=num_start_time;
%disp(strcat('new obs time ',datestr(addtodate(num_start_time, 10, 'Minute'))));
% for all time between start date and end date, add 10 minutes and sum
% production if all turbiunes were running
dummy=1;
    total_turbine_power_production{2,1}= 'numer of observing turbine'
    total_turbine_power_production{2,2}='Time stamp'
    total_turbine_power_production{2,3}='Mean production kw'
    total_turbine_power_production{2,4}=' mean wind speed '
    total_turbine_power_production{2,5}='mean wind direction'  
    total_turbine_power_production{2,6}='numer of wind observing turbine'  
    num_current_time=addtodate(num_current_time, 20, 'Minute')
    disp(strcat('Observation started :',datestr(num_current_time,Namelist{1}.datstr_turbine_input_format)));
    
while addtodate(num_current_time, 1, 'Hour')<= max(n_obs)
  % while addtodate(num_current_time, 1, 'Hour')<= num_start_time+10
%    for testing works on only a small subset of obs
    % find all observation with same timestamp and all turbines in functional operation
    %datestr(num_current_time,Namelist{1}.datstr_turbine_input_format)
    
    indx=find(strcmp(datestr(num_current_time,Namelist{1}.datstr_turbine_input_format),turbine_data{1,17}) & turbine_data{1,24}>0 );

    if Namelist{6}.Get_Power_Obs_even_when_not_all_is_producing
        if (isempty(indx)==0) % Date match and turbine is exporting to grid  
            total_turbine_power_production{1,1}(dummy)=length(indx); % numer of observing turbine
            total_turbine_power_production{1,2}(dummy,:)=datestr(num_current_time,Namelist{1}.datstr_turbine_input_format);
            total_turbine_power_production{1,3}(dummy)=sum(turbine_data{1,24}(indx)); % Mean production kw
            total_turbine_power_production{1,4}(dummy)=mean(turbine_data{1,20}(indx)); % mean wind speed 
            total_turbine_power_production{1,5}(dummy)=mean(turbine_data{1,19}(indx)); % mean wind direction  
        else % just take the mean wind speed and wind direction
            indx_2=find(strcmp(datestr(num_current_time,Namelist{1}.datstr_turbine_input_format),turbine_data{1,17})& isnan(turbine_data{1,20})==0 );
            total_turbine_power_production{1,1}(dummy)=length(indx); % numer of observing turbine
            total_turbine_power_production{1,2}(dummy,:)=datestr(num_current_time,Namelist{1}.datstr_turbine_input_format);
            total_turbine_power_production{1,3}(dummy)=0; % Mean production kw
            total_turbine_power_production{1,4}(dummy)=mean(turbine_data{1,20}(indx_2)); % mean wind speed 
            total_turbine_power_production{1,5}(dummy)=mean(turbine_data{1,19}(indx_2)); % mean wind direction  
            total_turbine_power_production{1,6}(dummy)=length(indx_2); % numer of wind observing turbine
        end %(is empty idx)

    else
        if (isempty(indx)==0 & length(indx)==Namelist{1}.number_of_turbines_in_park) % gevinst p� alle turbiner 
            total_turbine_power_production{1,1}(dummy)=length(indx); % numer of observing turbine
            total_turbine_power_production{1,2}(dummy,:)=datestr(num_current_time,Namelist{1}.datstr_turbine_input_format);
            total_turbine_power_production{1,3}(dummy)=sum(turbine_data{1,24}(indx)); % Mean production kw
            total_turbine_power_production{1,4}(dummy)=mean(turbine_data{1,20}(indx)); % mean wind speed 
            total_turbine_power_production{1,5}(dummy)=mean(turbine_data{1,19}(indx)); % mean wind direction  
        else
            indx_2=find(strcmp(datestr(num_current_time,Namelist{1}.datstr_turbine_input_format),turbine_data{1,17})& isnan(turbine_data{1,20})==0 );
            total_turbine_power_production{1,1}(dummy)=length(indx); % numer of observing turbine
            total_turbine_power_production{1,2}(dummy,:)=datestr(num_current_time,Namelist{1}.datstr_turbine_input_format);
            total_turbine_power_production{1,3}(dummy)=0; % Mean production kw
            total_turbine_power_production{1,4}(dummy)=mean(turbine_data{1,20}(indx_2)); % mean wind speed 
            total_turbine_power_production{1,5}(dummy)=mean(turbine_data{1,19}(indx_2)); % mean wind direction  
            total_turbine_power_production{1,6}(dummy)=length(indx_2); % numer of wind observing turbine

        end
        
    end % Namelist{6}.Get_Power_Obs_even_when_not all_is_producing
    dummy=dummy+1;
    num_current_time=addtodate(num_current_time, 1, 'Hour');
    [Y, M, D, H, MN, S] = datevec(num_current_time);
    if MN~=0
           num_current_time=datenum(Y, M, D, H, 0, 0);
    end
    
    if mod(dummy,100)==0
    disp(strcat('operation on observation from :',datestr(num_current_time,Namelist{1}.datstr_general_format)));
    end 
end % while 
    
   
end
