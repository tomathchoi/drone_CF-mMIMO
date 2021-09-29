%% Figure 4
% Using a Drone Sounder to Measure Channels for CF-mMIMO Systems
% Thomas Choi
% Last updated on 09-28-2021

%% Preprocessing - uncomment if H is not available
direc = 'E:\Drone Measurement Data\Measurement1 - GFS to cinema cylindrical RX array\'; % directory of where the channel data are located

% % start and end indices for each route: obtained through manual observations (don't change)
% start_i = [64 149 1 267 300 373; 1 41 1 211 191 219; 1 1 1 1 35 1; 1 1 1 1 1 1];
% end_i = [1401 1535 2031 1580 1608 1690; 1000 1046 1635 1176 1180 1218; 1002 1019 1431 942 945 1047; 1013 1040 1381 992 1033 1023];
% 
% % only use top row for ease of calculation
% H_cell = cell(4,6);
% for i = 1:4 % 4 different UEs
%     for j = 35 % 35m 
%         for k = 1:6 % 6 different parts of the trajectory
%             load([direc 'H' int2str(i) '_' int2str(j) 'm_R' int2str(k) '.mat']); % load the channel data
%             H_cell{i,k} = H_mat(start_i(i,k):end_i(i,k),2:8:end,:); % only take the top row
%         end
%     end
% end
% 
% H = cell(4,1);
% for i = 1:4
%     H{i} = cat(1,H_cell{i,1}, H_cell{i,2}, H_cell{i,3}, H_cell{i,4}, H_cell{i,5}, H_cell{i,6});     
% end
% 
% % load GPS data and take only the parts of the trajectory
% load([direc 'GPS_35m.mat']);
% GPS{1,1} = GPS{1,1}([64:1401 1550:2936 2937:4967 5234:6547 6898:8206 8595:9912],:);
% GPS{1,2} = GPS{1,2}([1:1000 1091:2096 2097:3731 3942:4907 5098:6087 6361:7360],:);
% GPS{1,3} = GPS{1,3}([1:1002 1003:2021 2022:3452 3453:4394 4429:5339 5340:6386],:);
% GPS{1,4} = GPS{1,4}([1:1013 1395:2434 2435:3815 3816:4807 4808:5840 5841:6863],:);

%% Inputs
load([direc 'H35m_preprocessed.mat']);
load([direc 'GPS35m_preprocessed.mat']);

% # of SINR values on cdf you would like to create
n_trial = 1000;

% choose the number of APs - change to 64 for Fig 4a and 256 for Fig 4b
n_AP = 256;

% choose the number of UEs
n_UE =4;

% number of frequency points
n_freq = 2301;

% uplink transmit power
p = 0; % dBm

% noise power
sigma = -90; % dBm

% temporary H matrix
H_trial = zeros(n_trial,n_AP,4,2301);

% initialize matrices
SINR = zeros(n_trial,n_UE);
SINR_MR = zeros(n_trial,n_UE);
SNR = zeros(n_trial,n_UE);

%% Processing
for i =975:n_trial
    %find indices of random APs from UE3 data (since it has least data)
    ind = sort(randperm(size(GPS{1,3},1), n_AP));
    for m = 1:n_AP
        % for UE3
        H_trial(i,m,3,:) = squeeze(H{3}(ind(m),randi(16), :));
        % find closest APs for UE1/2/4
        [~,y1] = min(vecnorm(abs([GPS{3}(ind(m),1) GPS{3}(ind(m),2)]-GPS{1}).'));
        [~,y2] = min(vecnorm(abs([GPS{3}(ind(m),1) GPS{3}(ind(m),2)]-GPS{2}).'));
        [~,y4] = min(vecnorm(abs([GPS{3}(ind(m),1) GPS{3}(ind(m),2)]-GPS{4}).'));
        H_trial(i,m,1,:) = squeeze(H{1}(y1, randi(16), :));
        H_trial(i,m,2,:) = squeeze(H{2}(y2, randi(16), :));
        H_trial(i,m,4,:) = squeeze(H{4}(y4, randi(16), :));
    end
    
    % Find the SINR and SNR values
    for f = 1:n_freq
        sum = squeeze(H_trial(i,:,1,f)).'*conj(squeeze(H_trial(i,:,1,f)))+squeeze(H_trial(i,:,2,f)).'*conj(squeeze(H_trial(i,:,2,f)))+squeeze(H_trial(i,:,3,f)).'*conj(squeeze(H_trial(i,:,3,f)))+squeeze(H_trial(i,:,4,f)).'*conj(squeeze(H_trial(i,:,4,f)));
        for k = 1:n_UE
            h_UE = squeeze(H_trial(i,:,k,f)).'; % channel
            sum_UE = sum-h_UE*h_UE'; % first term in denominator
           
            v_UE = (10^(p/10)*sum_UE+10^(sigma/10)*eye(n_AP))^-1*h_UE; % precoding for optimal
            v_UE_MR = h_UE; % precoding for MR
            
            SINR(i,k) = SINR(i,k) + (10^(p/10)*abs(v_UE'*h_UE)^2/(v_UE'*(10^(p/10)*sum_UE+10^(sigma/10)*eye(n_AP))*v_UE))/n_freq; % optimal SINR            
            SINR_MR(i,k) = SINR_MR(i,k) + (10^(p/10)*abs(v_UE_MR'*h_UE)^2/(v_UE_MR'*(10^(p/10)*sum_UE+10^(sigma/10)*eye(n_AP))*v_UE_MR))/n_freq; % MR SINR
        end
    end
end

%% Plotting
figure;
hold on;
C = linspecer(4);
width = 3.5;     % Width in inches
height = 2;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 8;      % Fontsize
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
grid on;

for k = 1:n_UE
    f1 = cdfplot(10*log10(abs(SINR(:,k))));
    f2 = cdfplot(10*log10(abs(SINR_MR(:,k))));
    f1.Color = C(k,:);
    f2.Color = C(k,:);
    set(f1,'linewidth',1.5);
    set(f2,'linewidth',2,'linestyle','--');
end

xlim([-10 30]);
ylim([10^-3 1]);
set(gca,'YScale','log');
title(['CDF of SINR: L=' int2str(n_AP) ', APs at 35m height']);
ylabel('CDF [log-scale]');
xlabel('SINR [dB]');
legend('UE1 opt', 'UE1 MR', 'UE2 opt', 'UE2 MR', 'UE3 opt', 'UE3 MR', 'UE4 opt', 'UE4 MR', 'Location', 'southeast');

