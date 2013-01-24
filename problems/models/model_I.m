%% model_I
% One port on the left and one port on the right.

function [mode] = model_I(omega, in, out, varargin)

%% Output parameters
% Fills in everything for mode structures, except for the in and out fields.
% At the same time, make the in and out fields easier to specify.

    if strcmp('2D', varargin)
        flatten = true;
    else
        flatten = false;
    end

    if flatten
        dims = [60 60 1];
        pml_thickness = [10 10 0];
    else
        dims = [60 60 40];
        pml_thickness = [10 10 10];
    end

    eps_lo = 2.25;
    eps_hi = 13;
    z_center = dims(3)/2;
    z_thickness = 220 / 40;
    border = 13;

    mu = {ones(dims), ones(dims), ones(dims)};
    [s_prim, s_dual] = stretched_coordinates(omega, dims, pml_thickness);


    %% Construct structure
    epsilon = {eps_lo*ones(dims), eps_lo*ones(dims), eps_lo*ones(dims)};
    background = struct('type', 'rectangle', ...
                        'position', [0 0], ...
                        'size', [1e9 1e9], ...
                        'permittivity', eps_lo);

    left_pos = [border-1, dims(2)/2, z_center];
    right_pos = [dims(1)-border+2, dims(2)/2, z_center];

    [wg{1}, ports{1}] = wg_lores(epsilon, 'single', 'x+', 2*border, left_pos);

    [wg{2}, ports{2}] = wg_lores(epsilon, 'single', 'x-', 2*border, right_pos);

    epsilon = add_planar(epsilon, z_center, z_thickness, {background, wg{:}});
 

    %% Build the selection matrix
    % Appropriate values of epsilon must be reset.
    reset_eps_val = eps_hi;
    [S, epsilon] = planar_selection_matrix('alternate', epsilon, ...
                                    {border + [1 1], dims(1:2) - border}, ...
                                    reset_eps_val, z_center, z_thickness);


    %% Specify modes
    mode = struct(  'omega', omega, ...
                    'in', build_io(ports, in), ...
                    'out', build_io(ports, out), ...
                    's_prim', {s_prim}, ...
                    's_dual', {s_dual}, ...
                    'mu', {mu}, ...
                    'epsilon_const', {epsilon}, ...
                    'S', (eps_hi - eps_lo) * S);

   
