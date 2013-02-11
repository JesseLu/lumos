%% setup_lumos
% A script that gets things going for lumos.

    %% Add all subdirectories to path.
    lumos_root_dir = strrep(mfilename('fullpath'), '/setup_lumos', '');
    path(path, genpath(lumos_root_dir));

    %% Install maxwellFDS (alpha).
    % If this fails - try, try again.
    for i = 1 : 20
        try
            eval(urlread('http://m.lightlabs.co/alpha'));
            break;
        catch exception
            fprintf(getReport(exception, 'extended'));
            fprintf('\n');
            pause(rand(1)*10);
            continue;
        end
    end
