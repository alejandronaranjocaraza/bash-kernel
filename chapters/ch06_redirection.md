---

# Command Index

| cat   | concetenate files
| sort  | sort lines of text
| uniq  | report or omit unique lines
| grep  | print lines matching a pattern
| wc    | print line, word and byte counts
| head  | output first part of a file
| tail  | output the last part of a file
| tee   | read from stdin and write to stdout and files

---

# Context

- All programs send output(s) and error(s) to files: stdout and stderr.
- I/O redirection allows control over where input comes from and goes.
- Shell references stdin, stdout and stderr with file descriptors 0, 1, 2.

---

# Redirecting Standerd Output and Standard Error

$ ls -l /usr/bin > ls-output.txt

    - Redirect stdout to a file (does not inlcude stderr).

$ > ls-output.txt

    - Truncate existing file or create new empty file.

$ ls -l /usr/bin >> ls-output.txt

    - Append stdout to file.

$ ls -l /bin/usr 2> ls-error.txt

    - Redirect stderr to a file.

$ ls -l /bin/usr > ls-output.txt 2>&1

    - Redirect stdin and sterr to a file.

$ ls -l /bin/usr &> ls-output.txt

    - Redirect stin and sterr to a file.

$ ls -l /bin/usr &>> ls-output.txt

    - Append stdin and sterr to a file.

$ ls -l /bin/usr 2> /dev/null

    - Dispose of unwanted errors.

---

# Redirecting Standard Input

$ cat filename

    - Read one or more file and copy into standard output.

$ cat movie.mpeg.0* > movie.mpeg

    - Join files movie.mpeg.0, movie.mpeg.1, ..., movie.mpeg.n into one.

$ cat > lazy_dog.txt
    Who is a lazy dog I am not.

    - Take stdin from keyboard and redirect to file.

$ cat < lazy_dog.txt

    - Take file and redirect as input for cat.

---

# Pipelines

$ ls -l /usr/bin | less

    - Redirect stdout from one command and redirect as sdtin for another.

---

# Tee

$ ls /usr/bin | tee ls.txt | grep zip

    - Read stdout from file listing, create file and send to stdout to coninue down the pipe.

---

# Other Sorting Commands

$ ls /bin /usr/bin | sort | less

    - Send stdout of file list, sort it and send it to stdout.

$ ls /bin /usr/bin | sort | uniq | less

    - Sort and deduplicate list of files, then send to stdout.

$ ls /bin /usr/bin | sort | uniq -d | less

    - See list of sorted duplicate files.

$ ls /bin /usr/bin | sort | uniq | wc -l

    - Report number or lines in deduplicated files.

$ ls /bin /usr/bin | sort | uniq | grep zip

    - List all matching lines from series of deduplicated and sorted files.

$ head -n 5 ls-output.txt

    - Show first five lines of a file.

$ tail -n 5 ls-output.txt

    - Show last five lines of a file.

---
