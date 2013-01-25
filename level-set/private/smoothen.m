%% smoothen
% Move by curvature.

function smoothen(phi, s)

    phi0 = phi;
    subplot 133; plot_level_set(phi0, [0 1]); colorbar
    for k = 1 : 1e4
        if mod(k, 40) == 0
            subplot 131; plot_level_set(phi, [0 1], 'curvature'); colorbar
            subplot 132; plot_level_set(phi, [0 1]); colorbar
        end
        [~, dk] = compute_curvature(phi);
        fprintf('%e\n', max(dk(:)))
        phi = phi - s * dk;
        [~, phi] = phi2p(phi);
        drawnow
        % pause(0.001)
    end
