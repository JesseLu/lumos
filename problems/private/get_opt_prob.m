%% get_opt_prob
% Makes translation just a little easier...
function [opt_prob] = get_opt_prob(modes, flatten)
    if flatten
        solver = @solve_local;
    else
        solver = @solve_maxwell;
    end

    opt_prob = translation_layer(modes, solver);
end
