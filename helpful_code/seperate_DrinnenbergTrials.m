function SSpikes = seperate_DrinnenbergTrials(Spikes,diode_start,brightness_series)
%% This function cut each stimulus' spikes and add them up
%diode_on_start stores when on starts
%diode_off_start stores when off starts
%diode_end is when whole onoff stimulus end
SSpikes = cell(length(brightness_series)-1, 60);
for j = 1:length(Spikes) %running through each channel
    ss = Spikes{j};
    %Remove useless spikes
    ss(ss<diode_start(1)) = [];
    ss(ss>=diode_start(end))=[]; %Notice that last in starts should be end of stimulus
    ss(ss==0)=[];
    for k = 1:length(diode_start)-1
        if (mod(k-1, length(brightness_series))+1) == 9
            continue;
        end
        for i = 1:length(ss)%running all spikes in a channel
            if ss(i) >= diode_start(k) && ss(i) < diode_start(k+1)
                SSpikes{(mod(k-1, length(brightness_series))+1), j} = [SSpikes{(mod(k-1, length(brightness_series))+1), j}  ss(i)-diode_start(k)];
            end
        end
        SSpikes{(mod(k-1, length(brightness_series))+1), j} = sort(SSpikes{(mod(k-1, length(brightness_series))+1), j});
    end
end

end