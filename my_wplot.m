function my_wplot(o1, o2)

    for i = 1 : length(o1)
        p1(i,1) = mean(o1{i}(1:21));
        p1(i,2) = mean(o1{i}(22:42));
        p2(i,1) = mean(o2{i}(1:21));
        p2(i,2) = mean(o2{i}(22:42));
    end

    fan_spread = (2*pi/32.75 - 2*pi/38.75) / 3; % Larger spread.
    w = 2*pi/38.75-fan_spread : 0.001 : 2*pi/32.75+fan_spread;
    lambda = 2 * pi ./ w;
    plot(lambda*40, [p1, p2])
