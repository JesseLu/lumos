% Central band pass structure.
function [problem] = sid_normal(custom_model_options)

    % Choose the structure of the model (what waveguides to use where).
    model_structure = {'single', 'single'};

    N = 3; % Number of modes.

    w = 2 * pi ./ [37.5, 38.75, 40];

    for k = 1 : length(w)
        omega{k} = w(k);
        in{k} = io(1, 'te0', 1);
        if k == 2
            port = [2 1];
        else
            port = [1 2];
        end
        % out{k} = io(port, 'te0', [0.9 1]);
        out{k} = {io(port(1), 'te0', [0.9 1]), ...
                    io(port(2), 'te0', [0 0.01])};
    end

    vis_options.mode_sel = 1 : N;

    % Build the problem.
    problem = get_problem(omega, in, out, vis_options, ...
                            @model_I2, model_structure, custom_model_options);
