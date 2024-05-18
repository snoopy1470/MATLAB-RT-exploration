%this section loads the map 'RectangularTunnel8T.stl' into the siteviewer 
%required for raytracing environment and visualization later on in 3D view

%other variants constructed using different number of triangles can be
%tried out through loading in the parameter

mapFileName = "RectangularTunnel8T.stl";
viewer = siteviewer("SceneModel",mapFileName,"Transparency",0.25);
%%
%this section is just for viewing the exact 3D space coordinates of the
%loaded map, and therefore is not necessary to run for results

tunnel3Dview = stlread("RectangularTunnel8T.stl");
trimesh(tunnel3Dview);
%% 
%this section is for designing antennas at specific frequencies before
%creating transmitter and receiver sites

hant = design(horn, 9e8);
pattern(hant, 9e8);
%%
%this section is for creating transmitter sites with its parameters

%show(tx) simply displays the transmitter site in the siteviewer in 3D

tx = txsite("CoordinateSystem","cartesian","AntennaPosition",[1250.0001717;-1.95004747;-0.6503737],"TransmitterFrequency",9e8,"TransmitterPower",2.5119,"SystemLoss",0,"Antenna",hant);
show(tx)
%% 
%this section initializes 1250 receiver sites along the tunnel, by first
%creating an empty array to store positions and then loading the desired
%positions in them as well as all parameters being included for each one of
%the receivers

%show(rx) simply displays all the receivers in the siteviewer in 3D

names = strcat('rec', string(1:1250));
positions = zeros(3, 1250);
x_values = (1248.00017:-2.00000:-1250.00017)';
positions(1, :) = x_values;
positions(2, :) = -1.95037; 
positions(3, :) = -0.65047; 
rx = rxsite("Name",names,"CoordinateSystem","cartesian","AntennaPosition",positions,"ReceiverSensitivity",-500,"SystemLoss",0,"Antenna",hant);
show(rx)
%%
%this section creates the raytracing propagation model, and is very
%important including the two sites and the map above

pm = propagationModel("raytracing","CoordinateSystem","cartesian","Method","sbr","AngularSeparation","low","MaxNumReflections",1,"MaxNumDiffractions",0,"MaxRelativePathLoss",Inf,"SurfaceMaterial","custom","SurfaceMaterialConductivity",0.01,"SurfaceMaterialPermittivity",5);
%%
%this section performs the raytracing using the map, sites and the
%propagation model constructed above

%the tic and toc function is simply put to calculate elapsed time taken to
%conduct the ray tracing

tic
    rays = raytrace(tx, rx, pm, "Map",viewer);
toc
%%
%this section alculates the recevied signal strength per receiver
%corresponding to the same receiver number

%the writetable function is also optional here, in case the values of
%received signal strength need to be saved into .csv file

%the second variable used for the signal strength is customizable, but not
%really necessary

%the post-processing for the gain of +7dBi must be done in this section
%accordingly on the signal strength values according to the simplified
%theoretical equation for received power output in dBm. A horn antenna
%existing in this script has a gain of +15.5dBi operating at 900MHz

ss = sigstrength(rx,tx,pm,"Map",viewer);
ssperreceiver = zeros(1,1250);
for i = 1:1250
    ssperreceiver(i) = (ss(i));
end
dataTable = table(names', ssperreceiver', 'VariableNames', {'Receiver', 'SigStrengthPerReceiver'});
disp(dataTable);
writetable(dataTable, 'signalstrengthTunnel.csv');
%%
%this section calculates the number of received rays per receiver after running raytrace
%function

%the writetable function is optional, in case the results need to be output
%locally in a .csv file for the received rays with any name  for the file

raysperreceiver = zeros(1, 1250);
for i = 1:1250
    raysperreceiver(i) = numel(rays{i});
end
dataTable = table(names', raysperreceiver', 'VariableNames', {'Receiver', 'RaysPerReceiver'});
disp(dataTable);
writetable(dataTable, 'receivedraysTunnel.csv');
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
    for i = 1:1250
        plot(rays{i})
        
    end
toc