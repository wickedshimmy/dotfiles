setlocal makeprg=curl\ -s\ -F\ js=@%\ http://jslint.webvm.net\ \\\|sed\ 's,^,\"%:\",'
setlocal errorformat=%f:%l:%c:%m
