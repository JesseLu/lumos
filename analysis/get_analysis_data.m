% function [get_epsilon] = get_analysis_data(state_file)
function [get_epsilon] = get_analysis_data(opt_prob, design_area, state_file)

    % [opt_prob, design_area] = get_opt_prob(state_file);
    data = load(state_file, 'p', 'z', 'state');
    p = data.p;

    function [epsilon] = my_get_epsilon(dT, dF) 
    % Temperature and fabrication error.
        z = phi2p(reshape(p, design_area), [0 1]);
        modes = verification_layer(opt_prob, z(:), data.state.x);
        epsilon = modes(1).epsilon;
    end


    get_epsilon = @my_get_epsilon;

end


