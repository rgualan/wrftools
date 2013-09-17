function [ weighted_power_distribution ] = get_weighted_power_distribution(good_turbine_data,idx_power_obs,Namelist,weights)
%GET_WEIGHTED_POWER_DISTRIBUTION Summary of this function goes here
%   Detailed explanation goes here
% first tjeck if all urbines are producing as surposed to
good_idx=idx_power_obs(find(idx_power_obs>0)) % make sure observation on the anlog dates were found 
good_weights=weights(find(idx_power_obs>0))
% renormalized weithgts
sum(good_weights) 
norm_weights=(good_weights)/sum(good_weights)
switch 1
    case Namelist{1,7}.adjust_for_non_producing_turbines
        for i=1:length(good_idx)
            if good_turbine_data{1,1}(good_idx(i))
                correction_factor=Namelist{1}.number_of_turbines_in_park/good_turbine_data{1,1}(good_idx(i))
                corrected_observed_power(i)=correction_factor*good_turbine_data{1,3}(good_idx(i))
            else
                corrected_observed_power(i)=0
            end 
        end %for
   weighted_power_distribution=norm_weights.*corrected_observed_power
   corrected_observed_power
   
   deterministic_power=sum(weighted_power_distribution)
% now produce the weighted distribution

        
    case Namelist{1,7}.disregard_non_producing_turbines
end %switch
        
dav='hej'


end

