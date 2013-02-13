function [problem] = fsd_mirror(custom_model_options)

    % Choose the structure of the model (what waveguides to use where).

    N = 1; % Number of modes.

    omega{1} = 2 * pi / (2*38.75);
    in{1} = io(1, 'ypol', 1);

    
    out_port = 1;
    out_mode = 1;
    M = 6; % Needs to be 10 for 3D.
    for p = 1 : 2
        for i = 1 : M 
            ind = (p-1) * M + i;
            if (p == out_port) && (i == out_mode)
                out{1}{ind} = io(p, i, [0.9 1]);
            else
                out{1}{ind} = io(p, i, [0 0.1]);
            end
        end
    end
    out{1} = out{1}{1};
    vis_options.mode_sel = 1 : N;

    % Build the problem.
    problem = get_problem(omega, in, out, vis_options, ...
                            @model_U, [], custom_model_options);
