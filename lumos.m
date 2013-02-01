%% lumos
% Primary function for solving the nanophotonic design problems.

%% Description
% Solves the problem specified, using the parameterization and 
% paradigm desired.

function [z, p, vis_result] = lumos(gen_problem, paradigm, param_type, ...
                                p0, num_iters, err_thresh, varargin)

    %% Generate the problem
    % This includes the physics residual and field design objectives,
    % as well as many other details.
    [opt_prob, vis_options, design_area] = gen_problem();


    %% Set paradigm 
    % Can be either 'global' or 'local'.

    function [progress_out, x] = my_track_progress(k, x, z, p, progress)
        [progress_out, x] = track_progress(opt_prob, struct_obj, ...
                                            vis_options.vis_layer, ...
                                            vis_options.mode_sel, ...
                                            k, x, z, p, progress);
    end

    options = struct('paradigm', paradigm, ...
                    'starting_iter', 1, ...
                    'num_iters', num_iters, ...
                    'err_thresh', err_thresh, ...
                    'state_file', 'ex2D_state.mat', ...
                    'history_file', 'ex2D_history.h5', ...
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
                                    'kappa_shrink_rate', 0.5};

        options.structure_args = {  'step_err', 1e-4, ...
                                    'err_thresh', 1e-3, ...
                                    'tidyup_p', tidyup_p};
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
        options.structure_args.tidyup_p = @(p) p;

    elseif strcmp(param_type, 'level-set') % Level-set parameterization.
        struct_obj = struct('m', @(p) vec(phi2p(unvec(p), [0 1])), ...
                            'w', @(p) 0, ...
                            'p_range', ones(opt_prob.z_len, 1) * [-1 1], ...
                            'scheme', 'continuous');
        options.structure_args.tidyup_p = @(p) vec(smooth_phi(unvec(p), 0));
    else
        error('Invalid type of parameterization');
    end



    if isempty(p0)
        p0 = max(struct_obj.p_range, [], 2);
    elseif numel(p0) == 1
        p0 = p0 * ones(size(struct_obj.p_range, 1), 1);
    end

%     if ~isempty(varargin)
%         opt_state = load(varargin{1});
%         opt_prob = opt_state.opt_prob;
%         g = opt_state.g;
%         p0 = opt_state.p;
%         options = opt_state.options;
%         options.starting_iter = opt_state.k + 1;
%         options.num_iters = num_iters;
%         state = opt_state.state;
%         progress = opt_state.progress;
%     else
%         state = [];
%         progress = [];
%     end
        state = [];
        progress = [];

    %% Optimize
    [z, p, state] = run_optimization(opt_prob, struct_obj, p0, options, ...
                                        state, progress);


    %% Visualize.
    vis_result = @() track_progress(opt_prob, struct_obj, ...
                                    vis_options.vis_layer, ...
                                    vis_options.mode_sel, [], [], z, p);

end

