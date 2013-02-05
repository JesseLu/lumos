%% model_V
% One port on the left and two ports on the right.

function [mode, vis_layer] = model_V(omega, in, out, wg_types, options)

%% Output parameters
% Fills in everything for mode structures, except for the in and out fields.
% At the same time, make the in and out fields easier to specify.

    % Basic dimensions.
    dims = [80 80 40];

    wg_dirs = {'+', '-', '-'};
    wg_ypos = {dims(2)/2, 27, 54};

    for i = 1 : length(wg_types)
        wg_options(i) = struct( 'type', wg_types{i}, ...
                                'dir', wg_dirs{i}, ...
                                'ypos', wg_ypos{i}); 
    end

    [mode, vis_layer] = metamodel_1(dims, omega, in, out, wg_options, options);
end
