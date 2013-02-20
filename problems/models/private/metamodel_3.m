%% metamodel_2
% Fiber-to-fiber metamodel.

function [mode, vis_layer] = metamodel_2(dims, omega, in, out, model_options)

    border = 15;
    pml_thickness = [10 10 10];

    if model_options.size == 'large'
        size_boost = 20;
    elseif model_options.size == 'small'
        size_boost = 0;
    end
    dims(3) = dims(3) + 2 * size_boost;

    if model_options.flatten % Make 2D.
        dims(2) = 1;
        pml_thickness(2) = 0;
    end

    S_type = model_options.S_type;

    eps_lo = 2.25;
    eps_hi = 12.25;
    z_center = dims(3)/2;
    z_thickness = 250 / 40;
    reset_eps_val = eps_lo;

    fiber_radius = 25;
    fiber_eps = 2.56;
    fiber_z_center = 1;
    fiber_z_thickness = 1e9;

    sel_z_thickness = z_thickness;
    sel_z_center = z_center;
%     sel_z_thickness = z_thickness/2;
%     sel_z_center = z_center + z_thickness/4;


    mu = {ones(dims), ones(dims), ones(dims)};
    [s_prim, s_dual] = stretched_coordinates(omega, dims, pml_thickness);


    %% Construct structure
    epsilon = {eps_lo*ones(dims), eps_lo*ones(dims), eps_lo*ones(dims)};

    background = struct('type', 'rectangle', ...
                        'position', [0 0], ...
                        'size', [1e9 1e9], ...
                        'permittivity', eps_lo);

    % Upper half-plane consists of an optical fiber.
    % We use two circles to give a slight ellipticity to the core,
    % so that the fundamental mode has a non-random polarization.
    fiber = {struct('type', 'circle', ...
                    'position', [0 -1], ...
                    'radius', fiber_radius, ...
                    'permittivity', fiber_eps), ...
            struct('type', 'circle', ...
                    'position', [0 +1], ...
                    'radius', fiber_radius, ...
                    'permittivity', fiber_eps)};
    epsilon = add_planar(epsilon, fiber_z_center, fiber_z_thickness, ...
                        {background, fiber{:}});


    fiber_top = struct('type', 'wgmode', ...
                        'dir', 'z-', ...
                        'ypol', 1, ...
                        'xpol', 2, ...
                        'circ', 3, ...
                        'pos', {{[1 1 dims(3)-11-size_boost], ...
                            [dims(1) dims(2) dims(3)-11-size_boost]}}, ...
                        'J_shift', [0 0 -1], ...
                        'E_shift', [0 0 1]);

    fiber_bot = struct('type', 'wgmode', ...
                        'dir', 'z+', ...
                        'ypol', 1, ...
                        'xpol', 2, ...
                        'circ', 3, ...
                        'pos', {{[1 1 11+size_boost], ...
                                [dims(1) dims(2) 11+size_boost]}}, ...
                        'J_shift', [0 0 0], ...
                        'E_shift', [0 0 -1]);

%     % Construct back-reflector.
%     back_reflector = struct('type', 'rectangle', ...
%                             'position', [0 0], ...
%                             'size', [1e9 1e9], ...
%                             'permittivity', -20);
%     epsilon = add_planar(epsilon, 1, (dims(3)/2 - 20)*2, {back_reflector});


% 
%     % Construct in-plane waveguides and modes.
%     for i = 1 : length(wg_options)
%         if wg_options(i).dir == '+'
%             pos = [2+pml_thickness(1), wg_options(i).ypos, z_center];
%         elseif wg_options(i).dir == '-'
%             pos = [dims(1)-pml_thickness(1)-2, wg_options(i).ypos, z_center];
%         else
%             error('Unknown waveguide direction option');
%         end
% 
%         pos(3) = pos(3) + 3; % Move away from mirror.
%         [wg{i}, ports{i}] = wg_lores(epsilon, wg_options(i).type, ...
%                                 ['x', wg_options(i).dir], dims(1)-border, pos);
%     end

    % Need to know design pos for half-etched structure.
    design_pos = {border + 1, dims(1:2)- border};
    bottom = struct('type', 'rectangle', ...
                    'position', [0 0], ...
                    'size', design_pos{2} - design_pos{1}+0.5, ...
                    'permittivity', eps_hi);
    if bottom.size(2) < 1
        bottom.size(2) = 1;
    end


    % epsilon = add_planar(epsilon, z_center, z_thickness, {background, bottom});

%     for k = 1 : 3
%         subplot(2, 3, k);
%         imagesc(abs(squeeze(epsilon{k}(:,:,round(dims(3)/2))))'); 
%         axis equal tight;
%         subplot(2, 3, 3+k);
%         imagesc(abs(squeeze(epsilon{k}(:,round(dims(2)/2),:)))'); 
%         axis equal tight;
%     end
%     pause

    % Ports are just the top and bottom fiber ports
    ports = {fiber_top, fiber_bot};
 

    %% Build the selection matrix
    % Appropriate values of epsilon must be reset.
    design_area = design_pos{2} - design_pos{1} + 1;
    if design_area(2) < 1 % Correction for y-flattened types.
        design_area(2) = 1;
        design_pos{1}(2) = 1;
        design_pos{2}(2) = 1;
    end

    epsilon_orig = epsilon;
    [S, epsilon] = planar_selection_matrix(S_type, epsilon, ...
                                    design_pos, ...
                                    reset_eps_val, sel_z_center, sel_z_thickness);

    % Fancy fix.
    % Gets rid of intermediate layer values for the assymetric structure.
    n = prod(dims);
    vec = @(f) [f{1}(:); f{2}(:); f{3}(:)];
    unvec = @(v) {reshape(full(v(1:n)), dims), ...
                    reshape(full(v(n+1:2*n)), dims), ...
                    reshape(full(v(2*n+1:3*n)), dims)};
    delta_epsilon = vec(epsilon_orig) - ...
                    (vec(epsilon) + (eps_hi - eps_lo) * S * ones(size(S,2), 1));
    delta_epsilon = (delta_epsilon > 0) .* delta_epsilon;
    epsilon = unvec(vec(epsilon) + abs(delta_epsilon));


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

    if model_options.size == 'large'
        % Add redundant out calculations.
        mode.out = build_io(ports, out, size_boost + 1);
    end


    %% Determine the visualization condition.
    if strcmp(in.mode, 'ypol')
        vis_component = 2; % Look at Ey.
    elseif strcmp(in.mode, 'xpol')
        vis_component = 1; % Look at Ex.
    elseif strcmp(in.mode, 'circ')
        vis_component = 2; % Look at Ey.
    else
        error('Could not determine visualization component.');
    end

    if model_options.flatten
        vis_layer = struct( 'component', vis_component, ...
                            'slice_dir', 'y', ...
                            'slice_index', 1);
    else
        vis_layer = struct( 'component', vis_component, ...
                            'slice_dir', 'z', ...
                            'slice_index', round(dims(3)/2));
    end
   
