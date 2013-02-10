function [problem] = spl_bigwdm(custom_model_options)

    % Choose the structure of the model (what waveguides to use where).
    model_structure = {'double', 'single', 'single', 'single', 'single'};


    N = 4; % Number of modes.

    in_mode = {'te1', 'tm0', 'tm1', 'te0'};
    out_mode = {'te0', 'tm0', 'tm0', 'te0'};
    for i = 1 : N
        omega{i} = 2*pi / 38.75;
        in{i} = io(1, in_mode{i}, 1);
        out{i} = io(1+i, out_mode{i}, [0.9 1]);
    end

    vis_options.mode_sel = 1 : N;

    % Build the problem.
    problem = get_problem(omega, in, out, vis_options, ...
                            @model_V2, model_structure, custom_model_options);
end
