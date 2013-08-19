%% model_I2
% One port on the left and one port on the right.

function [mode, vis_layer] = model_I(omega, in, out, wg_types, options)

%% Output parameters
% Fills in everything for mode structures, except for the in and out fields.
% At the same time, make the in and out fields easier to specify.

    % Basic dimensions.
    dims = [120 70 40];

    wg_dirs = {'+', '-'};
    wg_ypos = {dims(2)/2, dims(2)/2};

    for i = 1 : 2
        wg_options(i) = struct( 'type', wg_types{i}, ...
                                'dir', wg_dirs{i}, ...
                                'ypos', wg_ypos{i}); 
    end

    [mode, vis_layer] = metamodel_1(dims, omega, in, out, wg_options, options);
end
