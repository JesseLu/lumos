function [problem] = fib_pol(custom_model_options)

    % Choose the structure of the model (what waveguides to use where).
    model_structure = {'single', 'single'};

    N = 2; % Number of modes.

    omega{1} = 2 * pi / 32.75;
    in{1} = io(1, 'ypol', 1);
    out{1} = io(2, 'te0', [0.4 1]);

    omega{2} = 2 * pi / 32.75;
    in{2} = io(1, 'circ', 1); % Should be a circularly polarized mode.
    out{2} = io(3, 'te0', [0.4 1]);

    vis_options.mode_sel = 1 : N;

    % Build the problem.
    problem = get_problem(omega, in, out, vis_options, ...
                            @model_L, model_structure, custom_model_options);
