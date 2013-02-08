
function [problem] = spl_wdm(custom_model_options)

    % Choose the structure of the model (what waveguides to use where).
    model_structure = {'double', 'single', 'single', 'single', 'single'};


    function [out] = my_out(port_num)
        for i = 1 : 4
            if i == port_num
                out{i} = io(i+1, 'te0', [0.9 1]);
            else
                out{i} = io(i+1, 'te0', [0 0.01]);
            end
        end
        out = out{port_num}; % Don't use reject bands.
    end

    N = 1; % Number of modes.

    omega{1} = 2 * pi / 38.75;
    in{1} = io(1, 'te0', 1);
    out{1} = my_out(1);

    omega{2} = 2 * pi / 32.75;
    in{2} = io(1, 'te0', 1);
    out{2} = my_out(2);

    omega{3} = 2 * pi / 38.75;
    in{3} = io(1, 'te1', 1);
    out{3} = my_out(3);

    omega{4} = 2 * pi / 32.75;
    in{4} = io(1, 'te1', 1);
    out{4} = my_out(4);

    vis_options.mode_sel = 1 : N;

    % Build the problem.
    problem = get_problem(omega, in, out, vis_options, ...
                            @model_V2, model_structure, custom_model_options);
end
