%% visualize_design_run
% Create plots and images to visualize how a design run proceeded

function visualize_design_run(name)
    subplot 111;
    run_dir = [results_dir(), name, filesep];
    vis_dir = [visuals_dir(), name, filesep];

    if isdir(vis_dir)
        rmdir(vis_dir, 's'); % Recursive remove.
    end
    mkdir(vis_dir);


    state_files = dir([run_dir, '*_state.mat']);
    history_files = dir([run_dir, '*_history.h5']);

%     % Plot the progress data.
%     for f = {state_files.name}
%         data = load([run_dir, f{1}], 'progress');
%         progress = data.progress;
%         my_saveplot(@semilogy, progress.res_norm, 'physics residual', ...
%                     [vis_dir, 'pow_', strrep(f{1}, '_state.mat', '')]);
%         my_saveplot(@plot, progress.out_power, 'output powers', ...
%                     [vis_dir, 'res_', strrep(f{1}, '_state.mat', '')], [0 1]);
%     end

    % Plot the history data.
    for f = {history_files.name}
        history_info = h5info([run_dir, f{1}], '/');
        num_modes = (length({history_info.Datasets.Name})/3 - 2) / 3;
        num_modes
        % a = h5read([run_dir, f{1}], 
        size(a)
        break
    end

end

function my_saveimage(z, map, lims, filename)
    % Write out a mapped image.
    z = (((z)-lims(1)) / diff(lims) * 63) + 1;
    z = 1 * (z < 1) + 64 * (z > 64) + z .* ((z >= 1) & (z <= 64));
    imwrite(z', map, [filename, '.png']);
    imwrite([64:-1:1]', map, ['zbar_', filename, '.png']); % Colorbar.
end


function my_saveplot(plotfun, data, ylabeltext, filename, varargin)
    % Compile all the data together.
    z = [];
    for i = 1 : length(data) % Put all the modes together.
        z = cat(1, z, data{i});
    end
    z = z';

    % Plot.
    plotfun(z, 'b.-');

    % Change axis if needed.
    if ~isempty(varargin)
        a = axis;
        a(3:4) = cell2mat(varargin);
        axis(a);
    end

    % Add text.
    ylabel(ylabeltext);
    xlabel('iterations');
    set(findall(gcf, 'type', 'text'), 'fontSize', 16);
    set(gca, 'fontSize', 14);

    % Save to file.
    print('-dpng', '-r60', filename);
end



        % colormap for epsilon.
        % cmap = flipud(colormap('bone'));

        % colormap for E
        % use 'hot' for amplitude.
        % use custom red/blue for field? or maybe just jet...



% %% How to make a gif
% set(gca,'nextplot','replacechildren','visible','off')
% f = getframe;
% [im,map] = rgb2ind(f.cdata,256,'nodither');
% im(1,1,1,20) = 0;
% for k = 1:20 
%   surf(cos(2*pi*k/20)*Z,Z)
%   f = getframe;
%   im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
% end
% imwrite(im,map,'DancingPeaks.gif','DelayTime',0,'LoopCount',inf) %g443800
