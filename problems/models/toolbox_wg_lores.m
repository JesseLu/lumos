%% toolbox_wg_lores
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

function toolbox_wg_lores()

    % If a free-space wavelength is 40 grid points, 
    % and we want that to correspond to 1550 nm,
    % then the grid spacing is 38.75 nm.
    grid_spacing = 1550/40;

    % We assume a slab thickness of 220 nm.
    slab_thickness = 220/40;




