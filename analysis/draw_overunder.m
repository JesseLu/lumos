function draw_overunder()

    analysis_dir = strrep(mfilename('fullpath'), 'draw_overunder', '');
    d = load([analysis_dir, 'eps_overunder.mat']);

    my_save = @(data, filename) my_saveimage(data{3}(:,:,20), ... 
                                    flipud(colormap('bone')), ...
                                    [2.25, 12.25], ...
                                    [analysis_dir, filesep, 'plots', ...
                                                    filesep, filename], ...
                                    13);

    my_save(d.eps_0, 'eps0');
    my_save(d.eps_under, 'eps_under');
    my_save(d.eps_over, 'eps_over');
end


function my_saveimage(z, map, lims, filename, varargin)
% Write out a mapped image.

    if ~isempty(varargin)
        clip = varargin{1};
        dims = size(z);
        z = z(1+clip:dims(1)-clip, 1+clip:dims(2)-clip);
    end

    if isempty(lims)
        if all(z >= 0)
            lims = max(abs(z(:))) * [0 1];
        else
            lims = max(abs(z(:))) * [-1 1];
        end
    end

    z = (((z)-lims(1)) / diff(lims) * 63) + 1;
    z = 1 * (z < 1) + 64 * (z > 64) + z .* ((z >= 1) & (z <= 64));
    imwrite(z', map, [filename, '.png']);
    % imwrite([64:-1:1]', map, ['', filename, '.png']); % Colorbar.
end


