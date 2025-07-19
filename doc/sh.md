# Find where a function is defined

```bash
# Turn on extended shell debugging
shopt -s extdebug

# Dump the function's name, line number and fully qualified source file
declare -F foo

# Turn off extended shell debugging
shopt -u extdebug
```
