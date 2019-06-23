function f = extractonefieldfromcellarray(cellarray,fieldname)
    f = extractfieldsfromcellarray(cellarray,{fieldname});
    f=f.(fieldname);
