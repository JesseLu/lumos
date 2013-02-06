%% model_H
% M ports on the left and M ports on the right.

function [mode, vis_layer] = model_V(omega, in, out, wg_types, options)

%% Output parameters
% Fills in everything for mode structures, except for the in and out fields.
% At the same time, make the in and out fields easier to specify.

    % Number of input and output ports.
    M = length(wg_types) / 2;
    wg_spacer = 25;

    % Basic dimensions.
    sim_length = wg_spacer * (M + 1) + 10;
    dims = [sim_length sim_length 40];

    
    for i = 1 : M
        wg_dirs{i} = '+';
        wg_dirs{M+i} = '-';

        ypos = round(wg_spacer * ((i-1) - (M-1)/2) + (sim_length-1)/2);
        wg_ypos{i} = ypos;
        wg_ypos{M+i} = ypos;
    end

    for i = 1 : length(wg_types)
        wg_options(i) = struct( 'type', wg_types{i}, ...
                                'dir', wg_dirs{i}, ...
                                'ypos', wg_ypos{i}); 
    end

    [mode, vis_layer] = metamodel_1(dims, omega, in, out, wg_options, options);
end
