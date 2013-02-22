% Get the thermal shifts
function get_thermal_shifts()
    delta_eps = 0: 0.3 : 1.2;
    eps0 = 12.25;

    % Find delta n
    for i = 1 : length(delta_eps)
        delta_n(i) = sqrt(eps0+delta_eps(i)) - sqrt(eps0);
    end

    % Find the temperature shifts
    % Assumes delta_n / delta_T = 1.85e-4.
    % Obtained from J. Pan et al, "Aligning microcavity resonances in silicon photonic crystals with laser-pumped thermal tuning", Applied Physics Letters, vol. 92, art. No. 103114 (2008).
    delta_T = delta_n / 1.85e-4 
