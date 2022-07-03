clc
clear

launch = 'APEXI-jul02';
[t, alt, vel, temp, voltage] = pnut_extractor(launch);
raw = unpack(launch);


function data = unpack(launch)

    command = sprintf("python parser.py %s-custom", launch);
    fprintf('Parsing data from %s launch \n', launch);
    status = system(command);
    data = readmatrix(sprintf('%s-custom_parsed.csv', launch));
    
end

