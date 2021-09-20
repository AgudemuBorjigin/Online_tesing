mat = 'mat_demo';
wav = 'wav_demo';
rootDir = '/Users/Agudemu/Dropbox/Lab_SNAP/Experiment/online_experiments/snaplabonline/audios/wordInNoise/audios/';
% all files in the dir
allFiles = dir(strcat(rootDir, mat, '/*.mat'));
Fs = 48828;
fileNames = cell(numel(allFiles), 1);
% letters used for enscription
symbols = ['a':'z' 'A':'Z' '0':'9'];
for i = 1:numel(allFiles)
    load(strcat(rootDir, mat, '/', allFiles(i).name));
    idx = randi(numel(symbols), [1, 16]);
    hashString = symbols(idx);
    wavName = strcat(configuration, '_', num2str(SNR), '_', num2str(wordlist), ...
        '_', num2str(target), '_', hashString, '.wav');
    fileNames{i} = wavName;
    audiowrite(strcat(rootDir, '/', wav, '/', wavName), y/max(abs(y(:))), Fs);
    % audio instance for volume adjustment; taking the noisiest
    % instance/lowest SNR
    if i == 1
        SNR_min = SNR;
        y_volume = y/max(abs(y(:)));
    else
        if SNR <= SNR_min
            SNR_min = SNR;
            y_volume = y/max(abs(y(:)));
        end
    end
end

% extending the duration of the audio for volume adjustment
for i = 1:10
    if i == 1
        y_volume_extention = y_volume;
    else
        y_volume_extention = [y_volume_extention; y_volume]; %#ok<AGROW>
    end
end
audiowrite(strcat(rootDir, '/', wav, '/', 'volume.wav'), y_volume_extention, Fs);

T = cell2table(fileNames(:));
writetable(T, strcat(rootDir, '/', wav, '/', 'fileNames.csv'));


