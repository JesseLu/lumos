%% model_I
% One port on the left and one port on the right.

function [epsilon] = model_I(omega)

%% Output parameters
% Fills in everything for mode structures, except for the in and out fields.
% At the same time, make the in and out fields easier to specify.

    dims = [60 60 40];
    eps_lo = 2.25;
    eps_hi = 13;
    z_center = dims(3)/2;
    z_thickness = 220 / 40;

    mu = {ones(dims), ones(dims), ones(dims)};
    epsilon = {eps_lo*ones(dims), eps_lo*ones(dims), eps_lo*ones(dims)};
    [s_prim, s_dual] = stretched_coordinates(omega, dims, [10 10 10]);

    background = struct('type', 'rectangle', ...
                        'position', [0 0], ...
                        'size', [1e9 1e9], ...
                        'permittivity', eps_lo);

    [wg{1}, port{1}] = wg_lores(epsilon, 'single', 'x+', dims(1), ... 
                                    [dims(1)/2 0 z_center]);

    [wg{2}, port{2}] = wg_lores(epsilon, 'single', 'x-', dims(1), ... 
                                    [-dims(1)/2 0 z_center]);

    epsilon = add_planar(epsilon, z_center, z_thickness, {background, wg{:}});
    
    % Build the selection matrix, and reset values of epsilon.
    reset_eps_val = eps_hi;
    border = 13;
    [S, epsilon] = planar_selection_matrix('alternate', epsilon, ...
                                    {border + [1 1], dims(1:2) - border}, ...
                                    reset_eps_val, z_center, z_thickness);


