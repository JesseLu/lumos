function visualize_all()
    d = dir(results_dir());
    names = {};
    for i = 1 : length(d)
        if d(i).isdir & ~isempty(find(d(i).name ~= '.'))
            names{end+1} = d(i).name;
        end
    end

    for i = 1 : length(names)
        fprintf('%s...\n', names{i});
        visualize_design_run(names{i});
    end
end
