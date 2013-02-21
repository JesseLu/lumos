%% visualize_design_run
% Create plots and images to visualize how a design run proceeded

% name is the name of the results directory.
function visualize_design_run(name)

    % Separate into problem and recipe names.
    ind = strfind(name, '_');
    ind = ind(end);
    problem_name = name(1:ind-1);
    recipe_name = name(ind+1:end);

    % Detect the 2D option.
    if ~isempty(strfind(problem_name, '2D'))
        flatten_option = true;
        exec_problem_name = strrep(problem_name, '2D', '');  
    else 
        flatten_option = false;
        exec_problem_name = problem_name;
    end

    % Detect the 'verify' recipe
    if strcmp(recipe_name, 'verify')
        problem_size = 'large';
        clip = 13;
    else
        problem_size = 'small';
        clip = 0;
    end


    % Function handle for generating the problem.
    gen_problem = eval(['@', exec_problem_name]);


    subplot 111;
    name = [problem_name, '_', recipe_name];
    run_dir = [results_dir(), name, filesep];
    vis_dir = [visuals_dir(), name, filesep];

    if isdir(vis_dir)
        rmdir(vis_dir, 's'); % Recursive remove.
    end
    mkdir(vis_dir);


    state_files = dir([run_dir, '*_state.mat']);
    history_files = dir([run_dir, '*_history.h5']);

    %% Plot data from state file.

    % Get the "verify" type problem.
    problem = gen_problem({'flatten', flatten_option, ...
                            'S_type', 'average', ...
                            'size', problem_size});

    for f = {state_files.name}
        % Progress data.
        data = load([run_dir, f{1}], 'progress');
        progress = data.progress;
        step_name = strrep(f{1}, '_state.mat', '');
        my_saveplot(@semilogy, progress.res_norm, 'physics residual', ...
                    [vis_dir, 'res_', step_name]);
        my_saveplot(@plot, progress.out_power, 'output powers', ...
                    [vis_dir, 'pow_', step_name], [0 1]);

        % Run verification layer to get epsilon and E.
        data = load([run_dir, f{1}], 'z', 'state');
        modes = verification_layer(problem.opt_prob, data.z, data.state.x);

        % Plot epsilon and field data.
        my_vis_state(vis_dir, step_name, modes, clip);

        % Save epsilon data.
        
    end

%     %% Plot the history data.
%     a=1
%     dataset_names = {   @(mode_num) ['/E', num2str(mode_num), '_abs'], ...
%                         @(mode_num) ['/E', num2str(mode_num), '_real'], ...
%                         @(mode_num) ['/E', num2str(mode_num), '_imag'], ...
%                         @(mode_num) ['/eps', num2str(mode_num), '_abs']};
% 
%     map = { colormap('hot'), ...
%             colormap('jet'), ...
%             colormap('jet'), ...
%             flipud(colormap('bone'))};
% 
%     lims = {[], [], [], [2.25 12.25]};
% 
%     xyz = 'xyz';
% 
%     image_names = @(file, dset, comp, iter) ...
%                         [vis_dir, dset, '_', xyz(comp), '_', ...
%                         strrep(file, '_history.h5', ''),  ...
%                         '_', sprintf('%03d', iter)];
% 
%     for f = {history_files.name}
%         % Get the correct step file.
%         file = [run_dir, f{1}];
%         history_info = h5info(file, '/');
%         
%         num_modes = (length({history_info.Datasets.Name})/3 - 2) / 3;
%         for i = 1 : num_modes
%             % Collect everything to be plotted.
%             dataset_info = h5info(file, ['/E', num2str(i), '_abs']);
%             dsize = dataset_info.Dataspace.Size;
%             dims = dsize(1:3);
%             num_iters = dsize(5);
% 
%             % Plot (nearly) everything.
%             for iter = 1 : num_iters
%                 for set = 1 : length(dataset_names)
%                     for comp = 1 : 3
%                         dataset_name = dataset_names{set}(i);
%                         data = h5read(file, dataset_name, ...
%                                         [1 1 1 comp iter], [dims 1 1]);
%                         data = data(:,:,round(dims(3)/2));
%                         image_name = ...
%                             image_names(f{1}, dataset_name(2:end), ...
%                                         comp, iter);
%                         my_saveimage(squeeze(data), map{set}, lims{set}, image_name);
%                     end
%                 end
%             end
%         end
% 
%     end
end

function my_vis_state(dir, step_name, modes, clip)

    my_shot = @(data, comp, func, slice, map, lims) ...
                struct('data', data, 'comp', comp, 'func', func, ...
                    'slice', slice, 'map', map, 'lims', lims);

    shots = {my_shot('E', 2, 'abs', 'z', colormap('hot'), []), ...
            my_shot('E', 3, 'abs', 'z', colormap('hot'), []), ...
            my_shot('epsilon', 3, 'abs', 'z', flipud(colormap('bone')), ...
                    [2.25 12.25])};

    xyz = 'xyz';

    image_names = @(dset, comp) [vis_dir, dset, '_', xyz(comp), '_', step_name];
    for i = 1 : length(modes) 
        mode = modes(i);
        for j = 1 : length(shots)
            s = shots{j};
            func = eval(['@', s.func]);
            data = func(mode.(s.data){s.comp});
            ind = round(size(data)/2);
            switch s.slice
                case 'x'
                    data = data(ind(1),:,:);
                case 'y'
                    data = data(:,ind(2),:);
                case 'z'
                    data = data(:,:,ind(3));
            end

            image_name = [dir, s.data, num2str(i), xyz(s.comp), ...
                            s.func, s.slice, '_', step_name];
            my_saveimage(squeeze(data), s.map, s.lims, image_name, clip);
        end
    end
end

function my_saveimage(z, map, lims, filename, varargin)
% Write out a mapped image.

    if ~isempty(varargin)
        clip = varargin{1};
        dims = size(z);
        z = z(1+clip:dims(1)-clip, 1+clip:dims(2)-clip);
    end

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
    plotfun(1:size(z,1), z, 'b.-', 'linewidth', 6);

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


function [dims] = vis_3D_epsilon(A, mat_index, skim, alpha)
    s = skim+1;
    dims = size (A);
    A = A(:,dims(2):-1:1,:);
    A([1:s, dims(1)-(s+1):dims(1)],:,:) = 0;
    A(:,[1:s, dims(2)-(s+1):dims(2)],:) = 0;

    order = [2 1 3];
    v = permute (A, order);
    dims = size (v);
    [x y z] = meshgrid (1:dims(2), 1:dims(1), 1:dims(3));

    hpatch = patch(isosurface(x,y,z,v, mat_index));
    isonormals(x,y,z,v,hpatch)
    set(hpatch,'FaceAlpha', alpha, 'FaceColor',120*[1 1 1]./255,'EdgeColor','none')

    my_make_pretty(dims);

function my_make_pretty (dims)
    grid on
    daspect([1,1,1])
    axis tight
    camlight left; lighting phong
    % make it more visually intuitive
    axis tight
    axis ([0 dims(2) 0 dims(1) 0 dims(3)]);
    H = gcf; % get the current figure handle
    % set (H, 'WindowStyle', 'normal', 'OuterPosition', [100 100 640 480] + [0 0 10 29], 'MenuBar', 'none', 'ToolBar', 'none'); % set the location and size of the window
    set (H, 'WindowStyle', 'docked');
    view(0, 45);
    grid off;




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
