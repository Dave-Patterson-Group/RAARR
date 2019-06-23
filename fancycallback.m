function output_txt = fancycallback(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).
global STICKYMSGBOX

pos = get(event_obj,'Position');
U = get(event_obj.Target,'UserData');
extrastring = '';
xval = pos(1);
yval = pos(2);
if isstruct(U)
    if strcmp(U.datatype,'Pairlist')
        drmode = 0;
        pairlist = U.pairlist;
        freqs = [];
        amps = [];
        numpairs = length(pairlist);
        for i = 1:numpairs
            thispair = pairlist{i};
            if isfield(thispair,'localf')
                freqs(end+1) = thispair.localf;
            else
                freqs(end+1) = thispair.delf;
            end
            %amps(end+1) = thispair.transmoment;
        end
        if xval > (max(freqs) * 10)
            freqs = freqs * 1000;
        end
        freqserr = abs(freqs - xval);
        besti = find(freqserr == min(freqserr),1,'first');
        
        thispair = pairlist{besti};
        polstring = thispair.polstring; %sprintf('pol: %3.2f',thispair.polarizability*1e12);
        extrastring = thispair.shortdescription; 
        groundstateenergystring = sprintf('ground energy: %f', thispair.minenergy);
        if isfield(thispair, 'drlist')
            sorted_drlist = sortstructcellarraybyfield(thispair.drlist, 'minmoment');
            output = extractfieldsfromarray(sorted_drlist, {'otherfreq'});
            output2 = extractfieldsfromarray(sorted_drlist, {'vchar'});
            output3 = extractfieldsfromarray(sorted_drlist, {'isV'});
            otherfreq = fliplr(output.otherfreq);
            isv = fliplr(output3.isV);
            isvv = fliplr(output2.vchar);
            drstring = 'DR at: ';
            if not(isempty(otherfreq))
                drmode = 1;
                numDRs = 8;
                numDRs = min(length(otherfreq),numDRs);
                for i = 1:numDRs %suggest 4 or more frequencies
                    drstring = [drstring sprintf('%2.4f%c ', otherfreq(i),isvv{i}(1))];
                    if i == 5
                        drstring = sprintf('%s\n',drstring);
                    end
                    if i + 1 > length(thispair.drlist)
                        break
                    end
                end
            else
                drstring = 'No known DR.';
            end
            drstring = [drstring];
        else
            drstring = 'DR not added';
        end
        if isfield(thispair, 'autoobserved')
           if thispair.autoobserved == 1 && thispair.ourdiff(end) < 150e-6
               heightratio = thispair.ourratio(end);
               errorf = thispair.ourdiff(end) * 1e6;
               observedstring = sprintf('Assignment at %2.6f\nheight ratio (observed to theory): %f\nerror: %f kHz', thispair.ourfreqs(end), heightratio, errorf);
           else
               observedstring = 'No Assignment';
           end
        else
            observedstring = 'No Assignment';
        end
        if isfield(U,'draxis') %I have another axis to plot this BS on.
            a = gca;
            axes(U.draxis);
            xlim([thispair.delf - .001,thispair.delf + .001]);
           % axes(a);
        end
        output_txt = {thispair.molstats.molname, ['f: ',num2str(pos(1),8),' GHz'], extrastring, groundstateenergystring, drstring};
        if isfield(thispair,'bandstring')
            output_txt = {thispair.molstats.molname, ['f: ',num2str(thispair.delf),' GHz'], ['Y: ', num2str(pos(2),8)], polstring, extrastring, groundstateenergystring,thispair.bandstring,thispair.assignstring};
        end

%         output_string = char(output_txt);
%         if STICKYMSGBOX == -1 || isempty(findobj(STICKYMSGBOX, 'Tag', 'MessageBox')) 
%             STICKYMSGBOX = msgbox(output_string, sprintf('Figure %i Information', event_obj.Target.Parent.Parent.Number));
%         else
%             set(findobj(STICKYMSGBOX, 'Tag', 'MessageBox'), 'String', output_string)
%             set(STICKYMSGBOX, 'Name', event_obj.Target.Parent.Parent.Number);
%         end
        for i = 1:5
            disp(output_txt{i});
        end
        return
    %disp(thispair.description);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    if strcmp(U.datatype,'LitePairlist')
        drmode = 0;
        pairlist = U.pairlist;
        freqs = [];
        amps = [];
        numpairs = length(pairlist);
        for i = 1:numpairs
            thispair = pairlist{i};
            
            freqs(end+1) = thispair.f;
            
            %amps(end+1) = thispair.transmoment;
        end
        freqserr = abs(freqs - xval);
        besti = find(freqserr == min(freqserr),1,'first');
        
        thispair = pairlist{besti};
%         polstring = thispair.polstring; %sprintf('pol: %3.2f',thispair.polarizability*1e12);
%         extrastring = thispair.shortdescription; 
%         groundstateenergystring = sprintf('ground energy: %f', thispair.minenergy);
        
        
        output_txt = {thispair.label};
%         if isfield(thispair,'bandstring')
%             output_txt = {thispair.molstats.molname, ['f: ',num2str(thispair.delf),' GHz'], ['Y: ', num2str(pos(2),8)], polstring, extrastring, groundstateenergystring,thispair.bandstring,thispair.assignstring};
%         end

%         output_string = char(output_txt);
%         if STICKYMSGBOX == -1 || isempty(findobj(STICKYMSGBOX, 'Tag', 'MessageBox')) 
%             STICKYMSGBOX = msgbox(output_string, sprintf('Figure %i Information', event_obj.Target.Parent.Parent.Number));
%         else
%             set(findobj(STICKYMSGBOX, 'Tag', 'MessageBox'), 'String', output_string)
%             set(STICKYMSGBOX, 'Name', event_obj.Target.Parent.Parent.Number);
%         end
        return
    %disp(thispair.description);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp(U.datatype,'ConfirmedDRs')  %made from plotanalysis
        drlist = U.drlist;
        f1s = [];
        f2s = [];
        numdrs = length(drlist);
        for i = 1:numdrs
            thisdr = drlist{i};
            f1s(end+1) = thisdr.f1;
            f2s(end+1) = thisdr.f2;
            %amps(end+1) = thispair.transmoment;
        end
        freqserr = (f1s - xval).^2 + (f2s - yval).^2;
        besti = find(freqserr == min(freqserr),1,'first');
        
        thisdr = drlist{besti};
        
        snrstring = sprintf('%s depth %3.1f',thisdr.snrreport,thisdr.moddepth);
        
        output_txt = {thisdr.descriptor snrstring thisdr.filestring(end-4:end)};

%         output_string = char(output_txt);
%         if STICKYMSGBOX == -1 || isempty(findobj(STICKYMSGBOX, 'Tag', 'MessageBox')) 
%             STICKYMSGBOX = msgbox(output_string, sprintf('Figure %i Information', event_obj.Target.Parent.Parent.Number));
%         else
%             set(findobj(STICKYMSGBOX, 'Tag', 'MessageBox'), 'String', output_string)
%             set(STICKYMSGBOX, 'Name', event_obj.Target.Parent.Parent.Number);
%         end
        return
    end
    if strcmp(U.datatype,'fitlist') %see plotDRanalysis
        allsweeps = U.allsweeps;
        allf1s = U.sweepf1s;
  %      allf2s = U.allf2s;
  %      allstrings = U.allstrings;
  %      allfits = U.allfits;
        
        freqserr = (allf1s - xval).^2;% + (allf2s - yval).^2;
        besti = find(freqserr == min(freqserr),1,'first');
        
    %    thisfit = allfits{besti};
        thissweep = allsweeps{besti};
        plotsweepb(thissweep);
    end
        
    if strcmp(U.datatype,'Assignlist')
        allexp = U.peaklist;
        numpeaks = length(allexp);
        ferror = [];
        for i = 1:numpeaks
            thispeak = allexp{i};
            thismatchpair = thispeak.match;
            ferror(end+1) = thismatchpair.expf - xval;
        end
        ferror = abs(ferror);
        besti = find(ferror == min(ferror),1,'first');
        bestpeak = allexp{besti};
        output_txt = bestpeak.fullstring;
        return;
    end
        
        
    if strcmp(U.datatype,'Blastedlist')
        peaklist = U.peaklist;
        freqs = [];
        amps = [];
        numpairs = length(peaklist);
        for i = 1:numpairs
            thispeak = peaklist{i};
            freqs(end+1) = thispeak.f;
            %amps(end+1) = thispair.transmoment;
        end
        freqserr = abs(freqs - xval);
        besti = find(freqserr == min(freqserr),1,'first');
        
        thispair = peaklist{besti};
        bandstring = thispair.drreport; %sprintf('pol: %3.2f',thispair.polarizability*1e12);
        snrstring = thispair.snrreport;
        
        output_txt = {bandstring snrstring};

%         output_string = char(output_txt);
%         if STICKYMSGBOX == -1 || isempty(findobj(STICKYMSGBOX, 'Tag', 'MessageBox')) 
%             STICKYMSGBOX = msgbox(output_string, sprintf('Figure %i Information', event_obj.Target.Parent.Parent.Number));
%         else
%             set(findobj(STICKYMSGBOX, 'Tag', 'MessageBox'), 'String', output_string)
%             set(STICKYMSGBOX, 'Name', event_obj.Target.Parent.Parent.Number);
%         end
        return
    end
    
    
    if strcmp(U.datatype,'Peaklist')
        peaklist = U.peaklist;
        freqs = [];
        amps = [];
        numpairs = length(peaklist);
        for i = 1:numpairs
            thispeak = peaklist{i};
            freqs(end+1) = thispeak.truef;
            %amps(end+1) = thispair.transmoment;
        end
        freqserr = abs(freqs - xval);
        besti = find(freqserr == min(freqserr),1,'first');
        
        thispair = peaklist{besti};
        bandstring = thispair.bandstring; %sprintf('pol: %3.2f',thispair.polarizability*1e12);
        
        
        output_txt = bandstring;

%         output_string = char(output_txt);
%         if STICKYMSGBOX == -1 || isempty(findobj(STICKYMSGBOX, 'Tag', 'MessageBox')) 
%             STICKYMSGBOX = msgbox(output_string, sprintf('Figure %i Information', event_obj.Target.Parent.Parent.Number));
%         else
%             set(findobj(STICKYMSGBOX, 'Tag', 'MessageBox'), 'String', output_string)
%             set(STICKYMSGBOX, 'Name', event_obj.Target.Parent.Parent.Number);
%         end
        return
    end
    if strcmp(U.datatype,'drlist')
        drlist = U.drlist;
        lowfs = [];
        highfs = [];
        lowf = min([xval yval]);
        highf = max([xval yval]);
        numpairs = length(drlist);
        for i = 1:numpairs
            thisdr = drlist{i};
            lowfs(end+1) = thisdr.minf;
            highfs(end+1) = thisdr.maxf;
        end
        freqserr = abs((lowfs - lowf).^2 + (highfs - highf).^2);
        besti = find(freqserr == min(freqserr),1,'first');
        
        thisdr = drlist{besti};
        extrastring = thisdr.middescription; 
        output_txt = { extrastring};
        return;
    %disp(thispair.description);
    end
%     disp(U.datatype)
    if strcmp(U.datatype,'specfile')
        output_txt = {['f: ',num2str(pos(1),7)],...
        [U.label]};
        return;
    end
    
    if strcmp(U.datatype,'pgoplot')
        alltransitions = U.alltransitions;
        freqs = [];
        for i = 1:length(alltransitions)
            freqs(end + 1) = alltransitions(i).freq;
        end
        diff = abs(freqs - xval);
        index = find(diff == min(diff),1,'first');
        extrastring = alltransitions(index).labelstring;
        output_txt = {alltransitions(i).molname, ['f: ',num2str(pos(1),8),' GHz'], extrastring};
        return;
    end
    
    if strcmp(U.datatype,'GenericPairX');
       pairlist = U.pairlist;
       output = extractfieldsfromdatabase(pairlist, {U.field});
       ourxs = output.(U.field);
       diff = abs(ourxs - xval);
       index = find(diff == min(diff),1,'first');
       thispair = pairlist{index};
       polstring = thispair.polstring; %sprintf('pol: %3.2f',thispair.polarizability*1e12);
        extrastring = thispair.shortdescription; 
        groundstateenergystring = sprintf('ground energy: %f', thispair.minenergy);
        if isfield(thispair, 'drlist')
            sorted_drlist = sortstructcellarraybyfield(thispair.drlist, 'minmoment');
            output = extractfieldsfromarray(sorted_drlist, {'otherfreq'});
            otherfreq = fliplr(output.otherfreq);
            drstring = 'DR at: ';
            if not(isempty(otherfreq))
                for i = 1:4 %suggest 4 frequencies
                    drstring = [drstring sprintf('%2.6f ', otherfreq(i))];
                    if i + 1 > length(thispair.drlist)
                        break
                    end
                end
            end
            drstring = [drstring];
        else
            drstring = 'No known DR\n';
        end
        if isfield(thispair, 'autoobserved')
           if thispair.autoobserved == 1 && thispair.ourdiff(end) < 150e-6
               heightratio = thispair.ourratio(end);
               errorf = thispair.ourdiff(end) * 1e6;
               observedstring = sprintf('Assignment at %2.6f\nheight ratio (observed to theory): %f\nerror: %f kHz', thispair.ourfreqs(end), heightratio, errorf);
           else
               observedstring = 'No Assignment';
           end
        else
            observedstring = 'No Assignment';
        end
        output_txt = {thispair.molstats.molname, ['f: ',num2str(pos(1),8),' GHz'], polstring, extrastring, groundstateenergystring, drstring, observedstring};
         if isfield(thispair,'bandstring')
            output_txt = {thispair.molstats.molname, ['f: ',num2str(thispair.delf),' GHz'], polstring, extrastring, groundstateenergystring,thispair.bandstring,thispair.assignstring};
         end
%         output_string = char(output_txt);
%         if isempty(findobj(STICKYMSGBOX, 'Tag', 'MessageBox'))
%             STICKYMSGBOX = msgbox(output_string, sprintf('Figure %i Information', event_obj.Target.Parent.Parent.Number));
%         else
%             set(findobj(STICKYMSGBOX, 'Tag', 'MessageBox'), 'String', output_string);
%             set(STICKYMSGBOX, 'Name', event_obj.Target.Parent.Parent.Number);
%         end
        return;
       
    end
    if strcmp(U.datatype, 'chirpassigns')  %actually pretty generic except for asisgndescriptor
        %thispoint = findpoint(U,xval);
        xvals = U.xdata;
        xvals = abs(xvals - xval);
        yvals = U.ydata;
        yvals = abs(yvals - yval);
        neterr = xvals + yvals;
        thebesti = find(neterr == min(neterr),1,'first');
        structlist = getfield(U,U.listname);
        thispoint = structlist{thebesti};

        output_txt = thispoint.assigndescriptor;
        return
    end
    
    if strcmp(U.datatype, 'trianglelist')
        trianglelist = U.trianglelist;
        if strcmp(U.whichpair, 'mid')
            output = extractfieldsfromdatabase(trianglelist, {'midpair'});
            output2 = extractfieldsfromdatabase(output.midpair, {'realf'});
            freqs = output2.realf;
            mid = 1;
        else
            output = extractfieldsfromdatabase(trianglelist, {'highpair'});
            output2 = extractfieldsfromdatabase(output.highpair, {'realf'});
            freqs = output2.realf; 
            mid = 0;
        end
        diff = abs(freqs - xval);
        index = find(diff == min(diff),1,'first');
        thistriangle = trianglelist{index};
        if mid
           thispair = thistriangle.midpair; 
        else
            thispair = thistriangle.highpair;
        end
        if isfield(thispair, 'autoobserved')
           if thispair.autoobserved == 1 && thispair.ourdiff(end) < 150e-6
               heightratio = thispair.ourratio(end);
               errorf = thispair.ourdiff(end) * 1e6;
               observedstring = sprintf('Assignment at %2.6f\nheight ratio (observed to theory): %f\nerror: %f kHz', thispair.ourfreqs(end), heightratio, errorf);
           else
               observedstring = 'No Assignment';
           end
        else
            observedstring = 'No Assignment';
        end
        output_txt = {thistriangle.longdescription, observedstring};
        return
    end
  
else
    output_txt = {['X: ',num2str(pos(1),7)],...
    ['Y: ',num2str(pos(2),7)]};
end
output_txt = {['X: ',num2str(pos(1),7)],...
    ['Y: ',num2str(pos(2),7)]};

if isstruct(U) && isfield(U,'extralabel');
    output_txt{end+1} = U.extralabel;
end
% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    output_txt{end+1} = ['Z: ',num2str(pos(3),4)];
end

% function thispoint = findpoint(U,xval)
%     xvals = U.xtoplot;
%     xvals = abs(xvals - xval);
%     thebesti = find(xvals == min(xvals),1,'first');
%     structlist = getfield(U,U.listname);
%     thispoint = structlist{thebesti};
% end
    