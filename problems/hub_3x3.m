function [problem] = hub_3x3(custom_model_options)

    % Choose the structure of the model (what waveguides to use where).
    M = 3;
    spinner = 1;
    offset = 1;

    model_structure = metahub(M);

    N = M; % Number of modes.
    vis_options.mode_sel = 1 : N;

    std_omega = 2 * pi / 38.75;

    % for i = 1 : M
    for i = 1 : 1
        omega{i} = std_omega;
        in{i} = io(i, 'te0', 1);
        out_port = mod(i*(spinner) - 1 + offset, M) + 1
        for j = 1 : M
            if j == out_port
                power = [0.9, 1];
            else
                power = [0, 0.01];
            end
            out{i}{j} = io(M+j, 'te0', power);
        end
        out{i} = out{i}{out_port};
    end

    % Build the problem.
    problem = get_problem(omega, in, out, vis_options, ...
                            @model_H, model_structure, custom_model_options);
