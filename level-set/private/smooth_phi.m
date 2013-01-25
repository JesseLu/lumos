%% smooth_phi
% Take out kinks...

function [phi] = smooth_phi(phi, shift_distances)

    regularize = @(phi) clamp_phi(signed_distance(phi, 1e-3));

    phi = regularize(phi);
    for sd = shift_distances
        phi = phi + sd;
        phi = clamp_phi(phi);
    end
    phi = regularize(phi);
end


function [phi] = clamp_phi(phi)

    d_tot = dist_to_border(phi);

    % Produce a clamped phi.
    % For values that are not on a border, clamp at -1 or +1.

    phi = (d_tot ~= 1) .* phi + ...
            (d_tot == 1) .* (-1 * (phi < 0) + 1 * (phi > 0));
end


