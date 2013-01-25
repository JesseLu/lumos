function [k, dk] = compute_curvature(phi)
    [dx, dy, dxx, dxy, dyy] = derivatives(phi);

    % Compute the curvature term, which is kappa * |grad phi|.
    % In other words, equation 1.8 of Osher and Fedkiw, with one less power 
    % in the denominator. 
    % Correction: Has been made to be scale-invariant,
    % meaning that multiplying phi by a coefficient results in the same 
    % values of curvature.
    k_denom = (dx.o.^2 + dy.o.^2);
    k_denom(find(k_denom == 0)) = 1;
    k = (dx.o.^2 .* dyy - 2 * dx.o .* dy.o .* dxy + dy.o.^2 .* dxx) ./ ...
        k_denom;

    dk = k ./ sqrt(k_denom);

    % Zero-out values not "touching" a border.
    [~, ~, on_border] = phi2p(phi);
    k = k .* on_border;
    dk = dk .* on_border;
    
