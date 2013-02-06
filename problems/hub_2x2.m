function [problem] = hub_2x2(custom_model_options)

    % Choose the structure of the model (what waveguides to use where).
    M = 2;

    [model_structure, omega, in, out] = metahub(M);

    N = M^2; % Number of modes.
    vis_options.mode_sel = 1 : N;

    % Build the problem.
    problem = get_problem(omega, in, out, vis_options, ...
                            @model_H, model_structure, custom_model_options);
