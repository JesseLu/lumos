%% run_design_recipe
% Performs a design "recipe", which is a collection of calls to lumos().

%% Description

function [] = run_design_recipe(problem_name, recipe_name)

    gen_problem = eval(['@', problem_name]);
    problem = gen_problem('2D');


    function [p] = run_step(params, step_name)
        my_step_name = [problem_name, '_', recipe_name, '_step', step_name];
        fprintf('\nRunning step: %s\n', my_step_name);
        use_restart = false;
        while true
            try
                [z, p, vis] = lumos(my_step_name, problem, params{:}, 'restart', use_restart);
                break;
            catch exception
                fprintf(getReport(exception, 'basic'));
                use_restart = true;
                continue;
            end
        end
    end

    function [phi] = my_phi_init(p, p_lims)
            p = reshape(p, problem.design_area);
            phi = init_phi(p, p_lims, 3e-3, 0.5 * [1 -1]);
            phi = phi(:);
    end

    switch_to_phi = @(p) my_phi_init(p, [0 1]);
    reinit_phi = @(phi) my_phi_init(phi, [-1 1]);


    switch recipe_name
        case 'rA'
            num_iters = [100 40 40] ./ 10;

            % Global optimization for 100 steps.
            p = run_step({'global', 'density', [], [num_iters(1), 1e-3]}, 'A');

            % Local density optimization.
            p = run_step({'local', 'density', p, num_iters(2)}, 'B');

            % Switch to level-set.
            phi = switch_to_phi(p);
            for i = 1 : 5
                phi = run_step({'local', 'level-set', reinit_phi(phi), ...
                                num_iters(3)}, ['C', num2str(i)]);
            end

        otherwise
            error('Unkown recipe.');    
    end


end
