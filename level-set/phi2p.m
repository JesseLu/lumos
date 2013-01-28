%% phi2p
% Transform level-set representation to density (or parameter) representation.

%% Description
% Calculates each grid points distance to the border and uses that
% as an approximate density value.

function [p, phi] = phi2p(phi, p_lims)

    d_tot = dist_to_border(phi);

    %% Produce p.

    p_raw = d_tot .* (-1 * (phi < 0) + 1 * (phi > 0));
    p = (max(p_lims) - min(p_lims))/2 * (p_raw + 1) + min(p_lims);
end
