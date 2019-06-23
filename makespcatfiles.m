function filename = makespcatfiles(argsin)

if nargin < 1
   argsin = prepare_sp_argsin;
end

makevarfile(argsin);
makeintfile(argsin);

filename = argsin.filename;


end
