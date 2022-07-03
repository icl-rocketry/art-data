clc
clear
close all

set(0, 'DefaultLineLineWidth', 1.4);
%set(0, 'DefaultAxesFontSize', 20);

launch = 'APEXI-jul02';
[t, alt, vel, temp, voltage] = pnut_extractor(launch);

fig = figure;
plot(t,alt)
xlabel('Time (s)', 'Interpreter','latex','FontSize',12)
ylabel('Unfiltered altitude (m)', 'Interpreter','latex','FontSize',12)
box on
grid minor
set(gca,'TickLabelInterpreter','latex')
set(gca,"FontSize",12)
ylim([0 3000])
fig.Position = [100 100 800 800*9/16];

filtered_alt = smooth(alt,20);

fig = figure;
plot(t,filtered_alt)
xlabel('Time (s)', 'Interpreter','latex','FontSize',12)
ylabel('Unfiltered altitude (m)', 'Interpreter','latex','FontSize',12)
box on
grid minor
set(gca,'TickLabelInterpreter','latex')
set(gca,"FontSize",12)
ylim([0 3000])
fig.Position = [100 100 800 800*9/16];

filtered_vel = zeros(1,length(alt));

for i = 2:length(filtered_vel)

    filtered_vel(i) = (filtered_alt(i)-filtered_alt(i-1))/(t(2)-t(1));

end

filtered_vel = smooth(filtered_vel,15);

fig = figure;
plot(t,filtered_vel)
xlabel('Time (s)', 'Interpreter','latex','FontSize',12)
ylabel('Unfiltered altitude (m)', 'Interpreter','latex','FontSize',12)
box on
grid minor
set(gca,'TickLabelInterpreter','latex')
set(gca,"FontSize",12)
fig.Position = [100 100 800 800*9/16];

fig = figure;
title('APEX 03/07/2022 Launch - Pnut Data','Interpreter','latex','FontSize',12)
yyaxis left
plot(t,filtered_alt)
ylabel('Altitude (m)', 'Interpreter','latex','FontSize',12)
xline(2.9,'k--')
yline(2845,'k--')
text(100,2700,'Apogee = 2845 m','Interpreter','latex','FontSize',12)
text(100,2700,'Apogee = 2845 m','Interpreter','latex','FontSize',12)
yyaxis right
plot(t,filtered_vel)
ylabel('Velocity (ms$^{-1}$)', 'Interpreter','latex','FontSize',12)
xlabel('Time (s)', 'Interpreter','latex','FontSize',12)
box on
grid minor
set(gca,'TickLabelInterpreter','latex')
set(gca,"FontSize",12)
fig.Position = [100 100 800 800*9/16];
saveas(gca,'APEX_pnut_plot_vect','epsc')
saveas(gca,'APEX_pnut_plot','png')

%%
clc
clear
close all

set(0, 'DefaultLineLineWidth', 1.4);
%set(0, 'DefaultAxesFontSize', 20);

launch = 'APEXI-jul02';
[t, alt, vel, temp, voltage] = pnut_extractor(launch);