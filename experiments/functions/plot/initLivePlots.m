function vr = initLivePlots(vr)
    vr.exper_name = vr.exper.name; % get experiment name
    % initialize settings for plotting online behavioral metrics
    screenSize = get(0,'ScreenSize'); 
    fig_width = 700; 
    fig_height = 400;
    vr.livePlotFig = figure('color','white',...
    'position',[screenSize(3) - fig_width,screenSize(4) - fig_height - 80,fig_width,fig_height]);

    % plot settings
    vr.livePlot_opt = struct; 
    vr.livePlot_opt.minLickV = 1; % min value for lick detection
    vr.livePlot_opt.lickV = 0.5; % voltage for lick detection
    vr.livePlot_opt.worldColors = lines(vr.nWorlds); % trial type colors for lick raster
    vr.livePlot_opt.initRasterMaxTrials = 50; 
    vr.livePlot_opt.n_save_trials = 10;
    vr.livePlot_opt.color_gradient_order = ["Blues" "Reds" "Greys" "YlOrBr"];
    
    % initialize data for plots 
    vr.trial_world_lickY = []; 
    vr.trial_world_ITIlickT = []; 
    if strcmp(vr.exper_name,'dynSwitching_CYJS')
        vr.live_saved_xy = cell(4,1);
    elseif strcmp(vr.exper_name,'linearTrack_RectangeMiddle_CYJS')
        vr.live_saved_xy = cell(vr.nWorlds,1); 
    end
    
    % initialize plots
    subplot(2,2,1);hold on
    xlabel("Time (seconds)")
    ylabel("Lick Signal (V)")

    subplot(8,8,[33:35 41:43 49:51 57:59]);hold on 
    xlabel("Position (cm)") 
    ylabel("Trial #")
    ylim([0,vr.livePlot_opt.initRasterMaxTrials])
    set(gca, 'YDir','reverse')
    subplot(8,8,[36 44 52 60]);hold on
    xlabel("Time in ITI (sec)") 
    ylabel("Trial #")
    ylim([0,vr.livePlot_opt.initRasterMaxTrials]) 
    if strcmp(vr.exper_name,'dynSwitching_CYJS')
        xlim([0,vr.rewardDelay + max(vr.itiCorrect,vr.itiMissBase)]) 
    elseif strcmp(vr.exper_name,'linearTrack_RectangeMiddle_CYJS')
        xlim([0,vr.rewardDelay + max(vr.itiCorrect,vr.itiMiss)]) 
    end
    set(gca, 'YDir','reverse')
    
    % Running trajectory plot
    if strcmp(vr.exper_name,'dynSwitching_CYJS')
        subplot(2,2,2); hold on % non-visually guided
        ylim([0 vr.rewardLength])
        xlim([-vr.funnelWidth/2 vr.funnelWidth/2])
        xlabel("X Position (cm)")
        ylabel("Y Position (cm)")
        draw_Ymaze(vr)
        
        subplot(2,2,4); hold on % visually-guided 
        ylim([0 vr.rewardLength])
        xlim([-vr.funnelWidth/2 vr.funnelWidth/2])
        xlabel("X Position (cm)")
        ylabel("Y Position (cm)")
        draw_Ymaze(vr)
        
    elseif strcmp(vr.exper_name,'linearTrack_RectangeMiddle_CYJS')
        subplot(2,2,[2 4]); hold on
        ylim([0 vr.floorLength])
        xlim([-vr.floorWidth/2 vr.floorWidth/2])
        xlabel("X Position (cm)")
        ylabel("Y Position (cm)")
    end
end

 