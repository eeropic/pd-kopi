# NOTE: discontinued
In favor of getting this to Pd core some day, wip PR
at https://github.com/pure-data/pure-data/pull/2086

# pd-kopi
Copy/paste Pure Data patches in plaintext, using temporary file and system clipboard

Copy into your Pd search path, and Pd should load it automatically on application launch
Tested only on Pd 0.50, 0.54 on MacOSX

Use at your own risk - the current implementation is a bit hacky, proper way to do it would be implementing it in pd core, converting patch text->binbuf->text
