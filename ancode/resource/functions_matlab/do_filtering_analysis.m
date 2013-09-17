function [ succes ] = do_filtering_analysis( Namelist )
%DO_FILTERING_ANALYSIS Summary of this function goes here
%   Detailed explanation goes here
%load all analogs
%all non filtered analogs
load([Namelist{1}.workspace_data_dir '\Analog_nr_experiment_05_10_15_20_25'])
% filtered 20 analogs
load([Namelist{1}.workspace_data_dir '\analog_nr_20_filtered'])
load([Namelist{1}.workspace_data_dir '\analog_nr_20_filtered_and_banned'])
load([Namelist{1}.workspace_data_dir '\analog_nr_20_light_filtered_and_banned'])

% filtered 15 analogs
load([Namelist{1}.workspace_data_dir '\analog_nr_15_filtered'])
load([Namelist{1}.workspace_data_dir '\analog_nr_15_filtered_and_banned'])
load([Namelist{1}.workspace_data_dir '\analog_nr_15_light_filtered_and_banned'])

load([Namelist{1}.workspace_data_dir '\analog_nr_10_filtered'])
load([Namelist{1}.workspace_data_dir '\analog_nr_10_filtered_and_banned'])
load([Namelist{1}.workspace_data_dir '\analog_nr_10_light_filtered_and_banned'])


%find indx for same dates in non filtered and filtered time series 
[c, ia, ib] = intersect(time_serie_power_forecast_15_analogs{2,1},time_serie_power_forecast_15_analogs_filtered{2,1},'rows' );
% first unfiltered 
obs=time_serie_power_forecast_15_analogs{2,15}(ia)/Namelist{10}.name_plate_capasity_kw;
model_ANALOG_10=time_serie_power_forecast_10_analogs{2,2}(ia)/Namelist{10}.name_plate_capasity_kw
model_ANALOG_10_filtered=time_serie_power_forecast_10_analogs_filtered{2,2}(ib)/Namelist{10}.name_plate_capasity_kw
model_ANALOG_10_filtered_and_banned=time_serie_power_forecast_10_analogs_filtered_and_banned_and_ba{2,2}(ib)/Namelist{10}.name_plate_capasity_kw
model_ANALOG_10_light_filtered_and_banned=time_serie_power_forecast_10_analogs_light_filtered_and_banned{2,2}(ib)/Namelist{10}.name_plate_capasity_kw

model_ANALOG_15=time_serie_power_forecast_15_analogs{2,2}(ia)/Namelist{10}.name_plate_capasity_kw
model_ANALOG_15_filtered=time_serie_power_forecast_15_analogs_filtered{2,2}(ib)/Namelist{10}.name_plate_capasity_kw
model_ANALOG_15_filtered_and_banned=time_serie_power_forecast_15_analogs_filtered_and_banned{2,2}(ib)/Namelist{10}.name_plate_capasity_kw
model_ANALOG_15_light_filtered_and_banned=time_serie_power_forecast_15_analogs_light_filtered_and_banned{2,2}(ib)/Namelist{10}.name_plate_capasity_kw

model_ANALOG_20=time_serie_power_forecast_20_analogs{2,2}(ia)/Namelist{10}.name_plate_capasity_kw
model_ANALOG_20_filtered=time_serie_power_forecast_20_analogs_filtered{2,2}(ib)/Namelist{10}.name_plate_capasity_kw
model_ANALOG_20_filtered_and_banned=time_serie_power_forecast_20_analogs_filtered_and_banded{2,2}(ib)/Namelist{10}.name_plate_capasity_kw
model_ANALOG_20_light_filtered_and_banned=time_serie_power_forecast_20_analogs_light_filtered_and_banned{2,2}(ib)/Namelist{10}.name_plate_capasity_kw

%test to see if things are right and they are :)

plot(obs,'black');hold on
plot(model_ANALOG_10,'b');hold on 
plot(model_ANALOG_10_filtered,':r'); hold on
plot(model_ANALOG_10_filtered_and_banned,':y');hold on
plot(model_ANALOG_10_light_filtered_and_banned,':g')

            [rmse_10 bias_10 crmse_10] = RMSEdecomp_all(obs, model_ANALOG_10)
            [rmse_10_filtered bias_10_filtered crmse_10_filtered] = RMSEdecomp_all(obs, model_ANALOG_10_filtered)
            [rmse_10_filtered_and_banned bias_10_filtered_and_banned crmse_10_filtered_and_banned] = RMSEdecomp_all(obs, model_ANALOG_10_filtered_and_banned)
            [rmse_10_light_filtered_and_banned bias_10_light_filtered_and_banned crmse_10_light_filtered_and_banned] = RMSEdecomp_all(obs, model_ANALOG_10_light_filtered_and_banned)
            
            [rmse_15 bias_15 crmse_15] = RMSEdecomp_all(obs, model_ANALOG_15)
            [rmse_15_filtered bias_15_filtered crmse_15_filtered] = RMSEdecomp_all(obs, model_ANALOG_15_filtered)
            [rmse_15_filtered_and_banned bias_15_filtered_and_banned crmse_15_filtered_and_banned] = RMSEdecomp_all(obs, model_ANALOG_15_filtered_and_banned)
            [rmse_15_light_filtered_and_banned bias_15_light_filtered_and_banned crmse_15_light_filtered_and_banned] = RMSEdecomp_all(obs, model_ANALOG_15_light_filtered_and_banned)
            
            [rmse_20 bias_20 crmse_20] = RMSEdecomp_all(obs, model_ANALOG_20)
            [rmse_20_filtered bias_20_filtered crmse_20_filtered] = RMSEdecomp_all(obs, model_ANALOG_20_filtered)
            [rmse_20_filtered_and_banned bias_20_filtered_and_banned crmse_20_filtered_and_banned] = RMSEdecomp_all(obs, model_ANALOG_20_filtered_and_banned)
            [rmse_20_light_filtered_and_banned bias_20_light_filtered_and_banned crmse_20_light_filtered_and_banned] = RMSEdecomp_all(obs, model_ANALOG_20_light_filtered_and_banned)
 figure  
 subplot(3,1,1)
     rmse_histo_plot_mtx(1,:)=[rmse_10 rmse_10_filtered rmse_10_filtered_and_banned rmse_10_light_filtered_and_banned]
     rmse_histo_plot_mtx(2,:)=[rmse_15 rmse_15_filtered rmse_15_filtered_and_banned rmse_15_light_filtered_and_banned]
     rmse_histo_plot_mtx(3,:)=[rmse_20 rmse_20_filtered rmse_20_filtered_and_banned rmse_20_light_filtered_and_banned]
     bar(rmse_histo_plot_mtx,'group');grid on;
     set(gca,'fontsize',Namelist{7}.fontsize,'xticklabel',{'10 analogs','15 analogs','20 analogs'});
     ylim([0 .4]);ylabel('Normalized RMSE','fontsize',Namelist{7}.fontsize);title('ETA based powerforecast for Sprog� offshore wind farm Sep-Dec 2010','fontsize',Namelist{7}.fontsize+2 )
     colormap('gray')
   subplot(3,1,2)  
     bias_histo_plot_mtx(1,:)=[bias_10 bias_10_filtered bias_10_filtered_and_banned bias_10_light_filtered_and_banned]
     bias_histo_plot_mtx(2,:)=[bias_15 bias_15_filtered bias_15_filtered_and_banned bias_15_light_filtered_and_banned]
     bias_histo_plot_mtx(3,:)=[bias_20 bias_20_filtered bias_20_filtered_and_banned bias_20_light_filtered_and_banned]
     bar(bias_histo_plot_mtx,'group');grid on;
     set(gca,'fontsize',Namelist{7}.fontsize,'xticklabel',{'10 analogs','15 analogs','20 analogs'});
     ylim([-.01 .01]);ylabel('Normalized bias','fontsize',Namelist{7}.fontsize);legend({'No filter','heavy filter','heavy filtering and banned','light filtering and banned'},'location','north')
     colormap('gray')
subplot(3,1,3)  
     crmse_histo_plot_mtx(1,:)=[crmse_10 crmse_10_filtered crmse_10_filtered_and_banned crmse_10_light_filtered_and_banned]
     crmse_histo_plot_mtx(2,:)=[crmse_15 crmse_15_filtered crmse_15_filtered_and_banned crmse_15_light_filtered_and_banned]
     crmse_histo_plot_mtx(3,:)=[crmse_20 crmse_20_filtered crmse_20_filtered_and_banned crmse_20_light_filtered_and_banned]
     bar(crmse_histo_plot_mtx,'group');grid on;
     set(gca,'fontsize',Namelist{7}.fontsize,'xticklabel',{'10 analogs','15 analogs','20 analogs'});
     ylim([0 .4]);ylabel('Normalized CRMSE','fontsize',Namelist{7}.fontsize);
     colormap('gray')
end

