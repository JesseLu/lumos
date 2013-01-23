%% wg_lores
% Provides nanophotonic waveguides for low-resolution designs.

%% Description
% Nanophotonic wavegudes are based on those from the litterature which are designed
% to be single-mode at a wavelength around 1600 nm. 
%
% In this toolbox, the wavelength of 1600 nm corresponds 
% to the unit-less frequency of ~0.1571 (2*pi/40).
%
% For good performance, meaning minimal mode overap,
% the waveguide should reside in its own 40x40 box of SiO2.
%
% Assumes that the permittivity of silicon is 13,
% and that the cladding is SiO2 with a permittivity of 2.25.

function [waveguide, port] = wg_lores(epsilon, type, dir, len, pos)

    % If a free-space wavelength is 40 grid points, 
    % and we want that to correspond to 1600 nm,
    % then the grid spacing is 40 nm.
    grid_spacing = 40;

    % We assume a slab thickness of 250 nm.
    slab_thickness = 250 / grid_spacing;

    wg_eps = 13;

    port = struct(  'type', 'wgmode');

    switch type
        case 'single'
        % Contains a single TE and TM mode.
            width = 500 / grid_spacing;

        case 'double'
        % Contains up to first-order TE and TM modes.
            width = 750 / grid_spacing;

        otherwise
            error('Unkown type.');
    end

    switch dir(1)
        case 'x'
            wg_size = [len width];
        case 'y'
            wg_size = [width len];
        otherwise
            error('Unknown direction.');
    end

    switch dir(2)
        case '+'
        case '-'
        otherwise
            error('Unknown direction.');
    end



    waveguide = struct( 'type', 'rectangle', ...
                        'position', pos(1:2), ...
                        'size', wg_size, ...
                        'permittivity', wg_eps);
