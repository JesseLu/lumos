function [opt_prob, design_area] = get_opt_prob(state_file)

    if strfind(state_file, '2D')
        flatten = true;
    else
        flatten = false;
    end

    %% Get the problem.
    problem = spl_wdm({ 'flatten', flatten, ...
                        'S_type', 'average', ...
                        'size', 'large'});
    opt_prob = problem.opt_prob;
    design_area = problem.design_area;


