function [problem] = hub_2x2(custom_model_options)

    % Choose the structure of the model (what waveguides to use where).
    M = 2;
    for i = 1 : 2*M
        model_structure{i} = 'single';
    end


    omegas = 2*pi ./ (38.75 - 2 * [0:M-1]);

    cnt = 0;
    for port = 1 : M
        for freq = 1 : M
            cnt = cnt + 1;
            omega{cnt} = omegas(freq);
            in{cnt} = io(port, 'te0', 1);
            out_port = mod(port+freq-2, M) + 1 + M;
            out{cnt} = io(out_port, 'te0', [0.9 1]);
        end
    end
%     omega{1} = 2 * pi / 38.75;
%     in{1} = io(1, 'te0', 1);
%     out{1} = io(1+M, 'te0', [0.9 1]);
    % out{1} = {io(2, 'te0', [0.9 1]), io(3, 'te0', [0 0.01])};
% 
%     omega{2} = 2 * pi / 32.75;
%     in{2} = io(1, 'te0', 1);
%     % out{2} = io(3, 'te0', [0.9 1]);
%     out{2} = {io(2, 'te0', [0 0.01]), io(3, 'te0', [0.9 1])};
% 
    N = M^2; % Number of modes.
    vis_options.mode_sel = 1 : N;

    % Build the problem.
    problem = get_problem(omega, in, out, vis_options, ...
                            @model_H, model_structure, custom_model_options);
