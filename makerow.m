function f = makerow(f)
g = size(f);
if min(g) > 1
    g
    error('not row-able');
end
if (g(1) > g(2))
    f = f';
end

