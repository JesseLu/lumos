%% init_phi
% Convert a density representation to a level-set representation
% of a structure.

%% Description
%

function [phi] = init_phi(p, p_lims, sdf_err, closure)

    function [phi] = my_smooth_phi(phi)
        phi = signed_distance(phi, sdf_err);
        phi = smooth_phi(phi, closure);
        phi = signed_distance(phi, sdf_err);
    end

    %% Bisect until we replicate the sum of p.

    % Find the sum.
    p_sum = sum(p(:));

    % Initialize bisection algorithm.
    max_level = max(p_lims);
    min_level = min(p_lims);

    for k = 1 : 1e3
        level = mean([max_level, min_level]); % Obtain new level.

        % Bisect.
        phi_curr = my_smooth_phi(p - level);
        [p_curr, phi] = phi2p(phi_curr, p_lims); % Obtain transformed p.
        err = sum(p_curr(:)) - p_sum; % Calculate error.
        percent_err = abs(err) / abs(p_sum);

        if err < 0
            max_level = level;
        else
            min_level = level;
        end

        % Check termination condition.
        if percent_err < 1e-3 || ...
            (max_level - min_level < 1e-6 * (max(p_lims) - min(p_lims)))
            break 
        end
    end
    
%     % Obtain optimal phi.
%     phi_curr = my_smooth_phi(p - level);
%     [~, phi] = phi2p(phi_curr);
end
