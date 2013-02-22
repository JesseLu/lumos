function plot_analysis_results()

    analysis_dir = strrep(mfilename('fullpath'), 'plot_analysis_results', '');

    % Load the data.
    orig = load([analysis_dir, 'narrowband.mat']);
    top = load([analysis_dir, 'broadband.mat']);
    temp = load([analysis_dir, 'temp_shift.mat']);
    fab = load([analysis_dir, 'fab_shift.mat']);
    l = orig.l; % Should be the same for all data.

    my_save = @(filename) save_plot([analysis_dir, filesep, 'plots', ...
                                                    filesep, filename]);

    % Just shows spl_wdm result.
    hold off
    subplot 211
    plot(l, orig.p, '-', 'Linewidth', 2);
    my_save('spl_modal_only'); 

    % Just the top.
    plot(l, top.p, '-', 'Linewidth', 2);
    my_save('top_only'); 

    % Next do the temperature shift.
    hold off
    cnt = 0;
    for i = 1 : 3 : 13
        hold on
        plot(l, temp.p{i}(1,:), '-', 'Linewidth', 2, 'Color', [cnt/5 0 0]);
        plot(l, temp.p{i}(2,:), '-', 'Linewidth', 2, 'Color', [cnt/5 0 0]);
        cnt = cnt + 1;
    end
    my_save('temp_shift'); 


    % Lastly, fab shift.
    hold off
    cnt = 0;
    for i = 7 : 2 : 15
        c = i - 11;
        if c == 0
            color = [0 0 0];
        elseif c < 0
            color = [0 0.3-c/8 0];
        else
            color = [0 0 0.3+c/8];
        end
        % color = color + [0.6 0 0];
        plot(l, fab.p{i}, '-', 'Linewidth', 2, 'Color', color);
        hold on
    end
    my_save('fab_shift'); 


end


function save_plot(filename)
    a = axis;
    axis([a(1:2), 0, 1]);
    set(gca, 'Visible', 'off');
    print('-dpng', '-r200', filename);
end

