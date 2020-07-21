function SortedFileNames= SortFileByGamma(TheFileNames)
Gs = [];
for filename = TheFileNames
    filename = convertStringsToChars(filename);
    istart = strfind(filename,'G');
    iend = strfind(filename(istart:end),'_');
    Gs = [Gs str2num(filename(istart+1:istart+iend(1)-2))];
end
[Gs I] = sort(Gs);
SortedFileNames = TheFileNames(I);
end