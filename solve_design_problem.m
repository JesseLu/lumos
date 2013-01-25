%% solve_design_problem
% Master function for solving the nanophotonic design problems.

%% Description
% Solves the problem specified, and accepts override inputs as well.

function [vis_result, p] = solve_design_problem(gen_problem, p0, varargin)

    [opt_prob, design_area] = gen_problem(varargin{:});

    %% Specify structure design objective 
    % Otherwise known as the parameterization of z.
    struct_obj{1} = struct( 'm', @(p) p, ...
                            'w', @(p) 0, ...
                            'p_range', ones(opt_prob.z_len, 1) * [0 1], ...
                            'scheme', 'continuous-linear');

%     vec = @(u) u(:);
%     unvec = @(u) reshape(u, design_area);
%     get_phi = @(p) vec(p_to_phi(unvec(p), [0 1]));
%     struct_obj{2} = struct( 'm', @(phi) vec(phi_to_p(unvec(phi), [0 1])), ...
%                             'w', @(phi) 0, ...
%                             'p_range', ones(opt_prob.z_len, 1) * [-1 1], ...
%                             'scheme', 'continuous');
% 
% 
% 
%     p0 = get_phi(p0);
%     imagesc(unvec(p0))
%     pause
    g = struct_obj{1};


    %% Get options

    % Default options structure.

    % Override.

    %% Solve.

    %% Optimize
    if isempty(p0)
        % p0 = mean(sqrt(g.p_range), 2).^2;
        % p0 = randn(size(g.p_range, 1), 1);
        p0 = max(g.p_range, [], 2);
    elseif numel(p0) == 1
        p0 = p0 * ones(size(g.p_range, 1), 1);
    end

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
                            track_progress(opt_prob, g, vis_layer, ...
                                            mode_sel, k, x, z, p, progress) ...
                        );

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

    [z, p, state] = run_optimization(opt_prob, g, p0, options, ...
                                        state, progress);


    %% Visualize.
    vis_result = @() track_progress(opt_prob, g, vis_layer, ...
                                    mode_sel, [], [], z, p);


