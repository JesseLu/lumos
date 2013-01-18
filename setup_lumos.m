%% setup_lumos
% A script that gets things going for lumos.

%% Add all subdirectories to path.
path(path, genpath('.'));

%% Install maxwellFDS (alpha).
eval(urlread('http://m.lightlabs.co/alpha'));
