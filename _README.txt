System Requirements: 
Windows OS (we use Microsoft Windows XP Version 5.1 (Build 2600: Service Pack 3)).
MATLAB Version 6.5.1.199709 (R13) Service Pack 1 
Psychtoolbox-2 (Ive included this in the zip file). 
TDT Hardware (Tucker Davis Technologies)

Installation:
Copy OwlLand_ForWillDeBello into a folder. Move the "Psychtoolbox" subfolder into MATLAB/toolbox/, where MATLAB is your MATLAB folder. 

Usage:
Matlab needs to be run with the Java VM disabled (Can do this by right clicking on the MATLAB icon, selecting "Properties", and typing the following in the "Target" field: 
C:\MATLAB6p5p1\bin\win32\matlab.exe -nojvm 

To run the package, change directory within the MATLAB environment to OwlLand_ForWillDeBello/Aud_Space/
and type the following at the command prompt:
aud_space('online');

Notes: 
1. Need to set various default parameters in  Aud_Space/Defaults/online.mat in the structure snd.
For instance: 
snd.rig_room (and snd.rigs): names of computers that the package will be running on.
Also, the distance of the screen from the projector needs to be specified. 

2. The package will not run on newer MATLAB versions because: The visual stimulus presentation code in the package is written using Psychtolbox-2 (PTB-2), and PTB-2 is not supported by any of the recent versions. The latest version of PTB is PTB-3, and this is supported by the recent MATLAB versions; however, PTB-3 and PTB-2 are not fully intercompatible. 

3. Please feel free to email me (shreesh@stanford.edu) if you have questions. 

Credits: Knudsen Lab. The package was written by Joe Bergan (currently at Harvard). Since then each of us has made modifications to it (Ilana Witten, Kristin Maczko,Dan Winkowski, Shreesh Mysore, Ali Asadollahi). 
6.11.2010



