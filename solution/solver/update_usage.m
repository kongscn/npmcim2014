function [ carrier ] = update_usage( carrier, used )
for i=1:length(carrier)
    carrier(i).limit = carrier(i).limit - used(i);
end
end

