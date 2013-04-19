function [mode, vis_layer] = model_C(omega, in, out, model_structure, options)

%% Output parameters
% Fills in everything for mode structures, except for the in and out fields.
% At the same time, make the in and out fields easier to specify.

    % Basic dimensions.
    dims = [120 120 40];

    [mode, vis_layer] = metamodel_cav(dims, omega, in, out, options);
end
