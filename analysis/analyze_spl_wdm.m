function [cb] = analyze_spl_wdm(state_file)

    flatten = true;
    if flatten
        mode_num = 2;
    else
        mode_num = 1;
    end

    %% Get epsilon
    data = load(state_file, 'z', 'state');
    problem = spl_wdm({ 'flatten', flatten, ...
                        'S_type', 'average', ...
                        'size', 'large'});
    modes = verification_layer(problem.opt_prob, data.z, data.state.x);

    %% Determine where the wgmode solves need to be
    epsilon = modes(1).epsilon;
    dims = size(epsilon{1});
    if numel(dims) == 2 
        dims = [dims 1];
    end
    center = round(dims/2);
    in = struct('pos', {{[11 center(2:3)-19], [11, center(2:3)+20]}}, ...
                'dir', 'x+', ...
                'mode_num', mode_num, ...
                'power', 1);

    y_shift = 14 * [-1 1];
    for i = 1:2
        out{i} = struct('pos', {{[110 center(2:3)-19+[y_shift(i) 0]], ...
                                [110, center(2:3)+20+[y_shift(i) 0]]}}, ...
                        'dir', 'x+', ...
                        'mode_num', mode_num, ...
                        'power', 1);
    end

    if flatten
        in.pos{1}(3) = 1;
        in.pos{2}(3) = 1;
        out{1}.pos{1}(3) = 1;
        out{1}.pos{2}(3) = 1;
        out{2}.pos{1}(3) = 1;
        out{2}.pos{2}(3) = 1;
    end

    % Run a bunch of simulations, and get the outputs for each one.
    cb = start_simulation(2*pi/38.25, in, out, epsilon);

end

