function [ used, scheme, auxorder_total, iter ] = ...
    opti_loc( order, carrier, carriee, options )
%opti_loc Find fill strategy for a single destination.
%
% options: keys that store solution configuration, valid keys are:
%   const15:  每次1-2型轿运车使用量不超过1-1型轿运车使用量的20%
%   fullfill: whether or not use auxiliary order to fullfill carrier
%   aux_limit: max auxiliary order. 
opts = containers.Map;
opts('const15') = false;
opts('fullfill') = false;

carrier_cost = ones(1, length(carrier));
for i=1:length(carrier)
    carrier_cost(i) = carrier(i).cost;
end


if nargin > 3
    options_keys = options.keys;
    for i=1:length(options_keys)
        k = options_keys(i);
        opts(k{1}) = options(k{1});
    end
end

used = zeros(1, length(carrier));
scheme = {};
auxorder_total = zeros(size(order));

iter = 0;
while any(round(order)) > 0
    iter = iter + 1;
    nfill = zeros(1, length(carrier));
    rests = {};
    for i=1:length(carrier)
        if i==9
            fooo=7;
        end
        if carrier(i).limit > 0
            rest = fillsingle(order, carrier(i), carriee, opts);
            nfill(i) = rest.nfilled;
        else
            nfill(i) = 0;
            rest = struct;
        end
        rests{i} = rest;
    end
    maxf = nfill .*  (nfill == max(nfill));
    wmaxf = maxf ./ carrier_cost;
    [C, I] = max(wmaxf);
    % 1:5 constrain
    if opts('const15') && I == 2 && used(2) + 1 > 0.2 * used(1)
        nfill(I) = 0;
        [C, I] = max(nfill);
    end
    carrier(I).limit = carrier(I).limit - 1;
    used(I) = used(I) + 1;
    fill_scheme = rests{I};
    
    scheme = [scheme, fill_scheme];
    order = order - fill_scheme.filled;
    assert(min(order)>=0);
    if opts('fullfill')
        auxorder_total = auxorder_total + fill_scheme.aux.auxorder;
        if isKey(opts, 'aux_limit')
            opts('aux_limit') = opts('aux_limit') - fill_scheme.aux.auxorder;
        end
    end
end

end

