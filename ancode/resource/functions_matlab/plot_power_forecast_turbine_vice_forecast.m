function [ Succes ] = plot_power_forecast_turbine_vice_forecast(time_serie_power_forecast,power_obs_vector,Namelist)
%PLOT_POWER_FORECAST Summary of this function goes here
%   Detailed explanation goes here
close all
[m n]=size(time_serie_power_forecast);
[dummy nr_data_points]=size(power_obs_vector(1,1).power_obs);
for turbine_counter=1:n
    subplot(floor((n+1)/2),2,turbine_counter)
 % plot deterministic forecast turbine i
 plot(time_serie_power_forecast(1,turbine_counter).data{2,2}/Namelist{10}.rated_capasity_kw,'--r*','LineWidth',2,...
                'MarkerEdgeColor','r',...
                'MarkerFaceColor','r',...
                'MarkerSize',10)
hold on 
if Namelist{10}.do_regression
plot(time_serie_power_forecast(1,turbine_counter).data{2,19}/Namelist{10}.rated_capasity_kw,':black*','LineWidth',1,...
                'MarkerEdgeColor','g',...
                'MarkerFaceColor','g',...
                'MarkerSize',10)
end
        
        % plot the bands 
        x=[1:length(time_serie_power_forecast(1,turbine_counter).data{2,7})]
        for i=1:Namelist{5}.number_ci_plots % upper bands first 
            h(i)=ciplot(time_serie_power_forecast(1,turbine_counter).data{2,7+i-1}/Namelist{10}.rated_capasity_kw,x,[0.2989 + 0.5870  + 0.1140],0.75/i)
            hold on
            h_lower(i)=ciplot(time_serie_power_forecast(1,turbine_counter).data{2,7-i+1}(length(time_serie_power_forecast(1,turbine_counter).data{2,2})-(24/Namelist{5}.Analog.lead_delta):length(time_serie_power_forecast(1,turbine_counter).data{2,2}))/Namelist{10}.rated_capasity_kw,time_serie_power_forecast(1,turbine_counter).data{2,7-i}(length(time_serie_power_forecast(1,turbine_counter).data{2,2})-(24/Namelist{5}.Analog.lead_delta):length(time_serie_power_forecast(1,turbine_counter).data{2,2}))/Namelist{10}.rated_capasity_kw,x,[0.2989 + 0.5870  + 0.1140],0.75/i)
            %hold on
        end
            
            set(h(3),'LineStyle','none');set(h_lower(3),'LineStyle','none')
            set(h(2),'LineStyle','none');set(h_lower(2),'LineStyle','none')
            set(h(1),'LineStyle','none');set(h_lower(1),'LineStyle','none')
            
            set(h(3),'Facealpha',0.4,'LineStyle','none');set(h_lower(3),'Facealpha',0.4,'LineStyle','none')
            set(h(2),'Facealpha',0.6,'LineStyle','none');set(h_lower(2),'Facealpha',0.6,'LineStyle','none')
            set(h(1),'Facealpha',0.8,'LineStyle','none');set(h_lower(1),'Facealpha',0.8,'LineStyle','none')
            colormap('gray')

%            legend({,'Deterministic forecast','obs','50-60% percentile','40-50% percentile','60-70% percentile','30-40% percentile','70-80% percentile','20-30% percentile'})
            set(gca,'xlim',[0 nr_data_points],'ylim',[0 1]); grid on; colormap('gray')
            % label stuff
            date_labels=power_obs_vector(1,turbine_counter).valid_date(:,11:16)
            set(gca,'xtick',[1:3:nr_data_points],'xticklabels',date_labels([1:3:(24/Namelist{5}.Analog.lead_delta)],:),'fontsize',Namelist{7}.fontsize_sub_plot-1)
            if turbine_counter==1
            title('Flow dependent percentiles from Analog Ensemble approch','fontsize',Namelist{7}.fontsize_sub_plot-1)
            end
            if turbine_counter==3
                ylabel('Normalized power (nameplate capacity)','fontsize',Namelist{7}.fontsize_sub_plot);
            end
            if turbine_counter==n
                xlabel(strcat('Valid for:',' ',power_obs_vector(1,turbine_counter).valid_date(1,1:10)),'fontsize',Namelist{7}.fontsize_sub_plot);
            else
                xlabel(strcat('Valid for:',' ',num2str(power_obs_vector(1,turbine_counter).turbineid(1))),'fontsize',Namelist{7}.fontsize_sub_plot);
            end
                   
end
            if strcmp(computer('arch'),'win32') 
                maximize 
            end
            %Save plots
            if not(isdir(Namelist{1}.plots_forecast_dir_turbine_vice))
                mkdir([Namelist{1}.plots_forecast_dir_turbine_vice])
                save_file=[Namelist{1}.plots_forecast_dir_turbine_vice,'Pro_forecast_valid_',power_obs_vector(1,turbine_counter).valid_date(1,1:10),'_',num2str(Namelist{5}.Analog.number_of_analogs_search_for),'_analogs']
            else
                save_file=[Namelist{1}.plots_forecast_dir_turbine_vice,'\','Pro_forecast_valid_',power_obs_vector(1,turbine_counter).valid_date(1,1:10),'_',num2str(Namelist{5}.Analog.number_of_analogs_search_for),'_analogs']
            end 
        
            %print(gcf, '-dmeta', filename);
            print(gcf, '-dpng', save_file);


% plot all 
figure;label_counter=0;
            for turbine_counter_2=1:n
                plot(time_serie_power_forecast(1,turbine_counter_2).data{2,2}(length(time_serie_power_forecast(1,turbine_counter_2).data{2,2})-(24/Namelist{5}.Analog.lead_delta):length(time_serie_power_forecast(1,turbine_counter_2).data{2,2}))/Namelist{10}.rated_capasity_kw,strcat('-r',Namelist{5}.markers(turbine_counter_2)),'LineWidth',1,...
                'MarkerEdgeColor','r',...
                'MarkerFaceColor','r',...
                'MarkerSize',10)
            label_counter=label_counter+1;
            label_str{label_counter}=['P-fct:',num2str(power_obs_vector(1,turbine_counter_2).turbineid(1))]
            hold on
            idx=find(power_obs_vector(1,turbine_counter_2).power_obs~=Namelist{1}.missing_value)
            plot(idx,power_obs_vector(1,turbine_counter_2).power_obs(idx)/Namelist{10}.rated_capasity_kw,strcat('b',Namelist{5}.markers(turbine_counter_2)),'LineWidth',1,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','k',...
                'MarkerSize',10)
            hold on 
            label_counter=label_counter+1;
            label_str{label_counter}=['P-obs:',num2str(power_obs_vector(1,turbine_counter_2).turbineid(1))]
            
            end
              if strcmp(computer('arch'),'win32') 
                  maximize 
              end
               set(gca,'xlim',[1 nr_data_points],'ylim',[0 1]); grid on; colormap('gray')
                legend(label_str,'location','northoutside','orientation','horizontal')           
                date_labels=power_obs_vector(1,turbine_counter).valid_date(:,11:16)
                set(gca,'xtick',[1:3:nr_data_points],'xticklabels',date_labels([1:3:(24/Namelist{5}.Analog.lead_delta)],:),'fontsize',Namelist{7}.fontsize_sub_plot)
                xlabel(strcat(Namelist{4}.nwp_model{1},' Valid for:',' ',power_obs_vector(1,turbine_counter).valid_date(1,1:10)),'fontsize',Namelist{7}.fontsize);
            %Save plots
            filename=strcat([Namelist{1}.plots_forecast_dir_turbine_vice,'\'],'Pro_forecast_valid_',power_obs_vector(1,turbine_counter_2).valid_date(1,1:10),'Turbine_by_turbine-',num2str(Namelist{5}.Analog.number_of_analogs_search_for),'analogs');
            mkdir(Namelist{1}.plots_forecast_dir_turbine_vice);
            %print(gcf, '-dmeta', filename);
            print(gcf, '-dpng', filename);
            Succes='True';
