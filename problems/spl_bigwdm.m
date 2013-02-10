function [problem] = spl_bigwdm(custom_model_options)

    % Choose the structure of the model (what waveguides to use where).
    model_structure = {'single', 'single', 'single', 'single', 'single'};


    N = 4; % Number of modes.

    omegas = 2 * pi ./ [36.75 32.75 34.75 38.75];
    for i = 1 : N
        omega{i} = omegas(i);
        in{i} = io(1, 'te0', 1);
        out{i} = io(1+i, 'te0', [0.9 1]);
    end

    vis_options.mode_sel = 1 : N;

    % Build the problem.
    problem = get_problem(omega, in, out, vis_options, ...
                            @model_V2, model_structure, custom_model_options);
end
