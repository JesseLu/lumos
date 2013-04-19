%% metamodel_cav
% Generic in-plane cavity model.

function [mode, vis_layer] = metamodel_cav(dims, omega, in, out, model_options)

    if model_options.flatten % Make 2D.
        dims(3) = 1;
        pml_thickness(3) = 0;
    end

    S_type = model_options.S_type;

    eps_lo = 1.0;
    eps_hi = 12.25;
    z_center = dims(3)/2;
    z_thickness = 250 / 40;
    pml_thickness = [10 10 10];
    border = 12;

    reset_eps_val = eps_lo;


    mu = {ones(dims), ones(dims), ones(dims)};
    [s_prim, s_dual] = stretched_coordinates(omega, dims, pml_thickness);


    %% Construct structure
    epsilon = {eps_lo*ones(dims), eps_lo*ones(dims), eps_lo*ones(dims)};
    slab = struct('type', 'rectangle', ...
                    'position', [0 0], ...
                    'size', [1e9 1e9], ...
                    'permittivity', eps_hi);

    epsilon = add_planar(epsilon, z_center, z_thickness, {slab});
 

    %% Build the selection matrix
    % Appropriate values of epsilon must be reset.
    design_pos = {border + [1 1], dims(1:2) - border};
    design_area = design_pos{2} - design_pos{1} + 1;
    [S, epsilon] = planar_selection_matrix(S_type, epsilon, ...
                                    design_pos, ...
                                    reset_eps_val, z_center, z_thickness);


    %% Specify modes
    mode_in = struct( 'type', 'point', ...
                        'power', in.power, ...
                        'pos', {{in.port}}, ...
                        'dir', in.mode);
    mode_out = struct( 'type', 'point', ...
                        'power', out.power, ...
                        'pos', {{out.port}}, ...
                        'dir', out.mode);

    mode = struct(  'omega', omega, ...
                    'in', mode_in, ...
                    'out', mode_out, ...
                    's_prim', {s_prim}, ...
                    's_dual', {s_dual}, ...
                    'mu', {mu}, ...
                    'epsilon_const', {epsilon}, ...
                    'S', (eps_hi - eps_lo) * S, ...
                    'design_area', design_area);

    %% Determine the visualization condition.
    vis_component = find(in.mode == 'xyz');
    vis_layer = struct( 'component', vis_component, ...
                        'slice_dir', 'z', ...
                        'slice_index', round(dims(3)/2));
   
