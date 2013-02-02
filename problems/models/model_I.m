%% model_I
% One port on the left and one port on the right.

function [mode, vis_layer] = model_I(omega, in, out, wg_types, type, flatten)

%% Output parameters
% Fills in everything for mode structures, except for the in and out fields.
% At the same time, make the in and out fields easier to specify.

    % Basic dimensions.
    dims = [60 60 40];
    pml_thickness = [10 10 10];

    if flatten % Make 2D.
        dims(3) = 1;
        pml_thickness(3) = 0;
    end

    eps_lo = 2.25;
    eps_hi = 12.25;
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

    left_pos = [border-2, dims(2)/2, z_center];
    right_pos = [dims(1)-border+3, dims(2)/2, z_center];

    [wg{1}, ports{1}] = wg_lores(epsilon, wg_types{1}, 'x+', 2*border, left_pos);

    [wg{2}, ports{2}] = wg_lores(epsilon, wg_types{2}, 'x-', 2*border, right_pos);

    epsilon = add_planar(epsilon, z_center, z_thickness, {background, wg{:}});
 

    %% Build the selection matrix
    % Appropriate values of epsilon must be reset.
    reset_eps_val = eps_lo;
    design_pos = {border + [1 1], dims(1:2) - border};
    design_area = design_pos{2} - design_pos{1} + 1;
    [S, epsilon] = planar_selection_matrix('average', epsilon, ...
                                    design_pos, ...
                                    reset_eps_val, z_center, z_thickness);


    %% Specify modes
    mode = struct(  'omega', omega, ...
                    'in', build_io(ports, in), ...
                    'out', build_io(ports, out), ...
                    's_prim', {s_prim}, ...
                    's_dual', {s_dual}, ...
                    'mu', {mu}, ...
                    'epsilon_const', {epsilon}, ...
                    'S', (eps_hi - eps_lo) * S, ...
                    'design_area', design_area);


    %% Determine the visualization condition.
    if strcmp(in.mode(1:2), 'te')
        vis_component = 2; % Look at Ey.
    elseif strcmp(in.mode(1:2), 'tm')
        vis_component = 3; % Look at Ez.
    else
        error('Could not determinte visualization component.');
    end

    vis_layer = struct( 'component', vis_component, ...
                        'slice_dir', 'z', ...
                        'slice_index', round(dims(3)/2));
   
