%this section loads the map 'RectangularFloor.stl' into the siteviewer
%required for raytracing environment and visualization later on in 3D view

mapFileName = "RectangularFloor.stl";
viewer = siteviewer("SceneModel",mapFileName,"Transparency",0.25);
%%
%this section is just for viewing the exact 3D space coordinates of the
%loaded map, and therefore is not necessary to run for results

floor3Dview = stlread("RectangularFloor.stl");
trimesh(floor3Dview);
%% 
%this section is for designing antennas at specific frequencies before
%creating transmitter and receiver sites

hant = design(dipoleCylindrical, 1.9e9);
pattern(hant, 1.9e9);
%%
%this section is for creating transmitter sites with its parameters

%show(tx) simply displays the transmitter site in the siteviewer in 3D

tx = txsite("CoordinateSystem","cartesian","AntennaPosition",[5000;0;1.5],"TransmitterFrequency",1.9e9,"TransmitterPower",10,"SystemLoss",0,"Antenna",hant);
show(tx)
%% 
%this section initializes 5000 receiver sites along the floor, by first
%creating an empty array to store positions and then loading the desired
%positions in them as well as all parameters being included for each one of
%the receivers

%show(rx) simply displays all the receivers in the siteviewer in 3D

names = strcat('rec', string(1:5000));
positions = zeros(3, 5000);
x_values = (4998:-2:-5000)';
positions(1, :) = x_values;
positions(2, :) = 0; 
positions(3, :) = 1.5; 
rx = rxsite("Name",names,"CoordinateSystem","cartesian","AntennaPosition",positions,"ReceiverSensitivity",-500,"SystemLoss",0,"Antenna",hant);
show(rx)
%% 
%this section creates the raytracing propagation model, and is very
%important including the two sites and the map above

pm = propagationModel("raytracing","CoordinateSystem","cartesian","Method","sbr","AngularSeparation",'low',"MaxNumReflections",1,"MaxNumDiffractions",0,"MaxRelativePathLoss",Inf);
%% 
%this section performs the raytracing using the map, sites and the
%propagation model constructed above

%the tic and toc function is simply put to calculate elapsed time taken to
%conduct the ray tracing

tic
    rays = raytrace(tx, rx, pm, "Map",viewer);
toc
%% 
%this section calculates the number of received rays per receiver after running raytrace
%function

%the writetable function is optional, in case the results need to be output
%locally in a .csv file for the received rays with any name  for the file

raysperreceiver = zeros(1, 5000);
for i = 1:5000
    raysperreceiver(i) = numel(rays{i});
end
dataTable = table(names', raysperreceiver', 'VariableNames', {'Receiver', 'RaysPerReceiver'});
disp(dataTable);
writetable(dataTable, 'receivedraysFloor.csv');
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
    for i = 1:5000
        plot(rays{i})
        
    end
toc
%%
%this section alculates the recevied signal strength per receiver
%corresponding to the same receiver number

%the writetable function is also optional here, in case the values of
%received signal strength need to be saved into .csv file

%the second variable used for the signal strength is customizable, but not
%really necessary

ss = sigstrength(rx,tx,pm,"Map",viewer);
ssperreceiver = zeros(1,5000);
for i = 1:5000
    ssperreceiver(i) = (ss(i));
end
dataTable = table(names', ssperreceiver', 'VariableNames', {'Receiver', 'SigStrengthPerReceiver'});
disp(dataTable);
writetable(dataTable, 'signalstrengthFloor.csv');

