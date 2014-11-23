% Solution to Problem 4
% 25-2 v.s. 23-3

clear
addpath('solver')

%% Configuration

options = containers.Map;
options('const15') = true;
options('fullfill') = true;

%% Given Data

% Carriers

carrier(1).lwh = [19       2.7     100];
carrier(1).type = 11;
carrier(1).cost = 1;
carrier(1).limit = Inf;

carrier(2).lwh = [24.3     2.7     100];
carrier(2).type = 12;
carrier(2).cost = 1.4;
carrier(2).limit = Inf;

carrier(3).lwh = [19       4     100];
carrier(3).type = 22;
carrier(3).cost = 1.9;
carrier(3).limit = 0;

% Carriees

carriee.lwh = [4.61     1.7     1.51; 
               3.615    1.605   1.394;
               4.63     1.785   1.77];
           
% Orders

orders = [42 50 33 41 0;
          31  0 47  0 0;
          0   0  0  0 0];
      
      
[ used, sches ] = opti_locs(carrier, carriee, orders, options);

used
