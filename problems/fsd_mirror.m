function [problem] = fsd_mirror(custom_model_options)

    % Choose the structure of the model (what waveguides to use where).

    N = 1; % Number of modes.

    omega{1} = 2 * pi / 38.75;
    in{1} = io(1, 'ypol', 1);
    out{1} = {io(1, 'ypol', [0.9 1]), ...
            io(2, 'ypol', [0 0.01])};

    vis_options.mode_sel = 1 : N;

    % Build the problem.
    problem = get_problem(omega, in, out, vis_options, ...
                            @model_U, [], custom_model_options);
