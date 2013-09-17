function [ succes ] =  do_single_prob_stat(prob_time_serie_power_forecast_filtered,prob_time_serie_power_forecast_unfiltered);
dav=1
nr_bins=25;
%bin spread
%                                                       %obs
%                                                                                      % ensemble mean
font_size=12
x_lim=[0 8000]
y_lim=[0 8000]
y_labels=[0:2000:max(y_lim)]

prob_time_serie_power_forecast_filtered{2,15}
Ensemble_mean_obs_RMS_filtered=RMSEdecomp_all(prob_time_serie_power_forecast_filtered{2,15},prob_time_serie_power_forecast_filtered{2,13})
[sorted_ensemble_std_filtered idx]=sort(prob_time_serie_power_forecast_filtered{2,12});
sorted_obs_filtered=prob_time_serie_power_forecast_filtered{2,15}(idx);
sorted_EM_filtered=prob_time_serie_power_forecast_filtered{2,13}(idx);      

good_idx=find(~isnan(prob_time_serie_power_forecast_unfiltered{2,15}));

Ensemble_mean_obs_RMS_unfiltered=RMSEdecomp_all(prob_time_serie_power_forecast_unfiltered{2,15},prob_time_serie_power_forecast_unfiltered{2,13})
[sorted_ensemble_std_unfiltered idx]=sort(prob_time_serie_power_forecast_unfiltered{2,12});
sorted_obs_unfiltered=prob_time_serie_power_forecast_unfiltered{2,15}(idx);
sorted_EM_unfiltered=prob_time_serie_power_forecast_unfiltered{2,13}(idx);      

    for i=1:nr_bins
        jump=round(length(idx)/nr_bins);
        interval=[(i*jump)-(jump-1):1:(i*jump)];
        bin.rms_error_filtered(i)=RMSEdecomp_all(sorted_obs_filtered(interval),sorted_EM_filtered(interval))
        bin.spread_filtered(i)=mean(sorted_ensemble_std_filtered(interval))
    end 

    for i=1:nr_bins-1
        jump=round(length(sorted_obs_unfiltered)/nr_bins);
        interval=[(i*jump)-(jump-1):1:(i*jump)];
        bin.rms_error_unfiltered(i)=RMSEdecomp_all(sorted_obs_unfiltered(interval),sorted_EM_unfiltered(interval))
        bin.spread_unfiltered(i)=mean(sorted_ensemble_std_unfiltered(interval))
    end 
    scatter(bin.spread_filtered,bin.rms_error_filtered,90,'Marker','o','MarkerFaceColor','b','MarkerEdgeColor','r')
    hold on
    scatter(bin.spread_unfiltered,bin.rms_error_unfiltered,90,'Marker','o','MarkerFaceColor','w','MarkerEdgeColor','r')
    x=1:jump:9000;y=1:jump:9000
    plot(x,y,':k','LineWidth',4)%,...     
                %'MarkerEdgeColor','b',...
                %'MarkerFaceColor','r',...
                %'MarkerSize',10)
    grid on;xlabel('Ensemble spread (KW)','fontsize',font_size,'FontWeight','bold');grid on;ylabel('Ensemble Mean RMSE (KW)','fontsize',font_size','FontWeight','bold');
    set(gca,'fontsize',font_size,'FontWeight','bold','xlim',x_lim,'ylim',y_lim,'ytick',y_labels)     
    legend({'Spread - RMSE light Filtered bnned ','Spread - RMSE Unfiltered','Perfect Reliability'},'location','NorthWest');title('10 member AnEn','fontsize',font_size)
    axis square
    colormap('gray')

    
     
end % function 