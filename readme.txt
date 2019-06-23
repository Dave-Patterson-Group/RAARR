How to run the autoassign.

The trickiest part of the setup is installing spfit and spcat.  This is because these executables and
the input/output files associated with them cannot live in Dropbox; if you put them in dropbox it quickly bogs 
down as hundreds of files are created and erased. To do this you will have to edit the function getspfitpath. 
Directions for doing this are in getspfitpath.m, and also below 

%to set up on a new computer: copy the contents of the folder ./local_files
%into a local (non-dropbox) directory, such as
%'C:\Users\PattersonGroup\spcatfiles'.

%specifically, your new directory should contain:
%pgo.exe
%spcat_64bit_zk.eke
%spfit_64bit_zk.eke

Once this is done, the simplest way to run it on a file is, for example

>>autofit('nopinone');

This runs the scaffold algorithm (the one described in the RAARR paper) on the file
./Molecules/Nopinone/Nopinone.csv (not case sensitive)

It will plot a bunch of stuff on the screen, and also produce files

./Molecules/Nopinone/Nopinonefig.fig (matlab figure)
./Molecules/Nopinone/Nopinone.pdf (pdf showing fits)
./Molecules/Nopinone/nopinone_comp1.pgo (pgopher file of first found conformer)

Running this takes some time - it finds the first conformer quickly, and then slows down.

You can also run

>>autofit('nopinone','scaffold'); 

which does the same thing as above, or

>> autofit('nopinone','atype');

which runs the a-type algorithm.  For now, to run a new spectrum, I would recommend making a 
directory like the one shown.

I do not have detailed documentation of the internal code; this is in progress. However, an important
high level function is settingsfromtightness(), which contains all the global settings - how tight
series have to be, how many components there can be, time limits, etc, etc.  The idea is that a single 
setting works for all molecules, and this largely seems to be true.

It's illuminating to explore how the algorithm does on fake data.  The simplest script that does this is
singlefake();
which can be run just as is, or edited to change molecular constants, and also the range of the spectrometer.  
The fake data found by this method contains the various distortions described in the RAARR paper

 