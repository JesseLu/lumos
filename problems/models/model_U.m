%% model_U
% ports above and below (fiber).

%% Description
% Allows 10 modes for full 3D, 6 modes for 2D.

function [mode, vis_layer] = model_U(omega, in, out, wg_types, options)

%% Output parameters
% Fills in everything for mode structures, except for the in and out fields.
% At the same time, make the in and out fields easier to specify.

    % Number of input and output ports.
    dims = [120 120  32]; 
    if options.flatten
        dims(2) = 1;
        sim_length = 1;
    end

    [mode, vis_layer] = metamodel_3(dims, omega, in, out, options);
end
