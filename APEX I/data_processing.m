clc
clear
close all

launch = 'APEXI-jul02';

col1 = '#2978a0';
col2 = '#BA1200';
col3 = '#3EC300';
col4 = '#3C153B';
lw = 1;
    
[t, alt, vel, temp, voltage] = pnut_extractor(launch);

data = parse(launch);

figure
hold on
plot(t, data.acc_x, 'LineWidth', lw, 'Color', col1)
plot(t, data.acc_y, 'LineWidth', lw, 'Color', col2)
plot(t, data.acc_z, 'LineWidth', lw, 'Color', col3)
plot(t, data.acc_mag, 'LineWidth', 1, 'Color', col4)
title('Acceleration - Custom');
xlabel('Time (s)')
ylabel('Acceleration (m/s^2)')
legend('x', 'y', 'z', 'Magnitude', 'Location', 'best')

function data = unpack(launch)
    
    if isfile(sprintf('%s-custom_parsed.csv', launch))
        disp ('Bin already parsed, importing data');
    else
        command = sprintf("python parser.py %s-custom", launch);
        fprintf('Parsing data from %s launch \n', launch);
        status = system(command, '-echo');
        if status ~= 0
            error('An error occured while parsing, please try again.');
        end
    end
    data = readmatrix(sprintf('%s-custom_parsed.csv', launch));
    
end

function data = parse(launch)

    G = 9.8065;
    
    start = 2000;
    finish = 4000;
    
    raw = unpack(launch);
    data = struct();
    data.time = raw(start:finish, 1)/1000; % ms to s
    % shift t values to recording start
    data.time = data.time - min(data.time);

    data.acc_x = raw(start:finish, 2)*G;
    data.acc_y = raw(start:finish, 3)*G;
    data.acc_z = raw(start:finish, 4)*G;
    data.gyro_x = raw(start:finish, 5);
    data.gyro_y = raw(start:finish, 6);
    data.gyro_z = raw(start:finish, 7);
    data.mag_x = raw(start:finish, 8);
    data.mag_y = raw(start:finish, 9);
    data.mag_z = raw(start:finish, 10);
    data.linacc_x = raw(start:finish, 11)*G;
    data.linacc_y = raw(start:finish, 12)*G;
    data.linacc_z = raw(start:finish, 13)*G;
    data.geomag_i = raw(start:finish, 14);
    data.geomag_j = raw(start:finish, 15);
    data.geomag_k = raw(start:finish, 16);
    data.geomag_w = raw(start:finish, 17);
    data.rot_i = raw(start:finish, 18);
    data.rot_j = raw(start:finish, 19);
    data.rot_k = raw(start:finish, 20);
    data.rot_w = raw(start:finish, 21);
    data.pressure = raw(start:finish, 22)*100;
    data.temp = raw(start:finish, 23);
    
    data.altitude = atmospalt(data.pressure);
    data.acc_mag = sqrt(data.acc_x.^2 + data.acc_y.^2 + data.acc_z^2);
    
end




