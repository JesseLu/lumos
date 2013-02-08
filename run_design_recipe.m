%% run_design_recipe
% Performs a design "recipe", which is a collection of calls to lumos().

%% Description
% Strings together multiple calls to lumos to get a design.

function [] = run_design_recipe(problem_name, recipe_name, varargin)

    % Detect the 2D option.
    if ~isempty(strfind(problem_name, '2D'))
        flatten_option = true;
        exec_problem_name = strrep(problem_name, '2D', '');  
    else 
        flatten_option = false;
        exec_problem_name = problem_name;
    end


    gen_problem = eval(['@', exec_problem_name]);
    problem = gen_problem({'flatten', flatten_option});

    % Set up the results directory for this recipe run.
    my_run_dir = [results_dir(), problem_name, '_', recipe_name, filesep];
    if isdir(my_run_dir)
        rmdir(my_run_dir, 's'); % Recursive remove.
    end
    mkdir(my_run_dir);


    function [p] = run_step(params, step_name)
        my_step_name = [my_run_dir, 'step', step_name];
        fprintf('\nRunning step: %s\n', my_step_name);
        use_restart = false;
%         % For no error override.
%         [z, p, vis] = lumos(my_step_name, problem, params{:}, ...
%                             'restart', use_restart);
%         return 
        while true
            try
                [z, p, vis] = lumos(my_step_name, problem, params{:}, ...
                                    'restart', use_restart);
                break;
            catch exception
                fprintf(getReport(exception, 'extended'));
                fprintf('\n');
                use_restart = true;
                continue;
            end
        end
    end

    function [phi] = switch_to_phi(p)
        p = reshape(p, problem.design_area);
        phi = init_phi(p, [0 1], 1e-2, 0.5 * [1 -1]);
        phi = phi(:);
    end

    function [phi] = reinit_phi(phi)
        phi = reshape(phi, problem.design_area);
        p = phi2p(phi, [0 1]);
        phi = switch_to_phi(p);
    end
        
    % reinit_phi = @(phi) switch_to_phi(phi2p(reshape(phi, problem.design_area), [0 1]));

    % Log the diary.
    diary([my_run_dir, 'diary.txt']);
    diary on;

    switch recipe_name
        case 'r1'
            % Options structure
            options = struct(   'num_iters', 100, ...
                                'skip_A', false, ...
                                'skip_B', false, ...
                                'p0', 3/4);

            % Parse optional parameters.
            for k = 2 : 2 : length(varargin)
                options = setfield(options, varargin{k-1}, varargin{k});
            end

            p = options.p0;

            % Global optimization for 100 steps.
            if ~options.skip_A
                p = run_step({'global', 'density', p, ...
                                [options.num_iters, 1e-3]}, 'A');
            end

            % Local density optimization.
            if ~options.skip_B
                p = run_step({'local', 'density', p, options.num_iters}, 'B');
            end

            % Switch to level-set.
            phi = switch_to_phi(p);
            for i = 1 : 5
                phi = run_step({'local', 'level-set', reinit_phi(phi), ...
                                options.num_iters}, ['C', num2str(i)]);
            end

        otherwise
            error('Unkown recipe.');    
    end


    diary off;
end
