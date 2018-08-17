clear; close all; clc;
addpath('data', 'functions')
tic;
res = read_nrn_output('data/trn_aud_official.dat');
toc
ntrials = res.ntrials;
nconds = res.nconds;
tstart = res.const_set('tstart');
tstop = res.const_set('tstop');
conds_keys = res.condition_list.keys;
conds_vals = res.condition_list.values;
find_keys = @(target) conds_keys(cellfun(@(x) x.index == target, conds_vals));

% choosing which I->TRN to plot
conds2plt = [1,2,3,6];

% print out param_set if needed 
% [res.param_set.keys;res.param_set.values]'
% [res.const_set.keys;res.const_set.values]'

%% Load position
load('plotpos_mod4maria.mat');
figure; set(gcf, 'Units', 'inches', 'PaperPosition',[0.01,0.01,8.30, 11.70]);

x_lim = [150, 550];
clrs = {'r', 'b', [0.1,0.7,0.2]}; % cell colors
cell_names = {'TRN', 'MGB', 'A1'};
cond_names = {'Off', 'Low', 'Medium', 'High'} ;
light_clr = [190, 231, 250]/255;
light_alp = 1;
tone_clr =  [209, 210, 212]/255;
tone_alp = 0.8;


cmap = [0, 0, 0;
    245, 125, 239;
    145,8,204;
    0, 51, 153;];

cmap = cmap/255;

%% B_a
subplot('Position', Mod4Maria_Pos('B_a')); hold on;
factor = [0,0.60,0.75, 1];

for i = 1 : 4
    line_style = {'.-','Color', 'k', 'LineWidth', 1.5, 'MarkerSize', 3};
    base_height = ones(1,2)*(20-i*4);
    inpt_height = ones(1,2)*(20-i*4 + i*0.5*factor(i));
    plot([0,0.5],base_height,line_style{:});
    plot([0.5,3.5],inpt_height,line_style{:});
    plot([3.5,4],base_height,line_style{:});
    if i>1
        plot([0.5,0.5],[(20-i*4), (20-i*4 + i*0.5*factor(i))],line_style{:});
        plot([3.5,3.5],[(20-i*4), (20-i*4 + i*0.5*factor(i))],line_style{:});
    end
    text(0.5, inpt_height(1)+0.8, cond_names{i}, 'Color', cmap(i,:), 'FontSize', 10);
end
text(0, 18, {'BLA input to TRN'});
set(gca, 'xcolor', 'none', 'ycolor', 'none')
ylim([3.8, 18])


%% B_b
pos_ = Mod4Maria_Pos('B_b');
nsim2plt = 2;
sim2plt =  [1, 39, 49; 
            1, 32, 47; 
            1, 24, 33; 
            1, 5, 43]; 
for j = 1:size(sim2plt,2)
    for i = 1 : length(conds2plt)
        subplot('Position', pos_{i,j});  hold on;
        if conds2plt(i) ~= 1
            patch(tstart+100+[0,0,250,250],[0,-300,-300,0], light_clr, 'EdgeColor', 'none',...
                'FaceAlpha', light_alp, 'DisplayName', 'Light');
        end
        patch(tstart+200+[0,0,50,50],[0,-300,-300,0], tone_clr,'EdgeColor', 'none', ...
            'FaceAlpha', tone_alp, 'DisplayName', 'Tone');
        dat_ = res.data{conds2plt(i),sim2plt(i,j)};
        t = dat_(:,1);
        for k = 2:size(dat_,2)
            plot(t, dat_(:,k)/2 - 45*k, 'Color', clrs{k-1}, 'LineWidth', 0.5)
        end
        xlim(x_lim);
        ylim([-230, -40]);
        set(gca, 'xtick', '', 'ytick', '', 'visible', 'off')
        if i==length(conds2plt) && j==1
            plot([500, 550]-10, [-110, -110], '-k', 'LineWidth', 0.75);
            plot([550, 550]-10, [-110, -70], '-k', 'LineWidth', 0.75);
        end
    end
end

%% C_a

subplot('Position', Mod4Maria_Pos('C_a')); hold on;
factor = [0,0.60,0.75, 1];
for i = 1 : 4
    line_style = {'.-','Color', 'k', 'LineWidth', 1.5, 'MarkerSize', 3};
    base_height = ones(1,2)*(20-i*4);
    inpt_height = ones(1,2)*(20-i*4 + i*0.5*factor(i));
    plot([0,0.5],base_height,line_style{:});
    plot([0.5,3.5],inpt_height,line_style{:});
    plot([3.5,4],base_height,line_style{:});
    if i>1
        plot([0.5,0.5],[(20-i*4), (20-i*4 + i*0.5*factor(i))],line_style{:});
        plot([3.5,3.5],[(20-i*4), (20-i*4 + i*0.5*factor(i))],line_style{:});
    end
    text(0.5, inpt_height(1)+0.8, cond_names{i}, 'Color', cmap(i,:), 'FontSize', 10);
end
set(gca, 'xcolor', 'none', 'ycolor', 'none')
ylim([3.8, 18])

%% C_b
pos_ = Mod4Maria_Pos('C_b');
ann_pos_ = Mod4Maria_Pos('C_b_ann');
cnt_splt_ = 1;
ntrials2plt = 25;
trials2plt = datasample(2:ntrials,ntrials2plt,'Replace',false);
for k = 1 : 3
    for i = 1 : length(conds2plt)
        subplot('Position', pos_{i,k}); hold on;
        if conds2plt(i) > 1
            patch(tstart+100+[0,0,250,250],[-1,1,1,-1]*200, light_clr, 'EdgeColor', 'none',...
                'FaceAlpha', light_alp, 'DisplayName', 'Light');
        end
        patch(tstart+200+[0,0,50,50],[-1,1,1,-1]*200, tone_clr,'EdgeColor', 'none', ...
            'FaceAlpha', tone_alp, 'DisplayName', 'Tone');
        for j = 1 : ntrials2plt
            locs = res.spike_timings{k,conds2plt(i),trials2plt(j)};
            if ~isempty(locs)
                scatter(locs, j*ones(size(locs)), 1, 'filled', 'MarkerFaceColor', clrs{k});
                xlim(x_lim);
                ylim([-1, ntrials2plt+5]);
            end
        end
        set(gca, 'xtick', '', 'ytick', '', 'visible', 'off')
    end
    
end

%% D
pos_ = Mod4Maria_Pos('D');
edge_lim = [-10, tstop + 10];
nbins = edge_lim(2) - edge_lim(1) ;
smw = round(nbins/20);
ylim_min = 0;
for k = 1 : 3
    lgnds_ = cell(1,nconds);
    subplot('Position', pos_{k}); hold on;
    patch(tstart+100+[0,0,250,250],[ylim_min,100,100,ylim_min],  light_clr, 'EdgeColor', 'none', 'FaceAlpha', light_alp);
    patch(tstart+200+[0,0,50,50],[ylim_min,100,100,ylim_min], tone_clr,'EdgeColor', 'none', 'FaceAlpha', tone_alp);
    
    base_line = [];
    control_ = [];
    for i = 1 : length(conds2plt)
        [ptsh_, cent_] = return_histogram([res.spike_timings{k,conds2plt(i),2:end}], ntrials-1, nbins, edge_lim, smw);
        if conds2plt(i) == 1
            control_ = max(ptsh_);
        end
        ptsh_ = ptsh_/control_;
        plot(cent_, ptsh_, 'Color',cmap(i,:), 'LineWidth', 1.5);
        base_line = [base_line, mean(ptsh_(cent_>tstart & cent_<tstart+100))];
    end
    base_line = mean(base_line);
    plot([0, tstop], [base_line, base_line], '--k');
    xlim(x_lim);
    text(160, 0.7, cell_names{k}, 'FontSize', 20)
    if k ~= 3
        set(gca, 'xtick', '', 'xcolor', 'none');
    end
    if k==1
        ylim([-0.03, 1.3]);
    else
        ylim([-0.03, 1.1]);
    end
    ylabel('Rate (norm)'); 
end
xlabel('Time (ms)');

%% Calculate spont
clrfact = 3;
ISI = cell(3,1);
for k = 1 : 3
    for i = 1 : nconds
        for j = 2 : ntrials
            locs = res.spike_timings{k,i,j};
            isi = [diff(locs(locs > 100 & locs < 200)), diff(locs(locs > 450))];
            ISI{k} = [ISI{k}, isi];
        end
    end
    mean(ISI{k})
end


%% E
pos_ = Mod4Maria_Pos('E');
nbins = 620;
edge_lim = [-10, tstop + 10];
smw = round(nbins/20);
nconds = length(conds2plt);
pl_ = [];

lgnds_ = cell(1,nconds);
peaks_ = zeros(nconds,3);
ampls_ = zeros(nconds,3);
recov_ = zeros(nconds,3);
for k = 2:3
    for i = 1 : nconds % assuming that 'i' proportional to lvl
        [ptsh_, cent_] = return_histogram([res.spike_timings{k,conds2plt(i),2:end}], ntrials-1, nbins, edge_lim, smw);
        lgnds_(i) = find_keys(i);
        lgnds_{i} = lgnds_{i}(7:end);
        base_i_0 = min(ptsh_(cent_>100 & cent_<200));
        base_i_1 = min(ptsh_(cent_>250 & cent_<300));
        peak_i = max(ptsh_(cent_>300 & cent_<350));
        recv_i = mean(ptsh_(cent_>350 & cent_<450));
        peaks_(i,k) = peak_i;
        ampls_(i,k) = peak_i-base_i_1;
        recov_(i,k) = recv_i - base_i_0;
    end
    peaks_(:,k) = peaks_(:,k)/peaks_(1,k);
    ampls_(:,k) = ampls_(:,k)/ampls_(1,k);
end
subplot('Position', pos_{1}); hold on;
b__ = bar(peaks_(:,2:3), 'EdgeColor', 'none'); b__(1).FaceColor = clrs{2};b__(2).FaceColor = clrs{3};
set(gca, 'xtick', '' , 'xcolor', 'none')
plot(0:nconds+1, ones(1,nconds+2), '--k'); xlim([0.5,nconds+0.5])
ylabel({'Max Rate',' (norm)'})
ylim([0, 1.25]);
subplot('Position', pos_{2}); hold on;
b__ = bar(ampls_(:,2:3), 'EdgeColor', 'none'); b__(1).FaceColor = clrs{2};b__(2).FaceColor = clrs{3};
set(gca, 'xtick', 1:nconds, 'XTickLabel', cond_names, 'TickLabelInterpreter', 'none',...
    'FontSize', 10);
plot(0:nconds+1, ones(1,nconds+2), '--k'); xlim([0.5,nconds+0.5])
ylabel({'Peak to peak', ' response (norm)'})
ylim([0, 1.25]);
xlabel('BLA input to TRN'); 
legend(cell_names(2:3), 'FontSize', 12, 'Box', 'off')
