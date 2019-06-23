function smartABC = findABCfromaseries(s)

    
    j = s.realfs(2)/(s.realfs(2) - s.realfs(1));
    
    bplusc = s.realfs(1)/j;
    bminusc = bplusc / 10;
    B = (bplusc + bminusc)/2;
    C = (bplusc) - B;
    A = 4 * bplusc;
    smartABC = [A B C];
end


