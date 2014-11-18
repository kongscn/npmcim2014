% Solution to Problem 1-3
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

carriee.lwh = [4.61     1.7     1.51; 
               3.615    1.605   1.394;
               4.63     1.785   1.77];

order = [100; 68;  0 ];    % Sol 16 - 2 T
order = [72;  52;  0 ];    % Sol 11 - 2 vs 12 - 1
% order = [156; 102; 39];    % Sol 25 - 5 T

options = containers.Map;
options('const15') = true;
options('fullfill') = true;

[ used, sche, aux] = opti_loc(order, carrier, carriee, options);

% strategy = {};
% used = zeros(1, length(carrier));
% iter = 0;
% 
% while any(round(order)) > 0
%     iter = iter+1;
%     nfill = zeros(1, length(carrier));
%     rests = {};
%     for i=1:length(carrier)
%         if carrier(i).limit > 0
%             rest = fillsingle(order, carrier(i), carriee);
%             nfill(i) = rest.nfilled;
%         else
%             nfill(i) = 0;
%             rest = struct;
%         end
%         rests{i} = rest;
%     end
%     [C, I] = max(nfill);
%     % 1:5 constrain
%     if I == 2 && used(2) + 1 > 0.2 * used(1)
%         nfill(I) = 0;
%         [C, I] = max(nfill);
%     end
%     I
%     carrier(I).limit = carrier(I).limit - 1;
%     used(I) = used(I) + 1;
%     strategy = [strategy, rests{I}];
%     order = order - rests{I}.filled;
%     assert(min(order)>=0);
% end

used