function TheFileNames = ChooseWantedfile(Includings, Excluding)
TheFileNames = [];
all_file = dir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
for i = 1:length(all_file)
    pass = true;
    for requirement = Includings
        if ~contains(replace(all_file(i).name,'Q100', ''), convertStringsToChars(requirement))
            pass = false;
            break
        end
    end
    for requirement = Excluding
        if contains(replace(all_file(i).name,'Q100', ''), convertStringsToChars(requirement))
            pass = false;
            break
        end
    end
    if pass
        TheFileNames = [TheFileNames string(all_file(i).name)];
    end
end
end
