function writeWillXY(x1, y1, fname)

fid = fopen(fname, 'w');

% make sure this gets written as two columns
for i=1:length(x1)
    fprintf(fid, '%f %f\n', x1(i), y1(i));
end
fclose(fid);
end
