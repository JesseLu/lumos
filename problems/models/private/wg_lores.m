%% wg_lores
% Provides nanophotonic waveguides for low-resolution designs.

%% Description
% Nanophotonic wavegudes are based on those from the litterature which are designed
% to be single-mode at wavelengths around 1550 nm. 
%
% In this toolbox, the wavelength of 1550 nm corresponds 
% to the unit-less frequency of ~0.1571 (2*pi/40).
%
% Assumes that the permittivity of silicon is 13,
% and that the cladding is SiO2 with a permittivity of 2.25.

function [waveguide, port] = wg_lores(epsilon, type, dir, len, pos)

    % If a free-space wavelength is 40 grid points, 
    % and we want that to correspond to 1550 nm,
    % then the grid spacing is 38.75 nm.
    grid_spacing = 1550/40;

    % We assume a slab thickness of 220 nm.
    slab_thickness = 220/40;

    wg_eps = 13;

    switch type
        case 'single'
            width = 500/40;
        case 'double'
        case 'triple'
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

    % TODO: I think we need to just output the waveguide structure.
    waveguide = struct( 'type', 'rectangle', ...
                        'position', pos(1:2), ...
                        'size', wg_size, ...
                        'permittivity', wg_eps);
    port = nan;
