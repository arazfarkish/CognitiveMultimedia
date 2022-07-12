function plot29Channels(signal)

% space = 200:100:3000;
space = 1:1:29;

signal_added = bsxfun(@plus, signal, space');

plot(signal_added(:, :)');   

end

    






