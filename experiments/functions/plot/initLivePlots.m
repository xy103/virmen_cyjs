function vr = initLivePlots(vr)
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
    vr.livePlot_opt.worldColors = lines(2); % trial type colors for lick raster
    vr.livePlot_opt.initRasterMaxTrials = 50; 
    
    % initialize data for plots 
    vr.trial_world_lickY = []; 
    vr.saved_x = []; 
    vr.saved_y = {}; 
    
    % initialize plots
    subplot(2,2,1);hold on
    xlabel("Time (seconds)")
    ylabel("Lick Signal (V)")

    subplot(2,2,3);hold on 
    xlabel("Position (cm)") 
    ylabel("Trial #")
    ylim([0,vr.livePlot_opt.initRasterMaxTrials])
    set(gca, 'YDir','reverse')
    title("Lick Raster Plot")
    
    subplot(2,2,[2 4]); hold on
    xlabel("X Position (cm)")
    ylabel("Y Position (cm)")
    xlim([-vr.floorWidth/2 vr.floorWidth/2])
    ylim([0 vr.floorLength])
end

 