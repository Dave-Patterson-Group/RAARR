function filename = convertstrfiletocsv(filename)

    strfilename = [filename '.str'];
    csvfilename = [filename '_str.csv'];


    array2convert = [];

    f = fopen(strfilename);

    tline = fgetl(f);
    rowindex = 1;

    % documentation: http://spec.jpl.nasa.gov/ftp/pub/calpgm/spinv.pdf
    %converts FORTRAN EDIT DESCRIPTORS TO MATLAB
    %(F15.4,E15.6,I5,1X,24A,I5)
    % F13.4 means width of 13 with 4 numbers after decimal point
    % 12I2 means there are 12 fields each of an integer of width 2
    % E15.6 means width 15 and six spaces after decimal written in
    % scientific notation 
    % X means a space, so 1X means 1 space
    % 24A means 24 characters. For our purposes it is essentially 12I2,
    % they only become characters when the quantum are above 99 or below -9
    % (when you would need 3 digits). They are then encoded according to
    % pg. 10 in the documentation). We will treat as 12I2

    while ischar(tline)
        if mod(rowindex,10000) == 10000
            fprintf('Still going: %i\n', rowindex);
        end
        array2convert(rowindex, 1) = str2double(tline(1:15)); %freq in MHz
        array2convert(rowindex, 2) = str2double(tline(16:30)); %reduced matrix element
        array2convert(rowindex, 3) = str2double(tline(31:35)); % QNFMT (refer to documentation)
        array2convert(rowindex, 4) = str2double(tline(37:38)); %QN1 (upper state)
        array2convert(rowindex, 5) = str2double(tline(39:40)); % QN2
        array2convert(rowindex, 6) = str2double(tline(41:42)); % QN3
        array2convert(rowindex, 7) = str2double(tline(43:44)); % QN4
        array2convert(rowindex, 8) = str2double(tline(45:46)); % QN5
        array2convert(rowindex, 9) = str2double(tline(47:48)); % QN6
        array2convert(rowindex, 10) = str2double(tline(49:50)); %QN1 (lower state)
        array2convert(rowindex, 11) = str2double(tline(51:52)); % QN2
        array2convert(rowindex, 12) = str2double(tline(53:54)); % QN3
        array2convert(rowindex, 13) = str2double(tline(55:56)); % QN4
        array2convert(rowindex, 14) = str2double(tline(57:58)); % QN5
        array2convert(rowindex, 15) = str2double(tline(59:60)); % QN6
        array2convert(rowindex, 16) = str2double(tline(61:66)); % dipole number?
        rowindex = rowindex + 1;
        tline = fgetl(f);
    end

    dlmwrite(csvfilename, array2convert,'precision',12)


    fclose(f);

end