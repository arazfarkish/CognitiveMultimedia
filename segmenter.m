function segmented = segmenter(signal, seg_len)

if nargin < 2
    seg_len = 1000;
end

[rows, cols] = size(signal);
n_segments = floor(cols / seg_len);
segmented = zeros(rows, seg_len, n_segments);
for i=1:n_segments
    beginning = ((i-1) * seg_len + 1);
    segmented(:, :, i) = signal(:, beginning:beginning+seg_len-1);
end

end