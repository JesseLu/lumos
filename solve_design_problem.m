%% solve_design_problem
% Master function for solving the nanophotonic design problems.

%% Description
% Solves the problem specified, and accepts override inputs as well.

function [vis_result] = solve_design_problem(gen_problem, varargin)

    opt_prob = gen_problem(varargin{:});
    opt_prob

    %% Specify structure design objective 
    % Otherwise known as the parameterization of z.
    struct_obj = struct('m', @(p) p, ...
                        'w', @(p) 0e-5 * sum(-p(:)), ...
                        'p_range', ones(opt_prob.z_len, 1) * [0 1], ...
                        'scheme', 'continuous-linear');


    %% Get options

    % Default options structure.

    % Override.

    %% Solve.

    %% Optimize
    p0 = mean(struct_obj.p_range, 2);
    mode_sel = 1 : length(opt_prob.phys_res);
    vis_layer = struct( 'component', 2, ...
                        'slice_dir', 'z', ...
                        'slice_index', 1);

    paradigm = 'global';
    num_iters = 40;
    err_thresh = 1e-3;

    options = struct(   'paradigm', paradigm, ...
                        'starting_iter', 1, ...
                        'num_iters', num_iters, ...
                        'err_thresh', err_thresh, ...
                        'paradigm_args', {{'t', 1e6, ...
                            'newton_err_thresh', 1e-3, ...
                            'vis_progress', ...
                            @(progress) vis_newton_progress(progress, mode_sel)}}, ...
                        'structure_args', {{}}, ...
                        'state_file', 'ex2D_state.mat', ...
                        'history_file', 'ex2D_history.h5', ...
                        'vis_progress', @(k, x, z, p, progress) ...
                            track_progress(opt_prob, struct_obj, vis_layer, ...
                                            mode_sel, k, x, z, p, progress) ...
                        );

%     if ~isempty(varargin)
%         opt_state = load(varargin{1});
%         opt_prob = opt_state.opt_prob;
%         struct_obj = opt_state.g;
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

    [z, p, state] = run_optimization(opt_prob, struct_obj, p0, options, ...
                                        state, progress);


    %% Visualize.
    vis_result = @() track_progress(opt_prob, struct_obj, vis_layer, ...
                                    mode_sel, [], [], z, p);


