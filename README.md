# Cell-Free Massive MIMO Channel Measurement Data

1. [AP35m-UE1](https://public-ultralab.s3.us-west-1.amazonaws.com/public-ultralab/CF-mMIMO%3A+drone+measurement+2020/H_AP35m_UE1.zip)
2. [AP70m-UE1](https://public-ultralab.s3.us-west-1.amazonaws.com/public-ultralab/CF-mMIMO%3A+drone+measurement+2020/H_AP70m_UE1.zip)

This repo contains open-source channel measurement data for research and development purposes.

Copyright Thomas Choi, University of Southern California. The data may be used for non-commercial purposes only. Redistribution prohibited. If you use this data for results presented in research papers, please cite as follows: Data were obtained from [[Choi2021Using](https://arxiv.org/abs/2106.15276)], whose data are available at [[WiDeS_Choi2021Using](https://wides.usc.edu/research_matlab.html)].

*[[Choi2021Using](https://arxiv.org/abs/2106.15276)] T. Choi et al., "Using a drone sounder to measure channels for cell-free massive MIMO systems," arXiv preprint arXiv:2106.15276, 2021.*

*[[WiDeS_Choi2021Using](https://wides.usc.edu/research_matlab.html)] T. Choi et al., “Open-Source Cell-Free Massive MIMO Channel Data 2020”. URL: https://wides.usc.edu/research_matlab.html*

## Measurement Data Descriptions 
The measurement was conducted at the University of Southern California (University Park Campus). 

A drone with a single antenna acted as a transmitter and a cylidrical array with 128 antennas acted as a receiver.

The array contains 16 different linear array forming a cylinder, where each array contains 4 patch elements. 

Each patch element has two different ports (V-pol and H-pol), hence 8 ports per linear array.

We used 46 MHz bandwidth, with 2301 subcarriers, around 3.5 GHz center frequency.

More details of the channel sounder is described in [[Gomez2021Air](https://arxiv.org/abs/2103.09135)]. 

Each spatial point where the drone passes acts as a single-antenna access point (AP) and the array acts as a user equipment (UE).

The drone flew the same trajectory twice per each UE location, at 35m height and 70m height.

There were 4 UE locations on campus, hence the trajectory was repeated 8 times (4 UEs, 2 different heights).

Each trajectory was divided into 6 parts, due to drone battery issues.

There are 4 zipped folders, each containing channel data for each UE.

Each zipped folder contains 6 files, corresponding to channel data at 6 different parts of the trajectory.

The dimension of each file is (# of drone positions) x (128 antenna elements) x (2301 subcarriers). 

The GPS files contain latitude and longitude information of the drone for 4 different UEs, at both 35m and 70m height.

For each UE at one drone height, there is (# of drone positions) x 2 data, where 2 corresponds to latitude and longitude of the drone.

For multi-user MIMO studies, the AP (drone) locations must be synchronized for different UEs using this GPS information.

The latitude and longitude of UE1 to UE4 are:

UE1: 34.02105616098113, -118.2881572051255

UE2: 34.0226219987896, -118.28716839187055

UE3: 34.02346551661122, -118.28772482646559

UE4: 34.02349858327912, -118.287700908681

Any further questions regarding the dataset can be emailed to Thomas Choi, choit@usc.edu, and he will respond as soon as possible.

*[[Gomez2021Air](https://arxiv.org/abs/2103.09135)] J. Gomez-Ponce et al., "Air-to-Ground Directional Channel Sounder With 64-antenna Dual-polarized Cylindrical Array," arXiv preprint arXiv:2103.09135, 2021.*

![alt text](https://github.com/tomathchoi/CF-mMIMO/blob/main/drone_trajectory.png?raw=true)
