%% results_dir
% Return the full path to the results folder as a string.

function [path_to_results_dir] = results_dir()
    % Assumes the parent folder to this foler is also the parent folder
    % to the results folder.

    path_to_results_dir = ...
        strrep(mfilename('fullpath'), ...
                [filesep, 'private', filesep, 'results_dir'], ...
                [filesep, 'results', filesep]);

