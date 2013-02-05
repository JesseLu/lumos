function [problem] = spl_wdm(custom_model_options)

    % Choose the structure of the model (what waveguides to use where).
    model_structure = {'single', 'single', 'single'};

    N = 2; % Number of modes.

    omega{1} = 2 * pi / 40;
    in{1} = io(1, 'te0', 1);
    % out{1} = io(2, 'te0', [0.9 1]);
    out{1} = {io(2, 'te0', [0.9 1]), io(3, 'te0', [0 0.01])};

    omega{2} = 2 * pi / 39;
    in{2} = io(1, 'te0', 1);
    % out{2} = io(3, 'te0', [0.9 1]);
    out{2} = {io(2, 'te0', [0 0.01]), io(3, 'te0', [0.9 1])};

    vis_options.mode_sel = 1 : N;

    % Build the problem.
    problem = get_problem(omega, in, out, vis_options, ...
                            @model_V, model_structure, custom_model_options);
