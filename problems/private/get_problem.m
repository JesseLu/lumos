%% get_problem
% Generic function to create the design problem.

function problem = get_problem(omega, in, out, vis_options, ...
                                model_structure, custom_model_options)

    model_options = parse_model_options(custom_model_options);

    % Get the modes.
    for i = 1 : length(omega)
        [modes(i), vis_options(i).vis_layer] = ...
                                model_I(omega{i}, in{i}, out{i}, ...
                                        model_structure, model_options);
    end


    % Translate.
    if model_options.flatten
        solver = @solve_local;
    else
        solver = @solve_maxwell;
    end

    opt_prob = translation_layer(modes, solver);

    % Get design_area.
    design_area = modes(1).design_area;

    % Produce the final problem structure.
    problem = struct('opt_prob', opt_prob, ...
                    'vis_options', vis_options, ...
                    'design_area', design_area);
end
