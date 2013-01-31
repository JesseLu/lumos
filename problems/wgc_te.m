
function [opt_prob, vis_options, design_area] = wgconv(varargin)

    omega = 2 * pi / 40;

    in = io(1, 'te0', 1);
    out = {io(2, 'te1', [0.9 2]), io(2, 'te0', [0 0.01])};
    % out = io(2, 'te1', [0.9 2]);
    modes(1) = model_I(omega, {'single', 'double'}, in, out, varargin{:});
    % modes(2) = model_I(omega, {'single', 'double'}, in, out, varargin{:});
    
%     modes(2) = model_I(omega, io(2, 'tm0', 1), ...
%                             {io(2, 'tm0', [0 0.1]), ...
%                             io(1, 'tm0', [0.9 1])}, varargin{:});

    %% Translate
    [opt_prob, J, E_out] = translation_layer(modes, @solve_local);

 
    % TODO: need to output this from the problem.
    % TODO: enable individual components for vis_layer.
    vis_options.mode_sel = 1 : length(opt_prob.phys_res);
    vis_options.vis_layer = struct( 'component', 2, ...
                                    'slice_dir', 'z', ...
                                    'slice_index', 1);

   design_area = modes(1).design_area;
