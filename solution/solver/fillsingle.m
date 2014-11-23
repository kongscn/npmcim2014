function [ result ] = fillsingle(order, carrier, carriee, options)
%fillsingle Fill a single 
%   Detailed explanation goes here

order = round(order);
assert(all(order >= 0));


cols = get_cols(carrier.type);

load_columns = cols.n;

carrier.len = carrier.lwh(1);
carrier.width = carrier.lwh(2);

carriee_len = carriee.lwh(:, 1);
carriee_width = carriee.lwh(:, 2);
carriee_height = carriee.lwh(:, 3);
carriee_types = length(order);

opts = containers.Map;
opts('wider') = 0.8;
opts('hlimit') = 1.7;
opts('hweight') = 10;
opts('wweight') = 10;
opts('weighted') = true;
opts('fullfill') = false;
opts('maxf') = 'len_usage';
opts('lb') = zeros(carriee_types * load_columns, 1);
opts('aux_limit') = ones(size(order)) * Inf;

if nargin > 3
    options_keys = options.keys;
    for i=1:length(options_keys)
        k = options_keys(i);
        opts(k{1}) = options(k{1});
    end
end

IsOverHigh = carriee_height > opts('hlimit');
if cols.n == 2
    IsOverWide = zeros(size(carriee_width));
elseif cols.n == 3
    IsOverWide = carriee_width ...
        > (carrier.width + opts('wider') -0.1)/2;
elseif cols.n == 4
    IsOverWide = carriee_width > (carrier.width - 0.1)/2;
end


intcon = 1:carriee_types * load_columns;

if strcmp(opts('maxf'), 'n')
    f = ones(1, carriee_types * load_columns);
elseif strcmp(opts('maxf'), 'len_usage')
    f = repmat(carriee_len', 1, load_columns);
end

if opts('weighted')
    fHightWeight = opts('hweight') * kron(~cols.hlimit, IsOverHigh');
    fWidthWeight = opts('wweight') * kron(~cols.wlimit, IsOverWide');
    f = f + fHightWeight;
    f = f + fWidthWeight;
%     f = f .* max(ones(size(fHightWeight)), fHightWeight);
%     f = f .* max(ones(size(fWidthWeight)), fWidthWeight);
end 

f = -f;

lens = kron(ones(load_columns), carriee_len');

A_len = kron(eye(load_columns), carriee_len'); 
b_len = ones(load_columns, 1) * carrier.len;

[ A_wlen, b_wlen ]  = get_Abwlen(cols.n, IsOverWide);
A_wlen = A_wlen .* lens;
b_wlen = b_wlen * carrier.len;

o = ones(1, load_columns);
k = kron(eye(carriee_types), o);
A_order = reshape(k, carriee_types * load_columns, carriee_types)';
b_order = order;

A = [A_len; A_wlen; A_order];
b = [b_len; b_wlen; b_order];


%% Height s.t.,
% To high: ==1
% Make X(upper, toHigh)==0

Aeq = kron(cols.hlimit, IsOverHigh');
beq = 0;

lb = opts('lb');
ub = repmat(order, load_columns, 1);

options = optimoptions('intlinprog','Display','off',...
     'MaxNodes',1e4); 

[load, fval] = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub, options);

load = round(load);

result.fval = fval;
result.remaining_len = b_len - A_len * load;
result.remaining_tlen = sum(result.remaining_len);

filled = reshape(load, carriee_types, load_columns);
result.filled = round(sum(filled, 2));
result.arrangement = filled;

result.nfilled = sum(result.filled);

result.aux = struct;

if opts('fullfill')
    order = opts('aux_limit') + result.filled;
    lb = load;
    ub = repmat(order, load_columns, 1);
    A_order = reshape(k, carriee_types * load_columns, carriee_types)';
    b_order = order;
    A_order = A_order(order<Inf,:);
    b_order = b_order(order<Inf,:);

    A = [A_len; A_wlen; A_order];
    b = [b_len; b_wlen; b_order];
    [load, fval] = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub,options);
    load = round(load);
    result.aux.fval = fval;
    result.aux.remaining_len = b_len - A_len * load;
    result.aux.remaining_tlen = sum(result.aux.remaining_len);
    filled = reshape(load, carriee_types, load_columns);
    result.aux.filled = round(sum(filled, 2));
    result.aux.arrangement = filled;

    result.aux.nfilled = sum(result.aux.filled);
    result.aux.auxn = result.aux.nfilled - result.nfilled;
    result.aux.auxorder = result.aux.filled - result.filled;
    assert(all(result.aux.auxorder>=0));
end

    function [ A_wlen, b_wlen ] = get_Abwlen(ncol, isOW)
        ordersz = size(isOW');
        if ncol == 2
            A_wlen = kron(zeros(2), isOW');
            b_wlen = zeros(2,1);
        elseif ncol == 3
            lr = kron(eye(2), isOW');
            lr = lr + kron(~eye(2), ones(ordersz));
            A_wlen = blkdiag(zeros(ordersz), lr);
            b_wlen = ones(3,1);
        elseif ncol == 4
            unit = kron(eye(2), isOW');
            unit = unit + kron(~eye(2), ones(ordersz));
            A_wlen = kron(eye(2), unit);
            b_wlen = ones(4, 1);
        end
    end

    function [cols] = get_cols(type)
        if type==11
            cols.n = 2;
            cols.hlimit = [0 1];
            cols.wlimit = [0 0];
        elseif type==12
            cols.n = 3;
            cols.hlimit = [0 1 1];
            cols.wlimit = [0 1 1];
        elseif type==22
            cols.n = 4;
            cols.hlimit = [1 1 1 1];
            cols.wlimit = [1 1 1 1];
        end
    end
end

