
function [isorisnot] = isconnected(pair1,pair2)
isorisnot = 0;
midstate = 0;
start1 = pair1.starterstate.i;
end1 = pair1.enderstate.i;
start2 = pair2.starterstate.i;
end2 = pair2.enderstate.i;
if (start1 == start2) || (start1 == end2) || (end1 == start2) || (end1 == end2)
    isorisnot = 1;
end
if (start1 == start2) && (end1 == end2)
   %error ('same pair twice!!');
    isorisnot = 0;
end
if (start1 == end2) && (end1 == start2)
    %error ('same pair rev twice!!');
    isorisnot = 0;
end
