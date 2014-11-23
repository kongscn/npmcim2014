% Solution to Problem 1-3

clear
addpath('solver')

%% Given Data

% Orders 

order = [100; 68;  0 ];    % Order of problem 1, solution: 16 - 2 T
% order = [72;  52;  0 ];    % Order of problem 2, solution: 11 - 2 vs 12 - 1
% order = [156; 102; 39];    % Order of problem 3, solution: 25 - 5 T

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

carriee.lwh = [4.61     1.7     1.51; 
               3.615    1.605   1.394;
               4.63     1.785   1.77];

options = containers.Map;
options('const15') = true;
options('fullfill') = true;

[ used, sche, aux] = opti_loc(order, carrier, carriee, options);

used