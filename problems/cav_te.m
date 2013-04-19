function [problem] = cav_te(custom_model_options)


    N = 1; % Number of modes.

    omega{1} = 2 * pi / 38.75;
    pol{1} = 'y';


    omega{1} = 2 * pi / 38.75;
    in{1} = io({[0 0 0]}, 'z', 1);
    out{1} = io({[0 0 0]}, 'z', 3e0*[0.9 1]);

    vis_options.mode_sel = 1 : N;

    % Build the problem.
    problem = get_problem(omega, in, out, vis_options, ...
                            @model_C, [] , custom_model_options);
