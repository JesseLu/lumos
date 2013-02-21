% function [get_epsilon] = get_analysis_data(state_file)
function [get_epsilon] = get_analysis_data(opt_prob, design_area, state_file)

    % [opt_prob, design_area] = get_opt_prob(state_file);
    data = load(state_file, 'p', 'z', 'state');
    phi = data.p;

    function [epsilon] = my_get_epsilon(dT, dF) 
    % Temperature and fabrication error.

        % The fabrication (over/under etch) shift.
        % Scale it by 40 since one pixel is 40 nm.
        % This means that dF = 1, 
        % should very roughly be an over_etch of 1 nm.
        phi_shift = -dF/40;
        z = phi2p(reshape(phi+phi_shift, design_area), [0 1]);


        modes = verification_layer(opt_prob, z(:), ...
                        {opt_prob(1).field_obj.C(:,1), ...
                        opt_prob(1).field_obj.C(:,1)});
        epsilon = modes(1).epsilon;

        % Temperature shift.
        % For now, let's just make it a shift of the silicon only.
        for i = 1 : 3
            epsilon{i} = (epsilon{i} - 2.25) * (1 + dT/10) + 2.25;
        end

    end


    get_epsilon = @my_get_epsilon;

end


