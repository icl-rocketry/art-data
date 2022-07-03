function [t, alt, vel, temp, voltage] = pnut_extractor(launch)
    ft_conv = 0.3048;
    data = readmatrix(sprintf('%s.pf2', launch), 'NumHeaderLines', 11, 'FileType', 'text');

    % params in real units
    t = data(:, 1);
    alt = data(:, 2)*ft_conv;
    vel = data(:, 3)*ft_conv;
    temp = data(:, 4);
    voltage = data(:, 5);
end

