%% p_to_phi
% Convert a density representation to a level-set representation
% of a structure.

%% Description
%

function [phi] = p_to_phi(p, p_lims, varargin)

    %% Bisect until we replicate the sum of p.

    % Find the sum.
    p_sum = sum(p(:));

    % Initialize bisection algorithm.
    max_level = max(p_lims);
    min_level = min(p_lims);

    for k = 1 : 1e3
        level = mean([max_level, min_level]); % Obtain new level.

        % Check termination condition.
        if max_level - min_level < 1e-3 * (max(p_lims) - min(p_lims))
            break 
        end

        % Bisect.
        p_curr = phi_to_p(p - level, p_lims); % Obtain transformed p.
        err = sum(p_curr(:)) - p_sum; % Calculate error.

        if err < 0
            max_level = level;
        else
            min_level = level;
        end
    end
    
    % Obtain optimal phi.
    [~, phi] = phi_to_p(p - level, p_lims);
end
