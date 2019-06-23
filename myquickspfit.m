function newfit = myquickspfit(triadlines,ABCxxxxx,useCD)
if nargin > 0
    save('tttfile','triadlines','ABCxxxxx','useCD');
else
    load('tttfile','triadlines','ABCxxxxx','useCD');
end

newfit = quickspfit(triadlines,ABCxxxxx,useCD);
1;

end

