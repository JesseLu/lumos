Description
-----------

The purpose of these problems is to demonstrate the capabilities of the ob-1 package.


A collection of nanophotonic design problems that can be solved.

Most design problems are derived from models which provide 
a basic problem layout.
Furthermore, some of these models are based on 
a small set of standard waveguides.


Problems
--------

*   Waveguide mode converters: 
    an introduction to what ob-1 is capable of.
    *   wmc_te: TE mode converter that converts the fundamental TE mode to the 
        second order TE mode.
        Introduces the "feel" of objective-first design, as well as 
        the idea of rejection modes.
    *   wmc_tm: TM version of wmc_te.

*   Splitters:
    individually illustrate the different "dimensions"
    along which we may design structures.
    *   spl_modal: splits first and second order TE modes.
    *   spl_tetm: splits fundamental TE and TM modes.
    *   spl_wdm: wavelength splitter.
    *   spl_wdm_flat: wavelength splitter with top-hat response.
        This should also demonstrate robustness to temperature and 
        fabrication error.

*   Switches/Hubs:
    show that the sky is the limit in terms of in-plane devices.
    *   hub_3x3: 3 input and output ports each, with 3 wavelengths in each.
    *   hub_4x4, hub_5x5, hub_6x6: extensions of hub_3x3.
        Rejection modes and top-hat response can be added in an additional step
        after the main design, in order to make computation more efficient.

*   Fiber couplers:
    show that we can couple out-of-plane, to optical fiber modes.
    Note that single-mode fibers have core diameters of around 8-10 microns.
    This may need to be decreased to make things more tractable.
    Also, make sure that the degeneracy in the fiber modes is split.
    *   fib_te: couple from fiber to fundamental TE mode of a waveguide.
    *   fib_pol: couple the two fundamental modes of the fiber to 
        the TE mode of one waveguide, and the TM mode of another.
    *   fib_wdm: couple three fiber modes of the same polarizations but
        different wavelengths to three separate waveguides.
    *   fib_focus: concentrate light from a fiber to a central point in the plane.
    *   fib_focus2: same as fib_focus, but also concentrate light at the double
        (or half) frequency as well.
        Useful for frequency doubling.

*   Free-space devices:
    show that we can also do non-nanophotonic devices.
    Make sure that the degeneracy is split here as well.
    *   fsd_solar: make a "black" silicon device, which absorbs all
        incoming sunlight (free-space modes) and reflects none.
        Most likely just want to do this at a single frequency, 
        near the max of the solar spectrum for a silicon cell.
    *   fsd_sort: concentrate red, green, and blue frequencies as well as 
        their two polarizations to six different spots.
        Has use for Si CMOS detectors (photography).
    *   fds_lens: concentrate a single wavelength to a point in free-space,
        just like a lens.
        


Problem specification
---------------------

*   The opt_prob structure is the primary specification created by each problem.


