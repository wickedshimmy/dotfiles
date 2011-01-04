setlocal makeprg=curl\ -s\ -F\ output=gnu\ -F\ file=@%\ http://qa-dev.w3.org:8001/css-validator/validator
setlocal errorformat=%f:%l:%c:%m
