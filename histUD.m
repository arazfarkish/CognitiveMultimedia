function histdata = histUD(data)

nbins = 12;
binsize = 20;
histdata = zeros(1, nbins);
data_divided = data / binsize;

for idx=1:length(data_divided)
    bin = floor( data_divided(idx) ) + 1 + 6;
    if(bin > 11)
        bin = 12;
    elseif(bin < 2)
        bin = 1;
    end
    histdata(bin) = histdata(bin) + 1;
end




end