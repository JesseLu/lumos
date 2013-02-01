%% lumos
% Primary function for solving the nanophotonic design problems.

%% Description
% Solves the problem specified, using the parameterization and 
% paradigm desired.

function [z, p, vis_result] = lumos(name, problem, paradigm, param_type, ...
                                p0, term_conds, varargin)

    %% Parse inputs.
    if length(term_conds) == 1
        num_iters = term_conds(1);
        err_thresh = nan;

    elseif length(term_conds) == 2
        num_iters = term_conds(1);
        err_thresh = term_conds(2);
 
    else
        error('Could not understand termination conditions.');
    end

    %% Parse optional parameters.
    lumos_options = struct( 'restart', false);
    for k = 2 : 2 : length(varargin)
        lumos_options = setfield(lumos_options, varargin{k-1}, varargin{k});
    end

    %% Generate the problem
    % This includes the physics residual and field design objectives,
    % as well as many other details.
    opt_prob = problem.opt_prob;
    vis_options = problem.vis_options;
    design_area = problem.design_area;


    %% Set paradigm 
    % Can be either 'global' or 'local'.

    function [progress_out, x] = my_track_progress(k, x, z, p, progress)
        [progress_out, x] = track_progress(opt_prob, struct_obj, ...
                                            vis_options.vis_layer, ...
                                            vis_options.mode_sel, ...
                                            k, x, z, p, progress);
        saveas(gcf, [results_folder(), name, '_', sprintf('%04d', k)], 'png');
    end

    options = struct('paradigm', paradigm, ...
                    'starting_iter', 1, ...
                    'num_iters', num_iters, ...
                    'err_thresh', err_thresh, ...
                    'vis_progress', @my_track_progress);

    if strcmp(paradigm, 'global')
        my_vis_newton_progress = @(progress) vis_newton_progress(progress, ...
                                                    vis_options.mode_sel);
        
        options.paradigm_args =  {  't_vals', 1e3, ...
                                    'newton_err_thresh', 1e-6, ...
                                    'newton_max_steps', 6, ...
                                    'dynamic_phi', false, ...
                                    'vis_progress', my_vis_newton_progress}; 

        options.structure_args = {};

    elseif strcmp(paradigm, 'local')
        options.paradigm_args = {   'initial_kappa', 1e0, ...
                                    'kappa_growth_rate', 1.3, ...
                                    'kappa_shrink_rate', 0.3};

        options.structure_args = {  'step_err', 1e-4, ...
                                    'err_thresh', 1e-3};
    else
        error('Invalid paradigm.');
    end



    %% Specify the parameterization
    % This includes the structure design objective.
    
    % Helper functions needed for the level-set parameterization.
    function [u] = vec(u)
        u = u(:);
    end

    function [u] = unvec(u)
        u = reshape(u, design_area);
    end

    if strcmp(param_type, 'density') % Density parameterization.
        struct_obj = struct('m', @(p) p, ...
                            'w', @(p) 0, ...
                            'p_range', ones(opt_prob.z_len, 1) * [0 1], ...
                            'scheme', 'continuous-linear');
        options.structure_args = [options.structure_args, ...
                                    {'tidyup_p', @(p) p}];

    elseif strcmp(param_type, 'level-set') % Level-set parameterization.
        struct_obj = struct('m', @(p) vec(phi2p(unvec(p), [0 1])), ...
                            'w', @(p) 0, ...
                            'p_range', ones(opt_prob.z_len, 1) * [-1 1], ...
                            'scheme', 'continuous');
        options.structure_args = [options.structure_args, ...
                            {'tidyup_p', @(p) vec(smooth_phi(unvec(p), 0))}];
    else
        error('Invalid type of parameterization');
    end


    %% Get initial parameterization values

    if isempty(p0)
        p0 = max(struct_obj.p_range, [], 2);
    elseif numel(p0) == 1
        p0 = p0 * ones(size(struct_obj.p_range, 1), 1);
    end

    %% Take care of restart, if necessary
    options.state_file = [results_folder(), name, '_state.mat'];
    options.history_file = [results_folder(), name, '_history.h5'];

    if lumos_options.restart
        opt_state = load(options.state_file);
        p0 = opt_state.p;
        options.starting_iter = opt_state.k + 1;
        state = opt_state.state;
        progress = opt_state.progress;
    else
        state = [];
        progress = [];
    end

    %% Optimize
    [z, p, state, progress] = run_optimization(opt_prob, struct_obj, p0, ...
                                                options, state, progress);


    %% Visualize.
    vis_result = @() my_track_progress([], [], z, p, progress);

end

