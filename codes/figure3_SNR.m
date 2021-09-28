%% Figure 3
% Using a Drone Sounder to Measure Channels for CF-mMIMO Systems
% Thomas Choi
% Last updated on 09-28-2021

%% Preprocessing - uncomment if beta (channel gain values) is not available
direc = 'E:\Drone Measurement Data\Measurement1 - GFS to cinema cylindrical RX array\'; % directory of where the channel data are located

% % start and end indices for each route: obtained through manual observations (don't change)
% start_i = zeros(2,2,6);
% end_i = zeros(2,2,6);
% start_i(:,1,:) = [64 149 1 267 300 373; 1 41 1 211 191 219];
% end_i(:,1,:) = [1401 1535 2031 1580 1608 1690; 1000 1046 1635 1176 1180 1218];
% start_i(:,2,:) = [275 467 1 201 271 341; 1 1 1 39 80 186];
% end_i(:,2,:) = [1582 1879 1959 1500 1570 1647; 941 1018 1567 1031 1091 1128];
% 
% % offset gain coming from synthesizing an ominidirectional pattern by adding antenna elements (don't change)
% offset = 14.3+12; % dB - 14.3 comes from the addition of row elements and 12 dB comes from addition of column elements
% 
% % creating beta indicating average channel gains over frequency
% beta_cell = cell(2,2,6);
% for i = 1:2 % 2 different UEs
%     for j = 35:35:70 % 35m and 70m
%         for k = 1:6 % 6 different parts of the trajectory
%             load([direc 'H' int2str(i) '_' int2str(j) 'm_R' int2str(k) '.mat']); % load the channel data
%             beta_cell{i,j/35,k} = mean(squeeze(sum(abs(H_mat(start_i(i,j/35,k):end_i(i,j/35,k),2:2:128,:)),2)),2).^2*10^(-offset/10); % square the (sum over elements to form an omnidirectional pattern, take average over frequency points, and subtract by offset)
%         end
%     end
% end
% 
% % combine beta over the routes
% beta = cell(2,2);
% for i = 1:2
%     for j = 1:2
%         beta{i,j} = cat(1,beta_cell{i,j,1}, beta_cell{i,j,2}, beta_cell{i,j,3}, beta_cell{i,j,4}, beta_cell{i,j,5}, beta_cell{i,j,6});
%     end
% end

%% Inputs
% load beta if you already have the beta
load([direc 'beta_UE1&2_35&70m.mat']);

% number of trials
n_trial = 10000;

% number of APs
n_AP = 1:10; % varying between 2 to 1024

% uplink power
p = 0; % dBm

% noise power
sigma = -90; % dBm 

%% Processing
SNR = zeros(2,2,length(n_AP),n_trial);
for i = 1:2 % UE 1&2 
    for j = 1:2 % AP 35m&70m
        for k = 1:length(n_AP) % number of APs
            for m = 1:n_trial
                ind = sort(randperm(length(beta{i,j}),2^n_AP(k))); % indices of selected APs
                SNR(i,j,k,m) = 10^(p/10)/10^(sigma/10)*sum(beta{i,j}(ind)); % sum of the SNR over APs
            end
        end
    end
end

%% Plotting figure 3(a)
figure; hold on;
% Defaults for this blog post
width = 3.5;     % Width in inches
height = 2;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 8;      % Fontsize
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
grid on;
xlim([0.8 10]);
xticks(1:10);
ylim([-20 40]);
yticks(-20:10:40);

for k = 1:length(n_AP)
    scatter(ones(1,n_trial)*k, 10*log10(squeeze(SNR(1,1,k,:))), 'Marker', 'o', 'MarkerEdgeColor', 'k'); %35m
    scatter(ones(1,n_trial)*k, 10*log10(squeeze(SNR(1,2,k,:))), 'Marker', 'x', 'MarkerEdgeColor', 'r'); %70m
end
plot(median(10*log10(squeeze(SNR(1,1,:,:))),2), 'k'); %35m median
plot(median(10*log10(squeeze(SNR(1,2,:,:))),2), 'r'); %70m median
legend('35m APs', '70m APs', 'Location', 'southeast');
xlabel('# of single-antenna APs [log_2L]');
ylabel('SNR [dB]');
title('Uplink SNR of UE1');

%% Plotting figure 3(b)
figure; hold on;
% Defaults for this blog post
width = 3.5;     % Width in inches
height = 2;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 8;      % Fontsize
lw = 0;      % LineWidth
msz = 8;       % MarkerSize
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
grid on;
xlim([0.8 10]);
xticks(1:10);
ylim([-20 40]);
yticks(-20:10:40);

for k = 1:length(n_AP)
    scatter(ones(1,n_trial)*k, 10*log10(squeeze(SNR(2,1,k,:))), 'Marker', 'o', 'MarkerEdgeColor', 'k'); %35m
    scatter(ones(1,n_trial)*k, 10*log10(squeeze(SNR(2,2,k,:))), 'Marker', 'x', 'MarkerEdgeColor', 'r'); %70m
end
plot(median(10*log10(squeeze(SNR(2,1,:,:))),2), 'k'); %35m median
plot(median(10*log10(squeeze(SNR(2,2,:,:))),2), 'r'); %70m median
legend('35m APs', '70m APs', 'Location', 'southeast');
xlabel('# of single-antenna APs [log_2L]');
ylabel('SNR [dB]');
title('Uplink SNR of UE2');