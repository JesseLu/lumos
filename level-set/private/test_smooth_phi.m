%% test_smooth_phi
% Can we still get a gradient?

function [grad] = test_smooth_phi(phi, p_lims, shift_distances)

    vec = @(u) u(:);
    unvec = @(u) reshape(u, size(phi));
    fun = @(u) sum(vec(phi2p(unvec(u), p_lims)));

    grad = get_gradient(fun, vec(phi));

    imagesc(unvec(grad)'); axis equal tight;
    hold on;
    contour(phi', [0 0], 'r-', 'LineWidth', 3);
    hold off;
end



function [grad] = get_gradient(fun, u0, varargin)

    if isempty(varargin)
        delta = 1e-6;
    else
        delta = varargin{1};
    end

    f0 = fun(u0);
    for k = 1 : length(u0)
        du = zeros(length(u0), 1);
        du(k) = 1;
        grad(:,k) = sparse(1./delta * (fun(u0 + delta * du) - f0));
    end
end

