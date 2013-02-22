function vis_modes(E)
    title_text = {'Ex', 'Ey', 'Ez'};
    for k = 1 : 3
        subplot(3, 1, k);
        data = real(squeeze(E{k}(:,:,1)));
        imagesc(data', max(abs(data(:))) * [-1 1]); 
        axis equal tight;
        set(gca, 'YDir', 'normal');
        colorbar;
        title(title_text{k});
    end
end
    
