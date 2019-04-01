# LpSolve IDE(Integrated Development Interface)
Port LpSolve IDE v5.5.2.3 under Lazarus([Lpsolve home](https://sourceforge.net/projects/lpsolve/)).
![LPSolve IDE on Ubuntu-MATE](https://github.com/avk959/LazLpSolveIDE/blob/master/LpSolveIDE-gtk-2.png)
### To compile LpSolveIDE under Lazarus IDE:
 - compile and install(optional) /packages/lazlpsolver/lazlpsolver.lpk.
  * note: installing the package is only necessary if you are going to edit MainForm,
          in this case, you need to download the appropriate liblpsolve55 binary from the official website 
          and make sure liblpsolve55 is available for the Lazarus IDE. 
 - open and compile /source/LpSolveIDE.lpi.
### To make linux stand-alone application:
 - create application folder(denote AppFolder)
 - put into AppFolder LpSolveIDE binary.
 - put into AppFolder liblpsolve55 binary.
 - download from the official website and put into AppFolder all needed extention binaries(BFP and XLI).
 - download from the official website and put into AppFolder CHM help file.  
 - put into AppFolder LpSolveIDE.ini.
 - run the application using(as variant) a bash script:
```
#!/usr/bin/env bash
AppFolderPath=path-to-AppFolder
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$AppFolderPath"
cd $AppFolderPath
./LpSolveIDE 
```
#### A remark about CHM help file:
If you have a program for reading CHM files on your computer, 
and the CHM format is known system-wide, then nothing else needs to be done.
If the CHM format is not known system-wide, 
you need to add in the [Help] section of the LpSolveIDE.ini the line 
"ChmFileReader=chm-help-reader-full-file-name" (without quotes).
If there is no program for reading CHM files,
you can use lhelp from the Lazarus installation (in /components/chmhelp/lhelp).
Compile lhelp, place it in the AppFolder and add the line "ChmFileReader=lhelp"(without quotes) 
in the [Help] section of the LpSolveIDE.ini.

 