function plotMeanSEM(xpos,mean_val, sem_val,col_touse)
% patch sem around mean
if nargin <4
    col_touse = colororder;
    col_touse = col_touse(1,:);
end

if sum(isnan(mean_val))>0 
    xpos(isnan(mean_val))=[];
    sem_val(isnan(mean_val))=[];
    mean_val(isnan(mean_val))=[];
end

above = mean_val + sem_val;
below = mean_val - sem_val;
hold on 
plot(xpos,mean_val,'Color',col_touse)
x = [xpos, fliplr(xpos)];
inBetween = [above, fliplr(below)];
patch(x, inBetween, col_touse,'FaceAlpha',.5,'EdgeColor','none');
end
