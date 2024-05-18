# Scripts and Materials for MATLAB SBR Evaluation 
### (This repository is supplementary material for the relevant conference paper)

_Please read the instructions carefully in order to run the MATLAB simulations accordingly using the right loaded data!_

+ Requirements
  
  Ensure that the latest version of MATLAB is installed prior to the testing and running of simulations using the provided material. At the time of research, version R2024a was used. Furthermore, the Antenna Toolbox and the Communications Toolbox is installed along the basic default suite upon installation. Head over to [Get MATLAB](https://www.mathworks.com/products/matlab.html) for the installation. It is recommended to install most Toolbox options, in case further exploration alongside provided scripts is desired. The machine running the program must have a minimum of 8-10 GB of DDR4 RAM, and an AMD Ryzen 5 5600H, alongside a decently capable graphics card to avoid extra lengthy simulation times.

+ Structure of Repository
  
  This repository contains 3 maps, in the form of 5 STL files constructed in Blender:
  * RectangularFloor.stl
  * RectangularRoom.stl
  * RectangularTunnel8T.stl
  * RectangularTunnel16T.stl
  * RectangularTunnel24T.stl
    
  The names of the maps are pretty self-explanatory. The 3 variants of the tunnel environment provided are the total number of triangles used for map construction, being 8, 16 and 24 respectively. The reason for using STL files here is due to automatic triangulation beforehand. There are also 3 major scripts provided, namely:
  * RectangularFloor.m
  * RectangularRoom.m
  * RectangularTunnel.m
    
  The names of the scripts are also self explanatory in terms of which script belongs to which environment.

+ Usage Details
  
  Each script will be commented and split up into sections describing the exact purpose of running that section. Additional experimentation in the existing scripts must be done in different sections, and the relevant previous sections must be run accordingly for the newer ones as desired. If further immediate help is needed without referring to the documentation for any existing function in the sections provided, right-click the function name and select `Help on "function name"`. It is necessary that the scripts are run sequentially, by `Run Section` or `Run and Advance` within any section currently selected, to avoid confusion and errors in loading the parameters.

  Aside from comments, most variables in the scripts will have values filled in already, based on the simulation parameters described in the paper. Other values or parameters might need to be filled in properly if they are a result of values from previous sections, and for this case any variable can be created to store such values and referenced properly. Keep in mind, the style used to code the scripts is completely personal, and is not necessarily important to run exactly in that fashion if only certain sections or values are needed. 

If any help regarding specific details for the project is needed, reach out to me anytime at:
> saadhum50@gmail.com







