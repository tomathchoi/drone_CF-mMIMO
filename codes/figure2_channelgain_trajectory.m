%% Figure 2
% Using a Drone Sounder to Measure Channels for CF-mMIMO Systems
% Thomas Choi
% Last updated on 09-27-2021

%% Inputs
direc = 'E:\Drone Measurement Data\Measurement1 - GFS to cinema cylindrical RX array\'; % directory of where the channel data are located

% start and end indices for each route: obtained through manual observations (don't change)
start_i = zeros(4,2,6);
end_i = zeros(4,2,6);
start_i(:,1,:) = [64 149 1 267 300 373; 1 41 1 211 191 219; 1 1 1 1 35 1; 1 1 1 1 1 1];
end_i(:,1,:) = [1401 1535 2031 1580 1608 1690; 1000 1046 1635 1176 1180 1218; 1002 1019 1431 942 945 1047; 1013 1040 1381 992 1033 1023];
start_i(:,2,:) = [275 467 1 201 271 341; 1 1 1 39 80 186; 25 1 1 1 1 1; 1 1 1 70 41 31];
end_i(:,2,:) = [1582 1879 1959 1500 1570 1647; 941 1018 1567 1031 1091 1128; 985 1028 1492 897 1050 1044; 966 950 1445 1059 1059 1061];

% offset gain coming from synthesizing an ominidirectional pattern by adding antenna elements (don't change)
offset = 14.3+12; % dB - 14.3 comes from the addition of row elements and 12 dB comes from addition of column elements

%% Plotting
for i = 1:4 % 4 different UEs
    for j = 35:35:70 % 35m and 70m
        for k = 1:6 % 6 different parts of the trajectory
            load([direc 'H' int2str(i) '_' int2str(j) 'm_R' int2str(k) '.mat']); % load the channel data
            num = end_i(i,j/35,k) - start_i(i,j/35,k) + 1; % number of spatial points per path
            H_mean = zeros(1,num);
            H_mean(1:num) = 20*log10(mean(squeeze(sum(abs(H_mat(start_i(i,j/35,k):end_i(i,j/35,k),2:2:128,:)),2)),2))-offset; % sum over elements to form an omnidirectional pattern, take average over frequency points, and subtract by offset
            
            % plot details
            figure;
            imagesc(H_mean);
            colormap(jet);
            colorbar;
            caxis([-105 -70]);
            set(gca,'ytick',[]);
            xlabel('time (s)');
            x0=100;
            y0=100;
            width=1000;
            height=100;
            set(gcf,'position',[x0,y0,width,height])
            title(['Channel Gain for UE' int2str(i) ' AP' int2str(j) 'm R' int2str(k)]);
        end
    end
end