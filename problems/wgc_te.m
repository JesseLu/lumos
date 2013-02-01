
function [problem] = wgc_te(varargin)

    omega = 2 * pi / 40;

    in = io(1, 'te0', 1);
    out = {io(2, 'te1', [0.9 1]), io(2, 'te0', [0 0.01])};

    modes = [];
    vis_layer = [];

    [modes(end+1), vis_layer(end+1)] = ...
        model_I(omega, {'single', 'double'}, in, out, varargin{:});


    %% Translate
    % [opt_prob, J, E_out] = translation_layer(modes, @solve_local);
    opt_prob = get_opt_prob(modes, true);

 
    % TODO: need to output this from the problem.
    % TODO: enable individual components for vis_layer.
    vis_options.mode_sel = 1 : length(opt_prob.phys_res);
    vis_options.vis_layer = vis_layer;
%     vis_options.vis_layer = struct( 'component', 2, ...
%                                     'slice_dir', 'z', ...
%                                     'slice_index', 1);

    % Get design_area.
    design_area = modes(1).design_area;

    % Produce the final problem structure.
    problem = struct('opt_prob', opt_prob, ...
                    'vis_options', vis_options, ...
                    'design_area', design_area);
