function [wg] = build_io(ports, io)

    if ~iscell(io)
        io = {io};
    end

    % Allow for a simple way to specify a waveguide mode.
    for k = 1 : length(io)
        port = ports{io{k}.port};

        % NOTE: Distinguish input and output by the number of elements
        % in the power field of io.

        wg(k) = struct('type', port.type, ...
                        'power', io{k}.power, ...
                        'pos', {port{k}.pos}, ...
                        'dir', port{k}.dir, ...
                        'mode_num', port{k}.(io{k}.mode));
    end
