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

    %% Plot the progress data.
    for f = {state_files.name}
        data = load([run_dir, f{1}], 'progress');
        progress = data.progress;
        my_saveplot(@semilogy, progress.res_norm, 'physics residual', ...
                    [vis_dir, 'pow_', strrep(f{1}, '_state.mat', '')]);
        my_saveplot(@plot, progress.out_power, 'output powers', ...
                    [vis_dir, 'res_', strrep(f{1}, '_state.mat', '')], [0 1]);
    end

    %% Plot the history data.
    dataset_names = {   @(mode_num) ['/E', num2str(mode_num), '_abs'], ...
                        @(mode_num) ['/E', num2str(mode_num), '_real'], ...
                        @(mode_num) ['/E', num2str(mode_num), '_imag'], ...
                        @(mode_num) ['/eps', num2str(mode_num), '_abs']};

    map = { colormap('hot'), ...
            colormap('jet'), ...
            colormap('jet'), ...
            flipud(colormap('bone'))};

    lims = {[], [], [], [2.25 12.25]};

    xyz = 'xyz';

    image_names = @(file, dset, comp, iter) ...
                        [vis_dir, dset, '_', xyz(comp), '_', ...
                        strrep(file, '_history.h5', ''),  ...
                        '_', sprintf('%03d', iter)];

    for f = {history_files.name}
        % Get the correct step file.
        file = [run_dir, f{1}];
        history_info = h5info(file, '/');
        
        num_modes = (length({history_info.Datasets.Name})/3 - 2) / 3;
        for i = 1 : num_modes
            % Collect everything to be plotted.
            dataset_info = h5info(file, ['/E', num2str(i), '_abs']);
            dsize = dataset_info.Dataspace.Size;
            dims = dsize(1:3);
            num_iters = dsize(5);

            % Plot (nearly) everything.
            for iter = 1 : num_iters
                for set = 1 : length(dataset_names)
                    for comp = 1 : 3
                        dataset_name = dataset_names{set}(i);
                        data = h5read(file, dataset_name, ...
                                        [1 1 1 comp iter], [dims 1 1]);
                        image_name = ...
                            image_names(f{1}, dataset_name(2:end), ...
                                        comp, iter);
                        my_saveimage(data, map{set}, lims{set}, image_name);
                    end
                end
            end
        end

    end

end

function my_saveimage(z, map, lims, filename)
% Write out a mapped image.
    if isempty(lims)
        if all(z >= 0)
            lims = max(abs(z(:))) * [0 1];
        else
            lims = max(abs(z(:))) * [-1 1];
        end
    end

    z = (((z)-lims(1)) / diff(lims) * 63) + 1;
    z = 1 * (z < 1) + 64 * (z > 64) + z .* ((z >= 1) & (z <= 64));
    imwrite(z', map, [filename, '.png']);
    % imwrite([64:-1:1]', map, ['', filename, '.png']); % Colorbar.
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
