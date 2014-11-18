function [carrier_used, additional] = opti_point(carriee_lwh, order, upper_hlimit,  carriers, carrier_limits, flex_order, ratio_limit)
if nargin == 6
    ratio_limit = 0;
end

% carriers = [carrier_types, carrier_lwhs, carrier_limits];
carrier_lwhs = carriers(:,2:4);

carrier_used = zeros(size(carrier_limits));
iters = 0;

results = {};

while any(order > 1e-3)
    iters =iters + 1;
    fill_counts = [];
    filled_orders = [];
    arranges = {};
    for i=1:size(carrier_lwhs, 1)
        if carrier_limits(i) > 0
            [filled, arrange, filled_count, remaining_len, fval] = fill_carrier(carriers(i,1), order, carriers(i, 2:4), carriee_lwh, upper_hlimit);
            fill_counts(i) = filled_count;
            filled_orders = [filled_orders, filled];
            arranges{i} = arrange;
        else
            fill_counts(i) = 0;
            filled_orders = [filled_orders, zeros(size(order))];
            arranges{i} = 0;
        end
    end
    [C, I] = max(fill_counts);
    if ratio_limit
        if I == 2 && carrier_used(2)+1 > 0.2 * carrier_used(1)
            fill_counts(I) = 0;
            [C, I] = max(fill_counts);
        end
    end
    carrier_limits(I) = carrier_limits(I) - 1;
    carrier_used(I) = carrier_used(I) + 1;
    filled = filled_orders(:, I);
    arrange = arranges{I};
    order = order - filled;
    order = max(order, zeros(size(order)));
end

if any(flex_order) > 1e-3
    orig_order = filled;
    [filled, arrange, filled_count, remaining_len, fval] = fill_carrier(I, flex_order, carriers(I, 2:4), carriee_lwh, upper_hlimit, arrange);
    additional = filled - orig_order;
else
    additional = zeros(size(flex_order));
end


