function [ succes ] = do_accuracy_concanated_turbines_benchmarking_10_analogs( Namelist )
%DO_ACCURACY_NWP_ANALYSIS Summary of this function goes here
%   Detailed explanation goes here
close all
    exp_name='Turbine_by_turbine_winter_1_mslp_wspd_wdir_rho_shear_domaine_3' % this is bad and should be cahnged 14/05
    file_path=['C:\Users\jnini\MATLAB\work\AnEn\data\workspace\ETA\out\experiments\',exp_name]
    load([file_path,'\turbine_time_series_for_nr_analogs_10'])
    leadtime_vector=get_leadtime_vector(turbine_time_series,Namelist)'
    [ analogs_lead_times ] = get_analog_lead_times( Namelist );

    for j=analogs_lead_times
        obs=[];model=[];model_reg=[];model_raw=[];
        [m n]=size(turbine_time_series)
        for i=1:n
            % concanate loop
            good_idx{i}=find(turbine_time_series(1,i).data{2,15}~=Namelist{1}.missing_value & leadtime_vector==j);
            obs=vertcat(turbine_time_series(1,i).data{2,15}(good_idx{i}),obs);
            model=vertcat(turbine_time_series(1,i).data{2,2}(good_idx{i}),model);
            model_reg=vertcat(turbine_time_series(1,i).data{2,19}(good_idx{i}),model_reg);
            model_raw=vertcat(turbine_time_series(1,i).data{2,20}(good_idx{i}),model_raw);
        end
        
        if not(isempty(obs))
                if Namelist{10}.normalize_errors
                   [ETA_rmse_analogs_10(j) ETA_bias_analogs_10(j) ETA_crmse_analogs_10(j)] = RMSEdecomp_all(obs/Namelist{10}.rated_capasity_kw, model/Namelist{10}.rated_capasity_kw);
                   [ETA_rmse_regresion(j) ETA_bias_regresion(j) ETA_crmse_regresion(j)] = RMSEdecomp_all(obs/Namelist{10}.rated_capasity_kw, model_reg/Namelist{10}.rated_capasity_kw);
                   [ETA_rmse_raw(j) ETA_bias_raw(j) ETA_crmse_raw(j)] = RMSEdecomp_all(obs/Namelist{10}.rated_capasity_kw, model_raw/Namelist{10}.rated_capasity_kw);
                   
                   ETA_NMAE_analogs_10(j)=mean(abs(obs-model)/Namelist{10}.rated_capasity_kw);
                   ETA_NMAE_regresion(j)=mean(abs(obs-model_reg)/Namelist{10}.rated_capasity_kw);
                   ETA_NMAE_raw(j)=mean(abs(obs-model_raw)/Namelist{10}.rated_capasity_kw);
                    ETA_pearson_analogs_10(j)=corr(obs,model, 'Type', 'Pearson');
                    ETA_pearson_regresion(j)=corr(obs,model_reg, 'Type', 'Pearson');
                    ETA_pearson_raw(j)=corr(obs,model_raw, 'Type', 'Pearson');
      
                    ETA_spearman_rank_correltion_analogs_10(j)=corr(obs,model, 'Type', 'Spearman');
                    ETA_spearman_rank_correltion_regresion(j)=corr(obs,model_reg, 'Type', 'Spearman');
                    ETA_spearman_rank_correltion_raw(j)=corr(obs,model_raw, 'Type', 'Spearman');
                else
                   [ETA_rmse_regresion(j) ETA_bias_analogs10(j) ETA_crmse_10(j)] = RMSEdecomp_all(obs, model);
                    ETA_NMAE_10(j)=mean(abs(obs-model))
                    ETA_pearson_10(j)=corr(obs,model, 'Type', 'Pearson');
                    ETA_spearman_rank_correltion_10(j)=corr(obs,model, 'Type', 'Spearman');
                end
        else %isempty
                     ETA_rmse_analogs_10(j) =mean(ETA_rmse_analogs_10(12:j-1));
                     ETA_bias_analogs10(j) =mean(ETA_bias_analogs_10(12:j-1));
                     ETA_crmse_analogs_10(j) = mean(ETA_rmse_analogs_10(12:j-1));
                     ETA_NMAE_analogs_10(j)=mean(ETA_NMAE_analogs_10(12:j-1));
                     ETA_spearman_rank_correltion_analogs_10(j)=mean(ETA_spearman_rank_correltion_analogs_10(12:j-1))
                     
                     ETA_rmse_regresion(j) =mean(ETA_rmse_regresion(12:j-1));
                     ETA_bias_regresion(j) =mean(ETA_bias_regresion(12:j-1));
                     ETA_crmse_regresion(j) = mean(ETA_rmse_regresion(12:j-1));
                     ETA_NMAE_regresion(j)=mean(ETA_NMAE_regresion(12:j-1));
                     ETA_spearman_rank_correltion_regresion(j)=mean(ETA_spearman_rank_correltion_regresion(12:j-1))
                   
                     ETA_rmse_raw(j) =mean(ETA_rmse_raw(12:j-1));
                     ETA_bias_raw(j) =mean(ETA_bias_raw(12:j-1));
                     ETA_crmse_raw(j) = mean(ETA_rmse_raw(12:j-1));
                     ETA_NMAE_raw(j)=mean(ETA_NMAE_raw(12:j-1));
                     ETA_spearman_rank_correltion_raw(j)=mean(ETA_spearman_rank_correltion_raw(12:j-1))
        end
 end
    
    clear turbine_time_series;clear obs;clear model
    exp_name_wrf='Turbine_by_turbine_winter_1_mslp_wspd_wdir_rho_shear_domaine_3'
    file_path=['C:\Users\jnini\MATLAB\work\AnEn\data\workspace\WRF\out\experiments\',exp_name_wrf]
    load([file_path,'\turbine_time_series_for_nr_analogs_10']);Namelist{4}.nwp_model_domain=3;Namelist{4}.nwp_model{1}='WRF'
    leadtime_vector=get_leadtime_vector(turbine_time_series,Namelist)'
    [ analogs_lead_times_d3 ] = get_analog_lead_times( Namelist );
    
    for j=analogs_lead_times
        obs=[];model=[];model_reg=[];model_raw=[];
        
    % gets the index where obervation are not missing for each turbine 
    [m n]=size(turbine_time_series)    
        for i=1:n
             % concanate loop
            good_idx{i}=find(turbine_time_series(1,i).data{2,15}~=Namelist{1}.missing_value & leadtime_vector==j);
            obs=vertcat(turbine_time_series(1,i).data{2,15}(good_idx{i}),obs);
            model=vertcat(turbine_time_series(1,i).data{2,2}(good_idx{i}),model);
            model_reg=vertcat(turbine_time_series(1,i).data{2,19}(good_idx{i}),model_reg);
            model_raw=vertcat(turbine_time_series(1,i).data{2,20}(good_idx{i}),model_raw);
        end
           if not(isempty(good_idx{i}))
            if Namelist{10}.normalize_errors
                [WRF_d3_rmse_analogs_10(j) WRF_d3_bias_analogs_10(j) WRF_d3_crmse_analogs_10(j)] = RMSEdecomp_all(obs/Namelist{10}.rated_capasity_kw, model/Namelist{10}.rated_capasity_kw);
                WRF_d3_NMAE_regresion(j)=mean(abs(obs-model_reg)/Namelist{10}.rated_capasity_kw)
                WRF_d3_NMAE_raw(j)=mean(abs(obs-model_raw)/Namelist{10}.rated_capasity_kw)
           
                [WRF_d3_rmse_regresion(j) WRF_d3_bias_regresion(j) WRF_d3_crmse_regresion(j)] = RMSEdecomp_all(obs/Namelist{10}.rated_capasity_kw, model_reg/Namelist{10}.rated_capasity_kw);
                WRF_d3_NMAE_regresion(j)=mean(abs(obs-model)/Namelist{10}.rated_capasity_kw)
                [WRF_d3_rmse_raw(j) WRF_d3_bias_raw(j) WRF_d3_crmse_raw(j)] = RMSEdecomp_all(obs/Namelist{10}.rated_capasity_kw, model_raw/Namelist{10}.rated_capasity_kw);
                WRF_d3_NMAE_analogs_10(j)=mean(abs(obs-model)/Namelist{10}.rated_capasity_kw)
                WRF_d3_pearson_analogs_10(j)=corr(obs,model, 'Type', 'Pearson');
                WRF_d3_pearson_regresion(j)=corr(obs,model_reg, 'Type', 'Pearson');
                WRF_d3_pearson_raw(j)=corr(obs,model_raw, 'Type', 'Pearson');
                WRF_d3_spearman_rank_correltion_analogs_10(j)=corr(obs,model, 'Type', 'Spearman');
                WRF_d3_spearman_rank_correltion_regresion(j)=corr(obs,model_reg, 'Type', 'Spearman');
                WRF_d3_spearman_rank_correltion_raw(j)=corr(obs,model_raw, 'Type', 'Spearman');
                
            else
                [WRF_d3_rmse_analogs_10(j) WRF_d3_bias_analogs10(j) WRF_d3_crmse_10(j)] = RMSEdecomp_all(obs, model);
                WRF_d3_NMAE_10(j)=mean(abs(obs-model))
                WRF_d3_pearson_10(j)=corr(obs,model, 'Type', 'Pearson');
                WRF_d3_spearman_rank_correltion_10(j)=corr(obs,model, 'Type', 'Spearman');
            end % normalize
            
           else % is empty 
                WRF_d3_rmse_analogs_10(j)=mean(WRF_d3_rmse_analogs_10(12:j-1)) 
                 WRF_d3_bias_analogs10(j)=mean(WRF_d3_bias_analogs_10(12:j-1)) 
                 WRF_d3_crmse_analogs_10(j) = mean(WRF_d3_crmse_analogs_10(12:j-1))
                WRF_d3_NMAE_analogs_10(j)=mean(WRF_d3_NMAE_analogs_10(12:j-1))
                WRF_d3_pearson_analogs_10(j)=mean(WRF_d3_pearson_analogs_10(12:j-1))
                WRF_d3_spearman_rank_correltion_analogs_10(j)=mean(WRF_d3_spearman_rank_correltion_analogs_10(12:j-1))
           end % is empty    
    end % lead time

    exp_name_wrf='Turbine_by_turbine_winter_1_mslp_wspd_wdir_rho_shear_domaine_2'
    file_path=['C:\Users\jnini\MATLAB\work\AnEn\data\workspace\WRF\out\experiments\',exp_name_wrf]
    load([file_path,'\turbine_time_series_for_nr_analogs_10'])
    Namelist{4}.nwp_model_domain=2
    leadtime_vector=get_leadtime_vector(turbine_time_series,Namelist)'
    [ analogs_lead_times_d2 ] = get_analog_lead_times( Namelist );
   
    % gets the index where obervation are not missing for each turbine 
    for j=analogs_lead_times_d2
        obs=[];model=[];model_reg=[];model_raw=[];
    
    % gets the index where obervation are not missing for each turbine 
    [m n]=size(turbine_time_series)    
        for i=1:n
            good_idx{i}=find(turbine_time_series(1,i).data{2,15}~=Namelist{1}.missing_value & leadtime_vector==j);
            obs=vertcat(turbine_time_series(1,i).data{2,15}(good_idx{i}),obs);
            model=vertcat(turbine_time_series(1,i).data{2,2}(good_idx{i}),model);
            model_reg=vertcat(turbine_time_series(1,i).data{2,19}(good_idx{i}),model_reg);
            model_raw=vertcat(turbine_time_series(1,i).data{2,20}(good_idx{i}),model_raw);
        end % turbine id 
           if not(isempty(obs))
             if Namelist{10}.normalize_errors
                [WRF_d2_rmse_analogs_10(j) WRF_d2_bias_analogs_10(j) WRF_d2_crmse_analogs_10(j)] = RMSEdecomp_all(obs/Namelist{10}.rated_capasity_kw, model/Namelist{10}.rated_capasity_kw);
                WRF_d2_NMAE_regresion(j)=mean(abs(obs-model_reg)/Namelist{10}.rated_capasity_kw)
                WRF_d2_NMAE_raw(j)=mean(abs(obs-model_raw)/Namelist{10}.rated_capasity_kw)
                [WRF_d2_rmse_regresion(j) WRF_d2_bias_regresion(j) WRF_d2_crmse_regresion(j)] = RMSEdecomp_all(obs/Namelist{10}.rated_capasity_kw, model_reg/Namelist{10}.rated_capasity_kw);
                WRF_d2_NMAE_regresion(j)=mean(abs(obs-model)/Namelist{10}.rated_capasity_kw)
                
                [WRF_d2_rmse_raw(j) WRF_d2_bias_raw(j) WRF_d2_crmse_raw(j)] = RMSEdecomp_all(obs/Namelist{10}.rated_capasity_kw, model_raw/Namelist{10}.rated_capasity_kw);
                WRF_d2_NMAE_analogs_10(j)=mean(abs(obs-model)/Namelist{10}.rated_capasity_kw)
                
                WRF_d2_pearson_analogs_10(j)=corr(obs,model, 'Type', 'Pearson');
                WRF_d2_pearson_regresion(j)=corr(obs,model_reg, 'Type', 'Pearson');
                WRF_d2_pearson_raw(j)=corr(obs,model_raw, 'Type', 'Pearson');
                
                WRF_d2_spearman_rank_correltion_analogs_10(j)=corr(obs,model, 'Type', 'Spearman');
                WRF_d2_spearman_rank_correltion_regresion(j)=corr(obs,model_reg, 'Type', 'Spearman');
                WRF_d2_spearman_rank_correltion_raw(j)=corr(obs,model_raw, 'Type', 'Spearman');
                
            else
                [WRF_d2_rmse_analogs_10(j) WRF_d2_bias_analogs10(j) WRF_d2_crmse_10(j)] = RMSEdecomp_all(obs, model);
                WRF_d2_NMAE_10(j)=mean(abs(obs-model))
                WRF_d2_pearson_10(j)=corr(obs,model, 'Type', 'Pearson');
                WRF_d2_spearman_rank_correltion_10(j)=corr(obs,model, 'Type', 'Spearman');
            end
           else % is empty 
                WRF_d2_rmse_analogs_10(j)=mean(WRF_d2_rmse_analogs_10(find(WRF_d2_rmse_analogs_10~=0)) );
                WRF_d2_bias_analogs10(j)=mean(WRF_d2_bias_analogs_10(find(WRF_d2_bias_analogs_10~=0)) );
                WRF_d2_crmse_analogs_10(j) = mean(WRF_d2_crmse_analogs_10(find(WRF_d2_crmse_analogs_10~=0)));
                WRF_d2_NMAE_analogs_10(j)=mean(WRF_d2_NMAE_analogs_10(find(WRF_d2_NMAE_analogs_10~=0)) );
                WRF_d2_pearson_analogs_10(j)=mean(WRF_d2_pearson_analogs_10(find(WRF_d2_pearson_analogs_10~=0)));
                WRF_d2_spearman_rank_correltion_analogs_10(j)=mean(WRF_d2_spearman_rank_correltion_analogs_10(find(WRF_d2_spearman_rank_correltion_analogs_10~=0)))
           end
            
    end % for lead times 

    exp_name_wrf='Turbine_by_turbine_winter_1_mslp_wspd_wdir_rho_shear_domaine_1'
    file_path=['C:\Users\jnini\MATLAB\work\AnEn\data\workspace\WRF\out\experiments\',exp_name_wrf]
    load([file_path,'\turbine_time_series_for_nr_analogs_10']);Namelist{4}.nwp_model_domain=1
    leadtime_vector=get_leadtime_vector(turbine_time_series,Namelist)'
    [ analogs_lead_times_d1 ] = get_analog_lead_times( Namelist );
    
    % gets the index where obervation are not missing for each turbine 
    [m n]=size(turbine_time_series)    

    for j=analogs_lead_times_d1
       obs=[];model=[];model_reg=[];model_raw=[];
    
        
        % gets the index where obervation are not missing for each turbine 
    [m n]=size(turbine_time_series)    
        for i=1:n
          good_idx{i}=find(turbine_time_series(1,i).data{2,15}~=Namelist{1}.missing_value & leadtime_vector==j)
          obs=vertcat(turbine_time_series(1,i).data{2,15}(good_idx{i}),obs);
          model=vertcat(turbine_time_series(1,i).data{2,2}(good_idx{i}),model);
          model_reg=vertcat(turbine_time_series(1,i).data{2,19}(good_idx{i}),model_reg);
          model_raw=vertcat(turbine_time_series(1,i).data{2,20}(good_idx{i}),model_raw);
        end
           if not(isempty(obs))
            if Namelist{10}.normalize_errors
               [WRF_d1_rmse_analogs_10(j) WRF_d1_bias_analogs_10(j) WRF_d1_crmse_analogs_10(j)] = RMSEdecomp_all(obs/Namelist{10}.rated_capasity_kw, model/Namelist{10}.rated_capasity_kw);
                WRF_d1_NMAE_regresion(j)=mean(abs(obs-model_reg)/Namelist{10}.rated_capasity_kw)
                WRF_d1_NMAE_raw(j)=mean(abs(obs-model_raw)/Namelist{10}.rated_capasity_kw)
                
               [WRF_d1_rmse_regresion(j) WRF_d1_bias_regresion(j) WRF_d1_crmse_regresion(j)] = RMSEdecomp_all(obs/Namelist{10}.rated_capasity_kw, model_reg/Namelist{10}.rated_capasity_kw);
               WRF_d1_NMAE_regresion(j)=mean(abs(obs-model)/Namelist{10}.rated_capasity_kw)
                
                [WRF_d1_rmse_raw(j) WRF_d1_bias_raw(j) WRF_d1_crmse_raw(j)] = RMSEdecomp_all(obs/Namelist{10}.rated_capasity_kw, model_raw/Namelist{10}.rated_capasity_kw);
                WRF_d1_NMAE_analogs_10(j)=mean(abs(obs-model)/Namelist{10}.rated_capasity_kw)
                
                WRF_d1_pearson_analogs_10(j)=corr(obs,model, 'Type', 'Pearson');
                WRF_d1_pearson_regresion(j)=corr(obs,model_reg, 'Type', 'Pearson');
                WRF_d1_pearson_raw(j)=corr(obs,model_raw, 'Type', 'Pearson');
                
                WRF_d1_spearman_rank_correltion_analogs_10(j)=corr(obs,model, 'Type', 'Spearman');
                WRF_d1_spearman_rank_correltion_regresion(j)=corr(obs,model_reg, 'Type', 'Spearman');
                WRF_d1_spearman_rank_correltion_raw(j)=corr(obs,model_raw, 'Type', 'Spearman');
                
            else
                [WRF_d1_rmse_analogs_10(j) WRF_d1_bias_analogs10(j) WRF_d1_crmse_10(j)] = RMSEdecomp_all(obs, model);
                WRF_d1_NMAE_10(j)=mean(abs(obs-model))
                WRF_d1_pearson_10(j)=corr(obs,model, 'Type', 'Pearson');
                WRF_d1_spearman_rank_correltion_10(j)=corr(obs,model, 'Type', 'Spearman');
            end
           else % is empty 
                WRF_d1_rmse_analogs_10(j)=mean(WRF_d1_rmse_analogs_10(find(WRF_d1_rmse_analogs_10~=0)) );
                WRF_d1_bias_analogs10(j)=mean(WRF_d1_bias_analogs_10(find(WRF_d1_bias_analogs_10~=0)) );
                WRF_d1_crmse_analogs_10(j) = mean(WRF_d1_crmse_analogs_10(find(WRF_d1_crmse_analogs_10~=0)));
                WRF_d1_NMAE_analogs_10(j)=mean(WRF_d1_NMAE_analogs_10(find(WRF_d1_NMAE_analogs_10~=0)) );
                WRF_d1_pearson_analogs_10(j)=mean(WRF_d1_pearson_analogs_10(find(WRF_d1_pearson_analogs_10~=0)));
                WRF_d1_spearman_rank_correltion_analogs_10(j)=mean(WRF_d1_spearman_rank_correltion_analogs_10(find(WRF_d1_spearman_rank_correltion_analogs_10~=0)))
                
          end % isempty
          
        for dummy=1:length(analogs_lead_times_d1)
             lead_time_match_idx(dummy)=find(analogs_lead_times_d1(dummy)==analogs_lead_times_d3)        
        end
    end
             mtx_nmae(:,1)=ETA_NMAE_analogs_10(:,analogs_lead_times_d3(lead_time_match_idx));mtx_nmae(:,:,2)=WRF_d3_NMAE_analogs_10(:,analogs_lead_times_d3(lead_time_match_idx));mtx_nmae(:,:,3)=WRF_d2_NMAE_analogs_10(:,analogs_lead_times_d2);mtx_nmae(:,:,4)=WRF_d1_NMAE_analogs_10(:,analogs_lead_times_d1);mtx_nmae(:,:,5)=WRF_d1_NMAE_regresion(:,analogs_lead_times_d1);mtx_nmae(:,:,6)=WRF_d1_NMAE_raw(:,analogs_lead_times_d1);mtx_nmae(:,:,7)=WRF_d2_NMAE_regresion(:,analogs_lead_times_d1);mtx_nmae(:,:,8)=WRF_d2_NMAE_raw(:,analogs_lead_times_d1);mtx_nmae(:,:,9)=WRF_d3_NMAE_regresion(:,analogs_lead_times_d1);mtx_nmae(:,:,10)=WRF_d3_NMAE_raw(:,analogs_lead_times_d1);mtx_nmae(:,:,11)=ETA_NMAE_regresion(:,analogs_lead_times_d1);mtx_nmae(:,:,12)=ETA_NMAE_raw(:,analogs_lead_times_d1);
             mtx_bias(:,1)=ETA_bias_analogs_10(:,analogs_lead_times_d3(lead_time_match_idx));mtx_bias(:,2)=WRF_d3_bias_analogs_10(:,analogs_lead_times_d3(lead_time_match_idx));mtx_bias(:,3)=WRF_d2_bias_analogs_10(:,analogs_lead_times_d2);mtx_bias(:,4)=WRF_d1_bias_analogs_10(:,analogs_lead_times_d1);mtx_bias(:,5)=WRF_d1_bias_regresion(:,analogs_lead_times_d1);mtx_bias(:,6)=WRF_d1_bias_raw(:,analogs_lead_times_d1)
             mtx_rmse(:,1)=ETA_rmse_analogs_10(:,analogs_lead_times_d3(lead_time_match_idx));mtx_rmse(:,2)=WRF_d3_rmse_analogs_10(:,analogs_lead_times_d3(lead_time_match_idx));mtx_rmse(:,3)=WRF_d2_rmse_analogs_10(:,analogs_lead_times_d2);mtx_rmse(:,4)=WRF_d1_rmse_analogs_10(:,analogs_lead_times_d1);mtx_rmse(:,5)=WRF_d1_rmse_regresion(:,analogs_lead_times_d1);mtx_rmse(:,6)=WRF_d1_rmse_raw(:,analogs_lead_times_d1);mtx_rmse(:,7)=WRF_d2_rmse_regresion(:,analogs_lead_times_d1);mtx_rmse(:,8)=WRF_d2_rmse_raw(:,analogs_lead_times_d1);mtx_rmse(:,9)=WRF_d3_rmse_regresion(:,analogs_lead_times_d1);mtx_rmse(:,10)=WRF_d3_rmse_raw(:,analogs_lead_times_d1);mtx_rmse(:,11)=ETA_rmse_regresion(:,analogs_lead_times_d1);mtx_rmse(:,12)=ETA_rmse_raw(:,analogs_lead_times_d1);
             mtx_rmse_2(:,1)=ETA_rmse_analogs_10(:,analogs_lead_times_d3(lead_time_match_idx));mtx_rmse(:,2)=ETA_rmse_regresion(:,analogs_lead_times_d3(lead_time_match_idx));mtx_rmse(:,3)=ETA_rmse_raw(:,analogs_lead_times_d2); ...
             mtx_rmse(:,4)=WRF_d3_rmse_analogs_10(:,analogs_lead_times_d1);mtx_rmse(:,5)=WRF_d3_rmse_regresion(:,analogs_lead_times_d1);mtx_rmse(:,6)=WRF_d3_rmse_raw(:,analogs_lead_times_d1); ...
             mtx_rmse(:,7)=WRF_d2_rmse_analogs_10(:,analogs_lead_times_d1);mtx_rmse(:,8)=WRF_d2_rmse_regresion(:,analogs_lead_times_d1);mtx_rmse(:,9)=WRF_d2_rmse_raw(:,analogs_lead_times_d1); ...
             mtx_rmse(:,10)=WRF_d1_rmse_analogs_10(:,analogs_lead_times_d1);mtx_rmse(:,11)=WRF_d1_rmse_regresion(:,analogs_lead_times_d1);mtx_rmse(:,10)=WRF_d1_rmse_raw(:,analogs_lead_times_d1); ...
             
            mtx_spearman_rank_correltion(:,1)=ETA_spearman_rank_correltion_analogs_10(:,analogs_lead_times_d3(lead_time_match_idx));mtx_spearman_rank_correltion(:,2)=ETA_spearman_rank_correltion_regresion(:,analogs_lead_times_d3(lead_time_match_idx));mtx_spearman_rank_correltion(:,3)=ETA_spearman_rank_correltion_raw(:,analogs_lead_times_d2)
            ;mtx_spearman_rank_correltion(:,4)=WRF_d3_spearman_rank_correltion_analogs_10(:,analogs_lead_times_d1);mtx_spearman_rank_correltion(:,5)=WRF_d3_spearman_rank_correltion_regresion(:,analogs_lead_times_d1);mtx_spearman_rank_correltion(:,6)=WRF_d3_spearman_rank_correltion_raw(:,analogs_lead_times_d1);
            ;mtx_spearman_rank_correltion(:,7)=WRF_d2_spearman_rank_correltion_analogs_10(:,analogs_lead_times_d1);mtx_spearman_rank_correltion(:,8)=WRF_d2_spearman_rank_correltion_regresion(:,analogs_lead_times_d1);mtx_spearman_rank_correltion(:,9)=WRF_d2_spearman_rank_correltion_raw(:,analogs_lead_times_d1);
            ;mtx_spearman_rank_correltion(:,10)=WRF_d1_spearman_rank_correltion_analogs_10(:,analogs_lead_times_d1);mtx_spearman_rank_correltion(:,11)=WRF_d1_spearman_rank_correltion_regresion(:,analogs_lead_times_d1);mtx_spearman_rank_correltion(:,12)=WRF_d1_spearman_rank_correltion_raw(:,analogs_lead_times_d1);
             
            
             mtx_crmse(:,1)= ETA_crmse_analogs_10(:,analogs_lead_times_d3(lead_time_match_idx));mtx_crmse(:,:,2)=WRF_d3_crmse_analogs_10(:,analogs_lead_times_d3(lead_time_match_idx));mtx_crmse(:,:,3)=WRF_d2_crmse_analogs_10(:,analogs_lead_times_d2);
             mtx_crmse(:,:,4)=WRF_d1_crmse_analogs_10(:,analogs_lead_times_d1);mtx_crmse(:,:,5)=WRF_d1_crmse_raw(:,analogs_lead_times_d1);mtx_crmse(:,:,6)=WRF_d1_crmse_raw(:,analogs_lead_times_d1)
            
             
             
             
             
             mtx_pearson(:,1)=ETA_pearson_analogs_10(:,analogs_lead_times_d3(lead_time_match_idx));mtx_pearson(:,2)=WRF_d3_pearson_analogs_10(:,analogs_lead_times_d3(lead_time_match_idx));mtx_pearson(:,3)=WRF_d2_pearson_analogs_10(:,analogs_lead_times_d2);mtx_pearson(:,4)=WRF_d1_pearson_analogs_10(:,analogs_lead_times_d1);mtx_pearson(:,5)=WRF_d1_pearson_regresion(:,analogs_lead_times_d1);mtx_pearson(:,6)=WRF_d1_pearson_raw(:,analogs_lead_times_d1)
             
            subplot (2,1,1)
               [m n] =size(mtx_nmae);
             for i=1:3
                plotmtx=mtx_rmse(:,i);p=plot(plotmtx,['-' Namelist{5}.markers(i) Namelist{5}.color{7+i}]);
                hold on;
               end
                grid on;ylabel('NRMS','fontsize',Namelist{7}.fontsize_sub_plot);
                xlabel('Leadtime','fontsize',Namelist{7}.fontsize_sub_plot);set(gca,'fontsize',Namelist{7}.fontsize_sub_plot,'ylim',[0.12 0.45],'xticklabel',analogs_lead_times_d3(lead_time_match_idx));
                legend({'ETA-10 analogs','ETA linear regresion','ETA raw'},'location','best')

      subplot (2,4,1:3)
               cmap=colormap('gray')
             for i=1:3
                plotmtx=mtx_rmse(:,i);p(i)=plot(plotmtx,[Namelist{5}.linespec{i+1} Namelist{5}.markers(2*i) cmap(30,:)],'linewidth',2,'markersize',12);
                hold on;
               end
                grid on;ylabel('NRMS','fontsize',Namelist{7}.fontsize_sub_plot);
                xlabel('Leadtime','fontsize',Namelist{7}.fontsize_sub_plot);set(gca,'fontsize',Namelist{7}.fontsize_sub_plot,'ylim',[0.12 0.45],'xticklabel',analogs_lead_times_d3(lead_time_match_idx));
                legend({'ETA-10 analogs','ETA linear regression','ETA raw'},'location','best')
               
            subplot (2,4,5:7)
               [m n] =size(mtx_nmae);
               for i=1:3
                plotmtx=mtx_spearman_rank_correltion(:,i);p(i)=plot(plotmtx,[Namelist{5}.linespec{i+1} Namelist{5}.markers(2*i) cmap(30,:)],'linewidth',2,'markersize',12);
                hold on;
               end
                grid on;ylabel('Spearman rank correlation','fontsize',Namelist{7}.fontsize_sub_plot);
                xlabel('Leadtime','fontsize',Namelist{7}.fontsize_sub_plot);set(gca,'fontsize',Namelist{7}.fontsize_sub_plot,'ylim',[0.55 0.85],'xticklabel',analogs_lead_times_d3(lead_time_match_idx));
                legend({'ETA-10 analogs','ETA linear regression','ETA raw'},'location','best')
               
                
                
     
%       maximize
        save_dir=[Namelist{1}.stat_plot_dir,'\accuracy_nwp_turbine_concanated_on_leadtimes_paper']
        plot_filename=['\ETA_stats_on_nr_10_analogs']
                if isdir(save_dir)
                   saveas(gcf,[save_dir plot_filename] ,'fig')
                   saveas(gcf,[save_dir plot_filename] ,'jpeg')

                else
                    mkdir(save_dir)
                    saveas(gcf,[save_dir plot_filename] ,'fig')
                    saveas(gcf,[save_dir plot_filename] ,'jpeg')

                end
end % turbine Counter




