function vr = init_lickPlot(vr)
%INIT_LICKPLOT 
screenSize = get(0,'ScreenSize'); 
    fig_width = 400; 
    fig_height = 250;
    vr.lickFig = figure('color','white',...
    'position',[screenSize(3) - fig_width,screenSize(4) - fig_height - 80,fig_width,fig_height]);
    
end

