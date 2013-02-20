function [callback] = start_simulation(omega, in, out, epsilon)

    dims = size(epsilon{1});
    [s_prim, s_dual] = stretched_coordinates(omega, dims, [10 10 10]);
    mu = {ones(dims), ones(dims), ones(dims)};

    % Get input.
    [~, ~, ~, J] = solve_waveguide_mode(omega, s_prim, s_dual, ...
                                        mu, epsilon, ...
                                        in.pos, in.dir, in.mode_num);
    for k = 1 : 3 % Scale the input excitation.
        J{k} = sqrt(in.power) * J{k};
    end

    E0 = {zeros(dims), zeros(dims), zeros(dims)};
    cb = solve_local(omega, s_prim, s_dual, mu, epsilon, J);

    % Modify the callback.
    function [power] = my_callback()
        [done, E, H] = cb();

        if done
            power = analyze_results(omega, s_prim, s_dual, mu, epsilon, out, E);
        else
            power = nan;
        end
    end

    callback = @my_callback;
end

function [power] = analyze_results(omega, s_prim, s_dual, ...
                                    mu, epsilon, out, E)

    vec = @(f) [f{1}(:); f{2}(:); f{3}(:)];
    x = vec(E);

    % Find the field pattern of the desired output mode.
    for i = 1 : length(out)
        for j = 1 : 20
            pos{1} = out{i}.pos{1};
            pos{2} = out{i}.pos{2};

            pos{1}(1) = pos{1}(1) + j - 1;
            pos{2}(1) = pos{2}(1) + j - 1;

            [~, E_out] = solve_waveguide_mode(omega, s_prim, s_dual, ...
                                           mu, epsilon, ...
                                           pos, out{i}.dir, out{i}.mode_num);
            c = vec(E_out); % Vectorize
            power(i, j) = (abs(c'*x) / norm(c)^2)^2;
        end
    end
    power = mean(power, 2);
end
