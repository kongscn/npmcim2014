% Solution to Problem 5
% Cost about 4minutes on a 2.0 GHz daul core CPU
% ! Note: * xlsx data is imported by two script, `import_carrier.m` and
%           `import_carriee.m`. 
%         * t2.xlsx corresponds to "±í2", but are fixed for irregular 
%           data structure.
%         * futher fill strategy is stored in `sches`

%% Configuration

clear
addpath('solver')

options = containers.Map;
options('fullfill') = true;

costs = containers.Map;
costs('11') = 1;
costs('12') = 1.4;
costs('22') = 1.9;

%% Given Data

% Carriers
import_carrier;
for i=1:size(t1, 1)
    carrier(i).id = num2str(t1(i,1));
    carrier(i).lwh = round(t1(i, 3:5)*100)/100;
    carrier(i).limit = round(t1(i, 6));
    carrier(i).cost = costs(num2str(t1(i,7)));
    carrier(i).type = t1(i, 7);
end

% Carriees
import_carriee;
carriee.lwh = round(t2(:, 5:7))/1000;

% Orders
orders = round(t2(:, 9:13));

%% Solutions
[ used, sches ] = opti_locs(carrier, carriee, orders, options);

used
