setlocal tabstop=4
setlocal shiftwidth=4

setlocal makeprg=curl\ -s\ -F\ laxtype=yes\ -F\ parser=html5\ -F\ level=error\ -F\ out=gnu\ -F\ doc=@%\ http://validator.nu\ \\\|sed\ 's,^.*\":,'%:','
setlocal errorformat=%f:%l.%c-%m
