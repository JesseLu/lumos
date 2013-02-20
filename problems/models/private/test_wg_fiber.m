%% test_wg_fiber
% Not a bona fide test script as usual,
% just helps to see which modes are really confined under certain conditions.

function [E] = test_wg_fiber(type, mode_num, varargin)

%% Output parameters
% Fills in everything for mode structures, except for the in and out fields.
% At the same time, make the in and out fields easier to specify.


    if strcmp('2D', varargin)
        flatten = true;
    else
        flatten = false;
    end

    len = 120;
    if flatten
        dims = [len len 1];
    else
        dims = [len len 40];
    end

    omega = 2 * pi / 32.75;
    eps_lo = 2.25;
    eps_hi = 2.56;
    z_center = dims(3)/2;
    z_thickness = 250 / 40;

    mu = {ones(dims), ones(dims), ones(dims)};
    [s_prim, s_dual] = stretched_coordinates(omega, dims, [0 0 0]);

    %% Construct structure
    epsilon = {eps_lo*ones(dims), eps_lo*ones(dims), eps_lo*ones(dims)};
    background = struct('type', 'rectangle', ...
                        'position', [0 0], ...
                        'size', [1e9 1e9], ...
                        'permittivity', eps_lo);

    r = 25;
    wg = {struct('type', 'circle', ...
                'position', [0 -1], ...
                'radius', r, ...
                'permittivity', eps_hi), ...
        struct('type', 'circle', ...
                'position', [0 +1], ...
                'radius', r, ...
                'permittivity', eps_hi)};

%     [wg{1}, ports{1}] = wg_lores(epsilon, type, 'x+', 1e9, ... 
%                                     [dims(1)/2 dims(2)/2 z_center]);


    epsilon = add_planar(epsilon, z_center, z_thickness, {background, wg{:}});
  
    [beta, E, H, J] = solve_waveguide_mode(omega, s_prim, s_dual, ...
                                        mu, epsilon, ...
                                        {[1 1 1], [dims(1) dims(2) 1]}, ...
                                        'z-', mode_num);

%     [beta, E, H, J] = solve_waveguide_mode(omega, s_prim, s_dual, ...
%                                         mu, epsilon, ...
%                                         {[15 1 1], [15 dims(2) dims(3)]}, ...
%                                         'x+', mode_num);
    beta
    title_text = {'Ex', 'Ey', 'Ez'};
    for k = 1 : 3
        subplot(3, 1, k);
        data = abs(squeeze(E{k}(:,:,round(z_center))));
        imagesc(data', max(abs(data(:))) * [-1 1]); 
        axis equal tight;
        colorbar;
        title(title_text{k});
    end

    
