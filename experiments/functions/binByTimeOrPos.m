function [mean_binned_a,sem_binned_a] = binByTimeOrPos(x,a,bin_edges)
% x is position or time 
% a is array that we want to bin

n_bins = length(bin_edges)-1;
binned_x = zeros(size(x));
mean_binned_a = zeros([1,n_bins]);
sem_binned_a = zeros([1,n_bins]);

for this_bin = 1:n_bins
    left_edge = bin_edges(this_bin);
    right_edge = bin_edges(this_bin+1);
    binned_x((x>=left_edge) & (x<right_edge)) = this_bin; 
    temp_a = a((x>=left_edge) & (x<right_edge));
    mean_binned_a(this_bin) = mean(temp_a);
    sem_binned_a(this_bin) = std(temp_a)/sqrt(length(temp_a));
end
end
