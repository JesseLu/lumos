function [lambda, power] = analyze_spl_wdm(state_file, num_w)

    fan_spread = (2*pi/32.75 - 2*pi/38.75) / 3; % Larger spread.
    wlims = [2*pi/38.75-fan_spread, 2*pi/32.75+fan_spread];
    w = wlims(1) : (wlims(2)-wlims(1))/(num_w-1) : wlims(2);
    lambda = 2*pi./w * 40;

    if strfind(state_file, '2D')
        flatten = true;
    else
        flatten = false;
    end

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

    %% Run a bunch of simulations, and get the outputs for each one.
    % Start the simulations.
    N = length(w);
    chunksize = 13;
    done = false * ones(N, 1);
    power = nan * ones(2, N);
    for cnt = 1 : ceil(N/chunksize)
        starti = (cnt - 1) * chunksize + 1;
        endi = min([cnt*chunksize, N]);

        for i = starti : endi
            fprintf('.');
            cb{i} = start_simulation(w(i), in, out, epsilon);
        end
        fprintf('\n');

        % Check for simulation completion.
        while ~all(done(starti:endi))
            for i = starti : endi 
                if ~done(i)
                    power(:,i) = cb{i}();
                    if all(~isnan(power(:,i)))
                        cb{i} = []; % Try to free up some memory.
                        done(i) = true;
                        fprintf('%d finished [%d/%d]\n', i, sum(done), N);
                    end
                end
            end
        end
    end
    plot(lambda, power, '.-');
end
