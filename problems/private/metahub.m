function [model_structure, omega, in, out] = metahub(M)

    for i = 1 : 2*M
        model_structure{i} = 'single';
    end

    omega_lims = 2*pi ./ [32.75, 38.75];
    for i = 1 : M
        omegas(i) = ((i-1)/(M-1)) * omega_lims(1) + ((M-i)/(M-1)) * omega_lims(2);
    end

    cnt = 0;
    for port = 1 : M
        for freq = 1 : M
            cnt = cnt + 1;
            omega{cnt} = omegas(freq);
            in{cnt} = io(port, 'te0', 1);
            out_port = mod(port+freq-2, M) + 1 + M;
            out{cnt} = io(out_port, 'te0', [0.9 1]);
        end
    end
 
