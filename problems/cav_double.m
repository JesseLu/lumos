function [problem] = cav_double(custom_model_options)


    N = 2; % Number of modes.

    w0 = 2 * pi / 38.75;

    omega{1} = w0;
    in{1} = io({[0 0 0]}, 'y', 1);
    out{1} = io({[0 0 0]}, 'y', 1e1*[0.9 1]);

    omega{2} = 2 * w0;
    in{2} = io({[0 0 0]}, 'z', 1);
    out{2} = io({[0 0 0]}, 'z', 1e1*[0.9 1]);

    vis_options.mode_sel = 1 : N;

    % Build the problem.
    problem = get_problem(omega, in, out, vis_options, ...
                            @model_C, [] , custom_model_options);
