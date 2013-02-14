function [problem] = fib_te(custom_model_options)

    % Choose the structure of the model (what waveguides to use where).
    model_structure = {'single'};

    N = 1; % Number of modes.

    omega{1} = 2 * pi / 38.75;
    in{1} = io(1, 'ypol', 1);
    out{1} = io(2, 'te0', [0.9 1]);

    vis_options.mode_sel = 1 : N;

    % Build the problem.
    problem = get_problem(omega, in, out, vis_options, ...
                            @model_L, model_structure, custom_model_options);
