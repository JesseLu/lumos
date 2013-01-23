function [wg] = build_io(ports, io)

    if ~iscell(io)
        io = {io};
    end

    % Allow for a simple way to specify a waveguide mode.
    for k = 1 : length(io)
        port = ports{io{k}.port};

        % NOTE: Distinguish input and output by the number of elements
        % in the power field of io.
        switch length(io{k}.power)
            case 1 % Input
                shift = port.J_shift;
            case 2 % Output
                shift = port.E_shift;
            otherwise
                error('Invalid power.');
        end
        
        % Shift things appropriately.
        for l = 1 : 2
            pos{l} = port.pos{l} + shift;
        end

        % Build the waveguide spec.
        wg(k) = struct( 'type', port.type, ...
                        'power', io{k}.power, ...
                        'pos', {pos}, ...
                        'dir', port.dir, ...
                        'mode_num', port.(io{k}.mode));
    end
