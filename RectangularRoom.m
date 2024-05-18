%This section loads the map 'RectangularRoom.stl' into the siteviewer.
%Required for raytracing environment and visualization later on in 3D view

mapFileName = "RectangularRoom.stl";
viewer = siteviewer("SceneModel",mapFileName,"Transparency",0.25);
%%
%this section is just for viewing the exact 3D space coordinates of the
%loaded map, and therefore is not necessary to run for results

room3Dview = stlread("RectangularRoom.stl");
trimesh(room3Dview);
%% 
%this section is for designing antennas at specific frequencies before
%creating transmitter and receiver sites

hant = design(dipoleCylindrical, 1.9e9);
pattern(hant, 1.9e9);
%% 
%this section is for creating transmitter sites with its parameters

%show(tx) simply displays the transmitter site in the siteviewer in 3D

tx = txsite("CoordinateSystem","cartesian","AntennaPosition",[0.0001717;3.5004747;1.0003737],"Antenna",hant,"TransmitterFrequency",1.9e9,"TransmitterPower",10);
show(tx)
%% 
%this section initializes 135 receiver sites across the room in a grid, by first
%creating an empty array to store positions and then loading the desired
%positions in them as well as all parameters being included for each one of
%the receivers

%show(rx) simply displays all the receivers in the siteviewer in 3D

names = strcat('rec', string(1:135));
positions = zeros(3, 135);
positions(3, :) = -0.50047; 
index = 1;
for i = -3.50037:0.5:3.50037
    for j = -2.00017:0.5:2.00017
        positions(1, index) = j;
        positions(2, index) = i;
        index = index + 1;
        if index > 135
            break;
        end
    end
    if index > 135
        break;
    end
end
rx = rxsite("Name",names,"CoordinateSystem","cartesian","AntennaPosition",positions,"Antenna",hant,"ReceiverSensitivity",-500,"SystemLoss",0);
show(rx)
%% 
%this section creates the raytracing propagation model, and is very
%important including the two sites and the map above

pm = propagationModel("raytracing","CoordinateSystem","cartesian","Method","sbr","AngularSeparation","low","MaxNumReflections",5,"MaxNumDiffractions",0,"MaxRelativePathLoss",Inf);
%% 
%this section performs the raytracing using the map, sites and the
%propagation model constructed above

%the tic and toc function is simply put to calculate elapsed time taken to
%conduct the ray tracing

tic
    rays = raytrace(tx, rx, pm, "Map",viewer);
toc 
%% 
%for counting the total number of rays received for the entire simulation,
%summing up the values per receiver

totalcount = 0;
for i = 1:numel(rays)
    totalcount = totalcount + numel(rays{i});
end
totalcount
%% 
%this section allows 3D visualization of all received ray paths in the
%siteviewer

%the tic toc function here is optional, to time the visualization of the
%paths in 3D

tic
    for i = 1:135
        plot(rays{i})
        
    end
toc
%%
%this section calculates the number of received rays per receiver after running raytrace
%function

%the writetable function is optional, in case the results need to be output
%locally in a .csv file for the received rays with any name  for the file

raysperreceiver = zeros(1, 135);
for i = 1:135
    raysperreceiver(i) = numel(rays{i});
end
dataTable = table(names', raysperreceiver', 'VariableNames', {'Receiver', 'RaysPerReceiver'});
disp(dataTable);
writetable(dataTable, 'receivedraysRoom.csv');
%%
%this section alculates the recevied signal strength per receiver
%corresponding to the same receiver number

%the writetable function is also optional here, in case the values of
%received signal strength need to be saved into .csv file

%the second variable used for the signal strength is customizable, but not
%really necessary

ss = sigstrength(rx,tx,pm,"Map",viewer);
ssperreceiver = zeros(1,135);
for i = 1:135
    ssperreceiver(i) = (ss(i));
end
dataTable = table(names', ssperreceiver', 'VariableNames', {'Receiver', 'SigStrengthPerReceiver'});
disp(dataTable);
writetable(dataTable, 'signalstrengthRoom.csv');
%%
%this section is included simply due to the complexity of the heatmap area
%plot for the room coverage in terms of signal strength

%the plot is completely optional, but requires certain values to be played
%with including the colormap in order to get desired output

x_limits = [-2.0001717, 2.0001717];
y_limits = [-3.5003737, 3.5003737];
x_receivers = positions(1, :);
y_receivers = positions(2, :); 
ss_matrix = reshape(ssperreceiver, [15, 9]);
ss_vector = ss_matrix(:);
[x_fine, y_fine] = meshgrid(linspace(x_limits(1), x_limits(2), 300), ...
                            linspace(y_limits(1), y_limits(2), 300));
ss_fine = griddata(x_receivers, y_receivers, ss_vector, x_fine, y_fine, 'cubic');
figure;
imagesc(x_fine(1, :), y_fine(:, 1), ss_fine);
colormap('jet');
colorbar;
hcb = colorbar;
ylabel(hcb, 'Received signal strength (dBm)');
hold on;
xlim(x_limits);
ylim(y_limits);
xlabel('Receiver grid width (m)');
ylabel('Receiver grid length (m)');
pbaspect([1 1 1]);
hold off;
