%% model_L
% 1 port above (fiber, but simulates air) and M ports on the right.

function [mode, vis_layer] = model_L2(omega, in, out, wg_types, options)

%% Output parameters
% Fills in everything for mode structures, except for the in and out fields.
% At the same time, make the in and out fields easier to specify.

    % Number of input and output ports.
    M = length(wg_types);
    wg_spacer = 25;

    % Basic dimensions.
    min_sim_len = 120;
    sim_length = max([min_sim_len, (wg_spacer * (M + 1) + 10+10)]);
    dims = [min_sim_len sim_length 32];

    if options.flatten
        dims(2) = 1;
        sim_length = 1;
        wg_spacer = 0;
    end

    
    for i = 1 : M
        wg_dirs{i} = '-';
        ypos = round(wg_spacer * ((i-1) - (M-1)/2) + (sim_length-1)/2);
        wg_ypos{i} = ypos;
    end

    for i = 1 : length(wg_types)
        wg_options(i) = struct( 'type', wg_types{i}, ...
                                'dir', wg_dirs{i}, ...
                                'ypos', wg_ypos{i}); 
    end

    [mode, vis_layer] = metamodel_2a(dims, omega, in, out, wg_options, options);
end
