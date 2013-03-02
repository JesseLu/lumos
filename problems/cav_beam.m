function [problem] = cav_beam(custom_model_options)

    % Choose the structure of the model (what waveguides to use where).
    model_structure = {'double', 'double'};

    N = 2; % Number of modes.

    w0 = 2 * pi / 38.75;

    omega{1} = w0 / 2;
    in{1} = io(1, 'te0', 1);
    out{1} = io(1, 'te0', [0.999 1]);

    omega{2} = w0;
    in{2} = io(1, 'tm0', 1);
    out{2} = io(1, 'tm0', [0.999 1]);
    % out{1} = {io(1, 'tm0', [0.90 1]), io(2, 'tm0', [0 0.01]), io(2, 3, [0 0.01])};

    vis_options.mode_sel = 1 : N;

    % Build the problem.
    problem = get_problem(omega, in, out, vis_options, ...
                            @model_T, model_structure, custom_model_options);
