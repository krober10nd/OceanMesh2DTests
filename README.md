

First run PostSandyDatasetPreprocessor.sh</br>
It requires wget and gdal.</br>
If using Windows, you can run this bash script on a POSIX layer such as MIGW64 or Cygwin.</br>
Then you can run PostSandyTileTests.m</br>


-------------------
Error log:</br>
</br>
##### e2db1ae

Error using  >=
Matrix dimensions must agree.

Error in GridData (line 122)
I = find(DEM_XA >= lon_min & DEM_XA <= lon_max);

Error in msh/interp (line 557)
                        obj = GridData(geodata{i},obj);

Error in PostSandyTilesTest (line 40)
m = interp(m,gdat);
</br>