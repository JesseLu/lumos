%% get_problem
% Generic function to create the design problem.

function problem = get_problem(omega, in, out, vis_options, ...
                                model_structure, model_type, flatten)

    % Get the modes.
    for i = 1 : length(omega)
        [modes(i), vis_options(i).vis_layer] = ...
                                model_I(omega{i}, in{i}, out{i}, ...
                                        model_structure, model_type, flatten);
    end


    % Translate.
    if flatten
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
