%% phi2p
% Transform level-set representation to density representation.

%% Description
%

function [p] = phi2p(phi, varargin)

    d_tot = dist_to_border(phi);

    %% Produce p.

    if ~isempty(varargin)
        p_lims = varargin{1};
        p_raw = d_tot .* (-1 * (phi < 0) + 1 * (phi > 0));
        p = (max(p_lims) - min(p_lims))/2 * (p_raw + 1) + min(p_lims);
    else 
        p = nan;
    end

    % % Graph result.
    % lset_plot(phi)
    % hold on
    % contour(p', [0 0], 'g-', 'LineWidth', 3);
    % hold off
end
