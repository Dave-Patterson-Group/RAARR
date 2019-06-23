function pairlist = pairstoMHz(pairlist)


for i = 1:length(pairlist)
    thispair = pairlist{i};
   
    thispair.delf = thispair.delf * 1000;
    pairlist{i} = thispair;
  
end
