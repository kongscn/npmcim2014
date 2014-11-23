function [ used, sches ] = opti_locs( carrier, carriee, orders, options )
%opti_locs Find fill strategy corresponds to destinations like in Problem 5.
%
% options: key-values that control solution configurations,
%          see `opti_loc` for detail.

order.A = orders(:, 1);
order.B = orders(:, 2);
order.C = orders(:, 3);
order.D = orders(:, 4);
order.E = orders(:, 5);

%% Solutions
total_used = 0;
total_sche = {};

% First, consider the left remot point, C

odr = order.C;
aux_limit = order.D;
options('aux_limit') = aux_limit;

[ used, sche, aux] = opti_loc(odr, carrier, carriee, options);
carrier = update_usage(carrier, used);

total_used = total_used + used;
total_sche = [total_sche, sche];
order.D = order.D - aux;


% Second, consider the right remote point, A

odr = order.A;
aux_limit = order.B + order.D;
options('aux_limit') = aux_limit;

[ used, sche, aux] = opti_loc(odr, carrier, carriee, options);
carrier = update_usage(carrier, used);

total_used = total_used + used;
total_sche = [total_sche, sche];
order.B = order.B - aux;
order.D = order.D + min(order.B, zeros(size(order.B)));
order.B = max(order.B, zeros(size(order.B)));


% Third, consider the point E. No orders found.

odr = order.E;
aux_limit = order.B + order.D;
options('aux_limit') = aux_limit;

[ used, sche, aux] = opti_loc(odr, carrier, carriee, options);
carrier = update_usage(carrier, used);

total_used = total_used + used;
total_sche = [total_sche, sche];
order.B = order.B - aux;
order.D = order.D + min(order.B, zeros(size(order.B)));
order.B = max(order.B, zeros(size(order.B)));


% Fourth, consider point B.

odr = order.B;
aux_limit = order.D;
options('aux_limit') = aux_limit;

[ used, sche, aux] = opti_loc(odr, carrier, carriee, options);
carrier = update_usage(carrier, used);

total_used = total_used + used;
total_sche = [total_sche, sche];
order.D = order.D - aux;


% Finally, consider point D.

odr = order.D;

[ used, sche, aux] = opti_loc(odr, carrier, carriee, options);
carrier = update_usage(carrier, used);

total_used = total_used + used;
total_sche = [total_sche, sche];

used = total_used;
sches = total_sche;

end

