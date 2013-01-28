%% phi2p
% Transform level-set representation to density representation.

%% Description
%

function [p, phi] = phi2p(phi, p_lims, varargin)

    if isempty(varargin)
        closure_shift = 0.0 * [1 -1];
    else
        closure_shift = varargin{1};
    end

    phi = smooth_phi(phi, closure_shift);

    d_tot = dist_to_border(phi);

    %% Produce p.

    p_raw = d_tot .* (-1 * (phi < 0) + 1 * (phi > 0));
    p = (max(p_lims) - min(p_lims))/2 * (p_raw + 1) + min(p_lims);

    % % Graph result.
    % lset_plot(phi)
    % hold on
    % contour(p', [0 0], 'g-', 'LineWidth', 3);
    % hold off
end
