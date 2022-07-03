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
plot(data.time, data.altitude, 'LineWidth', lw, 'Color', col1)
title('Altitude ASL (m)')
xlabel('Time (s)')
ylabel('Altitude')
exportgraphics(gcf, sprintf('%s_DPSalt.png', launch), 'Resolution', 600);


figure
hold on
plot(data.time, data.acc_x, 'LineWidth', lw, 'Color', col1)
plot(data.time, data.acc_y, 'LineWidth', lw, 'Color', col2)
plot(data.time, data.acc_z, 'LineWidth', lw, 'Color', col3)
plot(data.time, data.acc_mag, 'LineWidth', 1, 'Color', col4)
title('Acceleration');
xlabel('Time (s)')
ylabel('Acceleration (ms^{-1})')
legend('x', 'y', 'z', 'Magnitude', 'Location', 'best')
exportgraphics(gcf, sprintf('%s_acceleration.png', launch), 'Resolution', 600);


figure
hold on
plot(data.time, data.linacc_x, 'LineWidth', lw, 'Color', col1)
plot(data.time, data.linacc_y, 'LineWidth', lw, 'Color', col2)
plot(data.time, data.linacc_z, 'LineWidth', lw, 'Color', col3)
title('Linear Acceleration');
xlabel('Time (s)')
ylabel('Acceleration (ms^{-1)}')
legend('x', 'y', 'z', 'Location', 'best')
exportgraphics(gcf, sprintf('%s_linacc.png', launch), 'Resolution', 600);


figure
hold on
plot(data.time, data.gyro_x, 'LineWidth', lw, 'Color', col1)
plot(data.time, data.gyro_y, 'LineWidth', lw, 'Color', col2)
plot(data.time, data.gyro_z, 'LineWidth', lw, 'Color', col3)
title('Rotation');
xlabel('Time (s)')
ylabel('Angular Velocity (rads^{-1}')
legend('x', 'y', 'z', 'Location', 'best')

figure
hold on
plot(data.time, data.phi, 'LineWidth', lw, 'Color', col1)
plot(data.time, data.theta, 'LineWidth', lw, 'Color', col2)
plot(data.time, data.psi, 'LineWidth', lw, 'Color', col3)
title('Orientation');
xlabel('Time (s)')
ylabel('Angle (deg)')
legend('phi', 'psi', 'theta', 'Location', 'best')
exportgraphics(gcf, sprintf('%s_gyro.png', launch), 'Resolution', 600);


figure
hold on
plot(data.time, data.phi, 'LineWidth', lw, 'Color', col1)
plot(data.time, data.theta, 'LineWidth', lw, 'Color', col2)
plot(data.time, data.psi, 'LineWidth', lw, 'Color', col3)
title('Orientation');
xlabel('Time (s)')
ylabel('Angle (deg)')
legend('phi', 'psi', 'theta', 'Location', 'best')
exportgraphics(gcf, sprintf('%s_orientation.png', launch), 'Resolution', 600);


figure
plot(data.time, data.temp, 'LineWidth', lw, 'Color', col1)
title('Temperature (C)')
xlabel('Time (s)')
ylabel('Teperature')
exportgraphics(gcf, sprintf('%s_temp.png', launch), 'Resolution', 600);


figure
plot(data.time, 'LineWidth', lw, 'Color', col1)
title('Data Capture')
xlabel('Data Points')
ylabel('Time Elapsed (s)')


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

    data.acc_x = raw(start:finish, 2);
    data.acc_y = raw(start:finish, 3);
    data.acc_z = raw(start:finish, 4);
    data.gyro_x = raw(start:finish, 5);
    data.gyro_y = raw(start:finish, 6);
    data.gyro_z = raw(start:finish, 7);
    data.mag_x = raw(start:finish, 8);
    data.mag_y = raw(start:finish, 9);
    data.mag_z = raw(start:finish, 10);
    data.linacc_x = raw(start:finish, 11);
    data.linacc_y = raw(start:finish, 12);
    data.linacc_z = raw(start:finish, 13);
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
    data.acc_mag = sqrt(data.acc_x.^2 + data.acc_y.^2 + data.acc_z.^2);
    [data.phi, data.theta, data.psi] = q2e(data.rot_i, data.rot_j, data.rot_k, data.rot_w);
    [data.geophi, data.geotheta, data.geopsi] = q2e(data.geomag_i, data.geomag_j, data.geomag_k, data.rot_w);
end

function [phi, theta, psi] = q2e(i, j, k, w)

    phi = atan((2*(i.*j + k.*w)/(1 - 2*(j.^2+k.^2))));
    theta = asin(2*(i.*k - j.*w));
    psi = atan((2*(i.*w + j.*k)/(1 - 2*(k.^2+w.^2))));
    
    phi = rad2deg(phi);
    theta = rad2deg(theta);
    psi = rad2deg(psi);
end



