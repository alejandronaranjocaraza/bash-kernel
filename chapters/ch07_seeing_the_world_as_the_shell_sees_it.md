---

# Command Index

| echo  | display lines of text

---

# Expansion Commands

## Basic Commands

$ echo *

    - Expand any qualifying character in the command line.

$ echo *s

    - Expand any qualifying characters ending in s.

$ echo [[:upper:]]*

    - Expand any qualifying characters starting in uppercase.

$ echo ~

    - Expand into current user directory.

$ echo ~zapatinb

    - Expand into user zapatinb's directory.

## Arithmetic Expansion

$ echo $((2 + 2)

    - Arithmetic expansion.

## Brace Expansion

$ echo Front-{A,B,C}-Back

    - Brace expansion.

$ echo Number_{1..5}

    - Interval expansion.

## Parameter Expansion

$ echo $USER
    
    - Parameter expansion.

$ printenv | less

    - Print environment variables.

---

# Command Substitution

$ echo $(ls)

    - Command substitution.

---

# Quotes

$ echo text ~/*.txt {a,b} $(echo foo) $((2+2)) $USER

    - No quotes. Respects all special characters.

$ echo "text ~/*.txt {a,b} $(echo foo) $((2+2)) $USER"

    - Double quotes. Respects only $, \, `.

$ echo 'text ~/*.txt {a,b} $(echo foo) $((2+2)) $USER'

    - Single quotes. Suppress all expansions.

$ echo "The balance for user $USER is: \$5.00"

    - Double quotes with backslash. Suppress $ expansion.

---
