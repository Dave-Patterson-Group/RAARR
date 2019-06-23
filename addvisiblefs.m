function kit = addvisiblefs(kit)

highenough = find(kit.onedpeakfs > kit.visiblewindow(1));
lowenough = find(kit.onedpeakfs < kit.visiblewindow(2));
kit.visiblei = intersect(highenough,lowenough);
kit.onedpeakfsvis = kit.onedpeakfs(kit.visiblei);
kit.onedpeakhsvis = kit.onedpeakhs(kit.visiblei);
   