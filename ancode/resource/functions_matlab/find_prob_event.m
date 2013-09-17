function [ prob ] =find_prob_event(model_ensembles,event_treshold);
%FIND_PROB_EVENT Summary of this function goes here
%   Detailed explanation goes here
    pcntile=[0:1:100];
    pcntile_values=prctile(model_ensembles,pcntile);
    prob=length(find(pcntile_values<event_treshold))/(length(pcntile))
end

