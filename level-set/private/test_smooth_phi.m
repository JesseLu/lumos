%% test_smooth_phi
% Can we still get a gradient?

function [g] = test_smooth_phi(phi, p_lims, shift_distances)

    vec = @(u) u(:);
    unvec = @(u) reshape(u, size(phi));
    fun0 = @(u) sum(vec(phi2p(smooth_phi(unvec(u), shift_distances), p_lims)));
    fun1 = @(u) sum(vec(phi2p(unvec(u), p_lims)));

    tic;
    grad0 = get_gradient(fun0, vec(phi));
    toc

    tic;
    grad1 = get_gradient(fun1, vec(phi));
    toc

    subplot 131; 
    imagesc(unvec(grad0)'); axis equal tight;
    hold on;
    contour(phi', [0 0], 'r-', 'LineWidth', 3);
    hold off;

    subplot 132; 
    imagesc(unvec(grad1)'); axis equal tight;
    hold on;
    contour(phi', [0 0], 'r-', 'LineWidth', 3);
    hold off;

    subplot 133; 
    imagesc(unvec(grad1 - grad0)'); axis equal tight;
    hold on;
    contour(phi', [0 0], 'r-', 'LineWidth', 3);
    hold off;

    g = {unvec(grad0)', unvec(grad1)'};
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

