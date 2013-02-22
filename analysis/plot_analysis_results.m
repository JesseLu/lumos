function plot_analysis_results()

    analysis_dir = strrep(mfilename('fullpath'), 'plot_analysis_results', '');

    % Load the data.
    orig = load([analysis_dir, 'narrowband.mat']);
    top = load([analysis_dir, 'broadband.mat']);
    l = orig.l; % Should be the same for all data.

    my_save = @(filename) save_plot([analysis_dir, filesep, 'plots', ...
                                                    filesep, filename]);

    % Just shows spl_wdm result.
    hold off
    subplot 211
    plot(l, orig.p, '-', 'Linewidth', 2);
    my_save('spl_modal_only'); 

    plot(l, top.p, '-', 'Linewidth', 2);
    my_save('top_only'); 

end


function save_plot(filename)
    a = axis;
    axis([a(1:2), 0, 1]);
    set(gca, 'Visible', 'off');
    print('-dpng', '-r200', filename);
end

