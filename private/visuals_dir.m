%% visuals_dir
% Return the full path to the visualization folder as a string.

function [path_to_visuals_dir] = visuals_dir()
    % Assumes the parent folder to this foler is also the parent folder
    % to the visuals folder.

    path_to_visuals_dir = ...
        strrep(mfilename('fullpath'), ...
                [filesep, 'private', filesep, 'visuals_dir'], ...
                [filesep, 'visuals', filesep]);

