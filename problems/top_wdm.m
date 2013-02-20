function [problem] = top_wdm(custom_model_options)

    % Choose the structure of the model (what waveguides to use where).
    model_structure = {'single', 'single', 'single'};

    % Fanning out structure in frequency space.
    fan_num = 2; % Number of frequencies to each side of central peak.
    fan_spread = (2*pi/32.75 - 2*pi/38.75) / 5; % Each peaks's one-way spread.

    if fan_num == 0 
        delta_w = 1;
    else
        delta_w = fan_spread / fan_num;
    end

    w{1} = 2*pi / 38.75 + delta_w * [-fan_num : fan_num];
    w{2} = 2*pi / 32.75 + delta_w * [-fan_num : fan_num];

    cnt = 1;
    for i = 1 : length(w)
        if i == 1
            accept_port = 2;
            reject_port = 3;
        elseif i == 2
            accept_port = 3;
            reject_port = 2;
        else
            error('i must be 1 or 2.');
        end

        for j = 1 : length(w{i})
            omega{cnt} = w{i}(j);
            in{cnt} = io(1, 'te0', 1);
            out{cnt} = {io(accept_port, 'te0', [0.9 1]), ...
                        io(reject_port, 'te0', [0 0.01])};
            cnt = cnt + 1;
        end
    end

    vis_options.mode_sel = 1 : length(omega);

    % Build the problem.
    problem = get_problem(omega, in, out, vis_options, ...
                            @model_V, model_structure, custom_model_options);
