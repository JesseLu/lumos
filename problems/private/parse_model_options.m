function [model_options] = parse_model_options(custom_model_options)

    % Default parameters.
    model_options = struct( 'size', 'small', ...
                            'flatten', true);

    %% Parse optional parameters.
    for k = 2 : 2 : length(custom_model_options)
        model_options = setfield(model_options, custom_model_options{k-1}, ...
                                                custom_model_options{k});
    end
end
