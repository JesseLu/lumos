%% metamodel_1
% Generic in-plane nanophotonic model.

function [mode, vis_layer] = metamodel_1(dims, omega, in, out, ...
                                            wg_options, model_options)

    border = 13;

    if model_options.flatten % Make 2D.
        dims(3) = 1;
        pml_thickness(3) = 0;
    end

    if model_options.size == 'large'
        size_boost = 100;
        dims(1:2) = dims(1:2) + 2 * size_boost;
    elseif model_options.size == 'small'
        size_boost = 0;
    end

    S_type = model_options.S_type;

    eps_lo = 2.25;
    eps_hi = 12.25;
    z_center = dims(3)/2;
    z_thickness = 250 / 40;
    pml_thickness = [10 10 10];

    reset_eps_val = eps_lo;


    mu = {ones(dims), ones(dims), ones(dims)};
    [s_prim, s_dual] = stretched_coordinates(omega, dims, pml_thickness);


    %% Construct structure
    epsilon = {eps_lo*ones(dims), eps_lo*ones(dims), eps_lo*ones(dims)};
    background = struct('type', 'rectangle', ...
                        'position', [0 0], ...
                        'size', [1e9 1e9], ...
                        'permittivity', eps_lo);

    % Construct waveguides and modes.

    for i = 1 : length(wg_options)
        if wg_options(i).dir == '+'
            pos = [border-2, wg_options(i).ypos+size_boost, z_center];
        elseif wg_options(i).dir == '-'
            pos = [dims(1)-border+3, wg_options(i).ypos+size_boost, z_center];
        else
            error('Unknown waveguide direction option');
        end

        [wg{i}, ports{i}] = wg_lores(epsilon, wg_options(i).type, ...
                                ['x', wg_options(i).dir], dims(1)-border, pos);
    end


    epsilon = add_planar(epsilon, z_center, z_thickness, {background, wg{:}});
 

    %% Build the selection matrix
    % Appropriate values of epsilon must be reset.
    design_pos = {border + [1 1] + size_boost, dims(1:2) - border - size_boost};
    design_area = design_pos{2} - design_pos{1} + 1;
    [S, epsilon] = planar_selection_matrix(S_type, epsilon, ...
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
   
