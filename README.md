# Outline of RAARR code
Contact davepatterson@ucsb.edu for help.
This document outlines the algorithm described by the paper, “Automated, context-free assignment of asymmetric rotor microwave spectra,” by Lia Yeh, Lincoln Satterthwaite, and David Patterson, at  <https://doi.org/10.1063/1.5085794> or at <https://arxiv.org/abs/1812.06221>.
This document is available [here](https://docs.google.com/document/d/1NTClfHyvc3e374pUXlpBboRVQP3lmLa1WBqpqHNoN94/edit?usp=sharing).

The code is not really built for export at this time, but I will do my best to help other people install, and edit/port the code.  Part 1 of this document should help you install and run the code; part 2 gives a very bare-bones outline of the program flow.

## Part 1: Installing and running the code.

To install: Can only be installed on windows because it relies on SPFIT/SPCAT. 

Make a directory on your computer, and copy the entire contents of [this dropbox folder](https://www.dropbox.com/sh/i7sbe5zmnkr30sv/AACaXQZ2wT3ed5xuUPqZhqega?dl=0) or [this GitHub repo](https://github.com/DavePattersonGroup/RAARR) into it. This directory can be on a shared drive, like dropbox, or can be a “normal” directory. The directory cannot have spaces anywhere in its name (thanks Matlab)
run ‘autofit’.  This runs the scaffold algorithm on our recorded nopinone spectrum, which is stored in /Molecules/Nopinone/Nopinone.csv.  Editing the first few lines of autofit (in particular line 7) can run it on any other spectrum in the library. The command window will show lots of ‘in progress’ text, and after about 30 seconds it should bring up a window that looks like this:

![](https://raw.githubusercontent.com/DavePattersonGroup/RAARR/master/images/image1.png)

This gives a rather simple fit (one conformer, no CD) of nopinone.  It found 64 lines, and lists A,B, and C in the legend of the largest subplot. The upper left plot is the fit; the right hand plot is the scaffold used.

If SPFIT/SPCAT/pgo are not installed correctly, the scaffold will still be found, but no fit will be made

You can run autofit in many ways.  For example, to run it on any other molecule in the library, you can run for example
`autofit(‘myrtenal’);`
or
`autofit(‘florol’,’scaffold’);`
or
`autofit(‘florol’,’atype’);`
the second, optional argument tells autofit which algorithm to run; `‘scaffold’`, which is what is described in the RAARR paper, is the default; other options are `‘atype’`, which uses only a-type transitions, and `‘bowties’`, which uses the variant described in the RAARR paper supplementary and is on the bowties branch of the GitHub repo.

You can also run autofit on batches; this is essentially a requirement when you change the code or settings, because sometimes it stops working. The script that does this is `autofitcheck(method,cheatLevel)`.

### cheatLevel:
In several places, including in the top autofit function, the algorithm refers to cheatcodes, via the function `getCheatCodes(molname,cheatLevel)`.  Default cheatLevel is 0, and this is “no cheating”. Cheatlevel = 1 means we ‘guess’ the first frequency correctly. Cheatlevel=2 means we ‘guess’ the second correctly as well.  This makes everything run very fast, and is what I typically do if I’ve made a bunch of changes and want to quickly check if the algorithm still works on all the spectra, for example with `autofitcheck(method,cheatLevel)`. For everything in the paper, or for new molecules, obviously cheatLevel = 0


### Algorithm settings:

An important high level function is `settingsfromtightness()`, which sets many many parameters about  how tight series have to be, how many components there can be, time limits, etc, etc.  The idea is that a single setting works for all molecules, and this largely seems to be true.  For example, the code as exported is set to find only a single conformer and then quit; you can change this to “top 5 conformers” by editing line 98 of settingsfromtightness() to read:
`patternfitting.maxcomponents = 5;`

Most of the time, the settings which make a difference are the height settings.  How much can neighboring a-type transitions vary in height? How much can a-type vs b-type transitions vary in height? This is to some degree spectrometer dependent - we all know our spectrometers are not super reliable when it comes to signal strengths.



### getspfitpath:
I prefer to have the code in one directory, on the cloud, and spfit, spcat, and pgo in another local directory.  In order to do this you have to edit `getspfitpath.m`, and follow the directions within that file. In particular you should make a new (non-shared) directory, for example C:\Users\PattersonGroup\spcatfiles, containing the contents of the folder ./local_files .

specifically, your new directory should contain:
`pgo.exe`
`spcat\_64bit\_zk.exe`
`spfit\_64bit\_zk.exe`

You also need to change line 3 of `getspfitpath` to read `uselocal = 0;`, and add your new directory to the lists in `getspfitpath`.

### running on fake data:
It's illuminating to explore how the algorithm does on fake data.  The simplest script that does this is
`singlefake();`
which can be run just as is, or edited to change molecular constants, and also the range of the spectrometer.  

The fake data created by this method contains the various distortions described in the RAARR paper.  The parameters that control these distortions are found in
`defaultcsvargsin()` within `mkefakecsv()`

A successful fit on looks like:
![](https://raw.githubusercontent.com/DavePattersonGroup/RAARR/master/images/image2.png)

It also launches pgopher with the appropriate ‘data’, which should look like:
![](https://raw.githubusercontent.com/DavePattersonGroup/RAARR/master/images/image3.png)

This is useful for example to quickly check line assignments; the pgopher graphical interface is excellent.  The pgo files created this way are a bit strange; they are actually three different molecules, one with a-types, one with b-types, and one with c-types.  This is useful in some technical ways, but pedants might point out that Stark shifts in such ensembles will not be quite right.  


## Part II: program flow
The program’s flow is rather complex, and I strongly suggest that somebody porting it not follow every detail.  In what follows, I assume we are looking for just a single conformer; the entire thing is looped to find more conformers in the natural way.

The program makes heavy use of complex structs; for example, a ‘seriessquare’ is a rather poorly named struct that contains everything relevant for a partially built scaffold.  These structs, which really should be classes in Python, quickly get big, slow, and cumbersome. 

The fitting proceeds in roughly four steps. They are peak finding, pattern finding, assignment, and fit improvement.

### 1) peak finding
The csv file is cleaned up, and a simple peakfinding algorithm is run.  This is done via 
`kit = kitfromcsvfile(csvfilename,tightnesssettings);`.  After this step autofit plots the essentially unprocessed spectrum via `displaybarekit(kit);`.
    
### 2) pattern finding
A pattern is an assembly of lines which allows for easy assignment. Scaffolds, as described in the paper, are patterns; so are pairs of a-type ladders that seem to be self consistent. Finding this pattern is the heart of the algorithm, but the code is written so that switching method between scaffold, a-type, or in the future b-type will require only new code at this level.  
The actual code that finds scaffolds is `patternlist = findpatternvariant1(kit);`
The actual code that finds atypes is `patternlist = findpatternvariant3(kit);`
These are called from `findallspecies(kit)`.
Each pattern is given a pval, which is figure of merit describing how likely such a pattern would occur by chance. Only the ‘most improbable’ patterns are assigned in step 3 below:

### 3) assignment
A pattern allows for a rather limited number of assignments; for example, once you have chosen J and Ka for the first state, the rest are set.  Current settings involve a rather conservative number of guesses for J and Ka, which is slower but more robust. This is done by `tryPattern(thisPattern,kit)`; there’s a bunch of cumbersome stuff describing what’s worth keeping and what isn’t. The code `spfittrials = maketrials(s,kit);` is what actually chooses these Js, kas, etc, and the line `thisfit = quickspfit(thistrial.lineset,thistrial.ABC);` is what actually calls SPFIT.  One annoying detail is that SPFIT is rather sensitive to initial guess of A,B, and C - although we make quite some effort to make a ‘good’ guess, the most robust performance comes from trying several different initial A,B, C for each assignment.

### 4) fit improvement
The fit is improved; this can include, for example, finding additional lines, finding centrifugal distortion constants, or finding C13 or vibrational satellites.  All of this is done in `improvefit(newfit,kit);`, which is called from `findallspecies(kit)`. There is nothing very new in here (although finding C13s is trickier than it sounds without a calculated structure; contact me if you are interested in this problem).  This is annoyingly the slowest part of the whole process, and is turned off by default.

## Pattern finding specifically for scaffolds
This is the heart of the algorithm described in the paper. It is implemented at the top level by 
`patternlist = findpatternvariant1(kit);` 
The algorithm proceeds in the following crude steps:
A starting line f1 is picked; default is to just pick a strong line, although an individual line can be specified via cheatcodes. The number of lines to try is set in `settingsfromtightness` via `ts.lines = [1:50]; %[50 strongest lines]`
The algorithm finds as many four-loops as it can containing the line f1.  These are referred to as flatsquares, and are found by `[allsquares,kit] = getflatsquares(kit,linetouse,ts);`
The flat squares are turned into ‘seriessquares’, which are basically scaffolds, and these scaffolds are slowly extended in a breadth-first search. Relevant code is `seriessquarefromflatsquare()`, which turns a flat square into a scaffold, and perhaps most importantly `updateseriessquare()`, which for example, predicts the position of the next lines in a seriessquare, marks which points have been looked for, etc.  A seriessquare has a LOT of fields, which I am not documenting here.  The most central one is `fgrid`, which is a 4xn array of the actual frequencies in the ladder.  This is implemented in `[newsquarelist,boggeddown,census] = extendseriessquarealltheway(squarelist,fs,hs)`












