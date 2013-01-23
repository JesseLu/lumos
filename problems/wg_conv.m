
function [epsilon] = wgconv()

    dims = [60 60 40];
    eps_lo = 2.25;
    eps_hi = 13;
    z_center = dims(3)/2;
    z_thickness = 220 / 40;
    omega = 2 * pi / 40;

    mu = {ones(dims), ones(dims), ones(dims)};
    epsilon = {eps_lo*ones(dims), eps_lo*ones(dims), eps_lo*ones(dims)};
    [s_prim, s_dual] = stretched_coordinates(omega, dims, [10 10 10]);

    pos = nan;
    len = nan;
    l_port = struct('size', 'small', ...
                    'dir', 'x', ...
                    'loc', pos, ...
                    'length', len);

    % Build the selection matrix, and reset values of epsilon.
    reset_eps_val = eps_hi;
    border = 13;
    [S, epsilon] = planar_selection_matrix('alternate', epsilon, ...
                                    {border + [1 1], dims(1:2) - border}, ...
                                    reset_eps_val, z_center, z_thickness);


