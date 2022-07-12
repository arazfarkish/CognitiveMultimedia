function secs = numberToSecs(n)
mins = floor(n);
fraction = n - mins;
secs = (mins*60) + (fraction*100);
end