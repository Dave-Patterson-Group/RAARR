function fancystickies()
dcmObj = datacursormode;  %# Turn on data cursors and return the
                          %#   data cursor mode object
set(dcmObj,'UpdateFcn',@fancycallback);  %# Set the data cursor mode object update
                                     %#   function so it uses updateFcn.m

end

