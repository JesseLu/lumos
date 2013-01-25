%% smooth_phi
% Take out kinks...

function [phi] = smooth_phi(phi, shift_distances)

    % regularize = @(phi) clamp_phi(signed_distance(phi, 1e-3));

    phi = my_clamp_phi(phi);
    for sd = shift_distances
        phi = phi + sd;
        phi = my_clamp_phi(phi);
    end
    % phi = regularize(phi);
end


function [phi] = my_clamp_phi(phi)

    % d_tot = dist_to_border(phi);
    on_border = my_border_detect(phi);

    % Produce a clamped phi.
    % For values that are not on a border, clamp at -1 or +1.

    phi = (on_border) .* phi + ...
            (~on_border) .* (-1 * (phi < 0) + 1 * (phi > 0));
end


function [on_border] = my_border_detect(phi)
% Detect which grid points actually affect the border.
% This is a copy (mostly) of the first part of dist_to_border.

    dims = size(phi);
    
    %% Get the contour.
    c = contourc(phi, [0 0]);

    % Delete the level-pairs headers (see contourc documentation).
    ind = find(c(1,:) == 0);
    c(:,ind) = [];

    % Put x-values on first row, and y-values on second row.
    c = flipud(c);

    
    % Find the x and y grid-intercepts.

    rc = rem(c, 1); % The remainder when divided by 1.
    x_int = find(rc(2,:) == 0); % These points are x-intercepts.
    y_int = find(rc(1,:) == 0); % These points are y-intercepts.

    % Mark distances to contour from left, right, top, and bottom.
    on_border_subs = [floor(c(1,x_int))', c(2,x_int)'; ...
                        ceil(c(1,x_int))', c(2,x_int)'; ...
                        c(1,y_int)', floor(c(2,y_int))'; ...
                        c(1,y_int)', ceil(c(2,y_int))'];

    on_border_inds = sub2ind(dims, on_border_subs(:,1), on_border_subs(:,2));

    on_border = false * ones(dims);
    on_border(on_border_inds) = true;
end



