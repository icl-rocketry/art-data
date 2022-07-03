clc
clear

launch = 'APEXI-jul02';
[t, alt, vel, temp, voltage] = pnut_extractor(launch);



function data = unpack(launch)

    command = sprintf("python parser.py %s-custom", launch);
    fprintf('Parsing data from %s launch \n', launch);
    status = system(command);
    data = readmatrix(sprintf('%s-custom_parsed.csv', launch));
    
end

function data = parse(launch)
    start = 2000;
    finish = 4000;
    
    raw = unpack(launch);
    data = struct();
    data.time = raw(start:finish, 1)/1000;
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
    data.pressure = raw(start:finish, 22);
    data.temp = raw(start:finish, 23);
    
end

