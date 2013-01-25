function plot_level_set(phi, p_lims, varargin)
% LSET_PLOT(PHI)
% 
% Description
%     Plot the 0-level set of PHI. Dark regions are considered "interior", while
%     light regions are considered "exterior".

    % Plot the structures.
    if isempty(varargin)
        imagesc(phi2p(phi, p_lims)', p_lims); 
    elseif strcmp(varargin, 'curvature')
        imagesc(abs(compute_curvature(phi))', [0 3]); 
    end

    % colormap('gray');
    axis equal tight; 
    set(gca, 'Ydir', 'normal');
    hold on;
    contour(phi', [0 0], 'r-', 'LineWidth', 3);
    hold off
    % drawnow;

