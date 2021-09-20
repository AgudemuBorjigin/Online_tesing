path_new = '/Users/Agudemu/Dropbox/Lab_SNAP/Experiment/online_experiments/snaplabonline/audios/wordInNoise/audios/wav_fix';
path_old = '/Users/Agudemu/Dropbox/Lab_SNAP/Experiment/online_experiments/snaplabonline/audios/wordInNoise/audios/wav';
fileNames_new = dir(fullfile(path_new, 'echo*.wav'));
fileNames_old = dir(fullfile(path_old, 'echo-ref*.wav'));
for i = 1:numel(fileNames_new)
    idx_dash = find(fileNames_new(i).name == '_');
    idx_dot = find(fileNames_new(i).name == '.');
    fileNames_new_temp = strcat(fileNames_new(i).name(1:idx_dash(end)), fileNames_old(i).name(idx_dash(end)+1:end));
    movefile(fullfile(path_new, fileNames_new(i).name), fullfile(path_new, fileNames_new_temp));
end