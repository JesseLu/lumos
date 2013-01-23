%% test_wg_lores
% Not a bona fide test script as usual,
% just helps to see which modes are really confined under certain conditions.

function test_wg_lores(type, mode_num)

%% Output parameters
% Fills in everything for mode structures, except for the in and out fields.
% At the same time, make the in and out fields easier to specify.

    omega = 2 * pi / 40;
    dims = [60 40 40];
    eps_lo = 2.25;
    eps_hi = 13;
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

    [wg{1}, ports{1}] = wg_lores(epsilon, type, 'x+', 1e9, ... 
                                    [dims(1)/2 0 z_center]);


    epsilon = add_planar(epsilon, z_center, z_thickness, {background, wg{:}});
 
    [beta, E, H, J] = solve_waveguide_mode(omega, s_prim, s_dual, ...
                                        mu, epsilon, ...
                                        {[15 1 1], [15 dims(2) dims(3)]}, ...
                                        'x+', mode_num);

    beta
    title_text = {'Ex', 'Ey', 'Ez'};
    for k = 1 : 3
        subplot(3, 1, k);
        imagesc(abs(squeeze(E{k}(15,:,:)))'); 
        axis equal tight;
        colorbar;
        title(title_text{k});
    end