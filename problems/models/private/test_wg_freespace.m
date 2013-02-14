%% test_wg_freespace
% Not a bona fide test script as usual,
% just helps to see which modes are really confined under certain conditions.

function test_wg_freespace(type, mode_num, varargin)

%% Output parameters
% Fills in everything for mode structures, except for the in and out fields.
% At the same time, make the in and out fields easier to specify.


    if strcmp('2D', varargin)
        flatten = true;
    else
        flatten = false;
    end

    len = 30;
    if flatten
        dims = [len 1 1];
    else
        dims = [len len 1];
    end

    omega = 2 * pi / 38.75;
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

        deg_breaker = struct('type', 'rectangle', ...
                        'position', [0 0], ...
                        'size', [1 1e9], ...
                        'permittivity', eps_lo+1e-3);
    epsilon = add_planar(epsilon, 1, 1e9, {background, deg_breaker});

%     for k = 1 : 3
%         subplot(2, 3, k);
%         imagesc(abs(squeeze(epsilon{k}(:,:,round(dims(3)/2))))'); 
%         axis equal tight;
%         subplot(2, 3, 3+k);
%         imagesc(abs(squeeze(epsilon{k}(:,round(dims(2)/2),:)))'); 
%         axis equal tight;
%     end
%     pause
%     [wg{1}, ports{1}] = wg_lores(epsilon, type, 'x+', 1e9, ... 
%                                     [dims(1)/2 dims(2)/2 z_center]);


  
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
        imagesc(abs(squeeze(E{k}(:,:,round(z_center))))'); 
        axis equal tight;
        colorbar;
        title(title_text{k});
    end
