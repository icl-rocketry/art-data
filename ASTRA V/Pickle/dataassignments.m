clear

data = readmatrix("telemetrylog.txt");

lowtime = 1060;
hightime = 1100;

data(:,45) = (data(:,45) - data(1,45))/10^6;

trim = data(data(:,45) > lowtime,:);
trim = trim(trim(:,45) < hightime,:);
time = trim(:,45);

gps_long = trim(:,1);
gps_lat = trim(:,2);
gps_alt = trim(:,3);

gps_vn = trim(:,4);
gps_ve = trim(:,5);
gps_vd = trim(:,6);

gps_sat = trim(:,7);
gps_fix = trim(:,8);

ax = trim(:,9);
ay = trim(:,10);
az = trim(:,11);

h_ax = trim(:,12);
h_ay = trim(:,13);
h_az = trim(:,14);

gx = trim(:,15);
gy = trim(:,16);
gz = trim(:,17);

mx = trim(:,18);
my = trim(:,19);
mz = trim(:,20);

imu_temp = trim(:,21);

baro_alt = trim(:,22);
baro_temp = trim(:,23);
baro_press = trim(:,24);

batt_volt = trim(:,25);
batt_percent = trim(:,26);

roll = trim(:,27);
pitch = trim(:,28);
yaw = trim(:,29);

q0 = trim(:,30);
q1 = trim(:,31);
q2 = trim(:,32);
q3 = trim(:,33);

pn = trim(:,34);
pe = trim(:,35);
pd = trim(:,36);

vn = trim(:,37);
ve = trim(:,38);
vd = trim(:,39);

an = trim(:,40);
ae = trim(:,41);
ad = trim(:,42);

rssi = trim(:,43);
snr = trim(:,44);