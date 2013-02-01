%% results_folder
% Return the full path to the results folder as a string.

function [path_to_results_dir] = results_folder()
    % Assumes the parent folder to this foler is also the parent folder
    % to the results folder.

    path_to_results_dir = ...
        strrep(mfilename('fullpath'), '/private/results_folder', '/results/');

