%% setup_lumos
% A script that gets things going for lumos.

    %% Add all subdirectories to path.
    lumos_root_dir = strrep(mfilename('fullpath'), '/setup_lumos', '');
    path(path, genpath(lumos_root_dir));

    %% Install maxwellFDS (alpha).
    eval(urlread('http://m.lightlabs.co/alpha'));
