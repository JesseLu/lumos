function [problem] = top_wdm(custom_model_options)

    % Choose the structure of the model (what waveguides to use where).
    model_structure = {'single', 'single', 'single'};

    % Fanning out structure in frequency space.
    fan_spread = (2*pi/32.75 - 2*pi/38.75) / 3; % Larger spread.
    w = 2*pi/38.75-fan_spread : 0.001 : 2*pi/32.75+fan_spread;

    for i = 1 : length(w)
        omega{i} = w(i);
        in{i} = io(1, 'te0', 1);
        out{i} = {  io(2, 'te0', [0.9 0.9]), ...
                    io(3, 'te0', [0 0.01])};
    end

    vis_options.mode_sel = 1 : length(omega);

    % Build the problem.
    problem = get_problem(omega, in, out, vis_options, ...
                            @model_V, model_structure, custom_model_options);
