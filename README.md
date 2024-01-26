## Owland8

This is the README for owland8.

### Environment

Check the file startup.m in the repo's base folder to make sure your Matlab path is set. 

### Startup

This is the original way to start owland. When run this way, you can access noisetone through the "Test" menu. 

```
>> Aud_Space('online_Extended');
```

You can just run noisetone without all the other owland dialogs:

```
>> Aud_Space('online_Extended', 'expt', 'noisetone');
```

The first argument is the basename of a *.mat* file in the folder *Aud_Space/Defaults*. In the example above, it is the file *Aud_Space/Defaults/online_Extended.mat*. This file contains two structs that are used throughout the original owland code. See this page for more on these structs. This file must be found and loaded. 

Next, three more files containing calibration constants are loaded. The files and their usage are:

The files must exist in the folder *computer_specific_calibrations*.


| File                   |     what is it?     |
|------------------------|---------------------|
| vis_*<rig>*.mat        | visual calibrations |
| EQ_file_*<rig>*.mat    | L/R equalization    |
| gamma_inv_*<rig>*.mat  | inverse gamma table |


### Notes

**screen_offset**

####