---

# Command Index

| grep    | search for patterns in files
| grep -E | search for patterns with extended regular expressions

---

- POSIX Standard: standards specified by IEEE computer society.
- grep: global regular expression print.
- Basic Regular Expressions: supported in any POSIX compliant application (metacharacters: ^$.[]* ).
- Extended Regular Expressions: extended BRE (maetacharacters: ^$.[]*(){}?| ).

# Grep

$ grep -h '.zip' dirlist*.txt

    - . Matches any character once.

$ grep -h '[bg]zip' dirlist*.txt

    - [ ] Matches any character inside [ ] once.

$ grep -h '[^bg]zip' dirlist*.txt

    - [^ ] Matches any character other than that inside [^ ] once.

$ grep -h '[A-Z]' dirlist*.txt

    - Matches any character from A to Z once.
    - Ranges wil differ depending on language setting.
        - ASCII collation order: ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.
        - Dictionary order (with locale specified): aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ.
        - $ echo $LANG to get language setting.

$ grep -h '[-AZ]' dirlist*.txt

    - Matches any -,A or Z once (notice that - looses its meaning.

$ echo "AAA" | grep AAA

    - Look for lines containg AAA.

$ echo "AAA" | grep -E 'AAA|BBB'

    - Look for lines containing BBB.

# Grep -E / Egrep

$ grep -Eh '^(bz|gz|zip)' dirlist*.txt

    - Look for lines starting with bz,gz or zip.

$ echo "(555) 123-4567" | grep -E '^\(?[0-9][0-9][0-9]\)? [0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]$'

    - Look for phone number pattern where
        - ^ indicates placement at start of line.
        - \ escapes ( metacharacter.
        - [0-9] matches any digit from 0 to 9.
        - $ indicates placement at the of the line.

$ echo "This that" | grep -E '^([[:alpha:]]+ ?)+$'

    - ? matches any character one or more times.

$ echo "This that" | grep -E '^([[:alpha:]]+ ?)+$'

    - * matches any character any number of times.

$ echo "(555) 123-4567" | grep -E '^\(?[0-9]{3}\)? [0-9]{3}-[0-9]{4}$'

    - {n} Matches preceding pattern n number of times.
    - {n,m} Matches pattern n-m times.
    - {n,} Matches n or more times.
    - {,m} Matches no more than m times.

# Find

$ find . -regex '.*[^-_./0-9a-zA-Z].*'

    - Find supports regular expressions with -regex.
    - Find requires files to match regex exactly (grep searches only must contain the pattern).

# Vim and Less

    - Vim and less also support regex (use / to search).
