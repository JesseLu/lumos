
function [opt_prob, design_area] = wgconv(varargin)

    omega = 2 * pi / 40;

    modes(1) = model_I(omega, io(1, 'te0', 1), io(2, 'te0', [0.9 2]), varargin{:});
    
%     modes(2) = model_I(omega, io(2, 'tm0', 1), ...
%                             {io(2, 'tm0', [0 0.1]), ...
%                             io(1, 'tm0', [0.9 1])}, varargin{:});

    %% Translate
    [opt_prob, J, E_out] = translation_layer(modes, @solve_local);

    design_area = modes(1).design_area;
