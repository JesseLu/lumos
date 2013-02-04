function [problem] = wgc_te(custom_model_options)

    % Choose the structure of the model (what waveguides to use where).
    model_structure = {'single', 'double'};

    N = 1; % Number of modes.

    omega{1} = 2 * pi / 40;
    in{1} = io(1, 'tm0', 1);
    out{1} = {io(2, 'tm1', [0.9 1]), io(2, 'tm0', [0 0.01])};

    vis_options.mode_sel = 1 : N;

    % Build the problem.
    problem = get_problem(omega, in, out, vis_options, ...
                            model_structure, custom_model_options);
