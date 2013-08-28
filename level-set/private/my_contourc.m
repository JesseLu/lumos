function [c] = my_contourc(phi)

    dims = size(phi);

    if any(dims == 1)
        is_1d = true;
        p = [phi(:), phi(:)];
    else
        is_1d = false;
        p = phi;
    end

    c = contourc(p, [0 0]);

    if is_1d
        ind = find(c(1,:) == 2.0);
        c(:,ind) = [];
    end
