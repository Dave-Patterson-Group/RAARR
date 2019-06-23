function filename = convertcatfiletocsv(filename)
       
    catfilename = [filename '.cat'];
    csvfilename = [filename '_cat.csv'];


    array2convert = [];

    f = fopen(catfilename);

    tline = fgetl(f);
    rowindex = 1;

    % documentation: http://spec.jpl.nasa.gov/ftp/pub/calpgm/spinv.pdf
    %converts FORTRAN EDIT DESCRIPTORS TO MATLAB
    %(F13.4,2F8.4,I2,F10.4,I3,I7,I4,12I2)
    % F13.4 means width of 13 with 4 doublebers after decimal point
    % 12I2 means there are 12 fields each of an integer of width 2

    while ischar(tline)
        array2convert(rowindex, 1) = str2double(tline(1:13)); %freq in MHz
        array2convert(rowindex, 2) = str2double(tline(14:21)); %error
        array2convert(rowindex, 3) = str2double(tline(22:29)); % log of intensity
        array2convert(rowindex, 4) = str2double(tline(30:31)); % degrees of freedom
        array2convert(rowindex, 5) = str2double(tline(32:41)); % lower energy in wavedoublebers
        array2convert(rowindex, 6) = str2double(tline(42:44)); % uppsr state degenearcy
        array2convert(rowindex, 7) = str2double(tline(45:51)); % species ID
        array2convert(rowindex, 8) = str2double(tline(52:55)); % QNFMT (refer to SPFIT documentation)
        array2convert(rowindex, 9) = str2double(tline(56:57)); %QN1 (upper state)
        array2convert(rowindex, 10) = str2double(tline(58:59)); % QN2
        array2convert(rowindex, 11) = str2double(tline(60:61)); % QN3
        array2convert(rowindex, 12) = str2double(tline(62:63)); % QN4
        array2convert(rowindex, 13) = str2double(tline(64:65)); % QN5
        array2convert(rowindex, 14) = str2double(tline(66:67)); % QN6
        array2convert(rowindex, 15) = str2double(tline(68:69)); %QN1 (lower state)
        array2convert(rowindex, 16) = str2double(tline(70:71)); % QN2
        array2convert(rowindex, 17) = str2double(tline(72:73)); % QN3
        array2convert(rowindex, 18) = str2double(tline(74:75)); % QN4
        array2convert(rowindex, 19) = str2double(tline(76:77)); % QN5
        array2convert(rowindex, 20) = str2double(tline(78:79)); % QN6
        rowindex = rowindex + 1;
        tline = fgetl(f);
    end

    dlmwrite(csvfilename, array2convert,'precision',12)


    fclose(f);

end