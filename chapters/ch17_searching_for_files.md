---

# Command Index

| locate  | display lines of text
| find    | search for files in directory hierarchy
| xargs   | build and execute command lines from standard input
| touch   | change file times
| stat    | display file or file system status

---

# Locate

$ locate bin/zip

    - Searches command database for specified path.

# Find

## Basic Commands 

$ find ~

    - Find all files in home directory hierarchy.

$ find ~ | wc -l

    - Count files int home directory hierarchy.

$ find ~ -type d | wc -l

    - Count number or directories in home hierarchy.

$ find ~ -type f | wc -l

    - Count number of files in directory hierarchy.

## File Types

- b | Block special device file
- c | Character special device file
- d | Directory
- f | Regular file
- l | Symbolic link

## File Units

- b | 512-byte blocks
- c | Bytes
- w | 2-byte words
- k | Kilobytes
- M | Megabytes
- G | Gigabytes

## All Tests

FIND TESTS
==========

+-----------------+------------------------------------------+
| TEST            | DESCRIPTION                              |
+-----------------+------------------------------------------+
| -cmin n         | Status changed n minutes ago             |
| -cnewer FILE    | Status changed more recently than FILE   |
| -ctime n        | Status changed n * 24 hours ago          |
| -empty          | Empty files and directories              |
| -group NAME     | Belong to group NAME or group ID         |
| -iname PATTERN  | Case-insensitive name match              |
| -inum N         | Match inode number N                     |
| -mmin n         | Content modified n minutes ago           |
| -mtime n        | Content modified n * 24 hours ago        |
| -name PATTERN   | Match name using wildcards               |
| -newer FILE     | Content newer than FILE                  |
| -nouser         | Owner has no valid user account          |
| -nogroup        | Group has no valid group account         |
| -perm MODE      | Match permissions                        |
| -samefile FILE  | Share the same inode as FILE             |
| -size N         | Match file size                          |
| -type C         | Match file type (f, d, l, etc.)          |
| -user NAME      | Belong to user NAME or user ID           |
+-----------------+------------------------------------------+

TIME MODIFIERS
==============

+----------+-------------------------------------------+
| MODIFIER | MEANING                                   |
+----------+-------------------------------------------+
| n        | Age interval based on n units             |
| -n       | Less than n units ago                     |
| +n       | More than n units ago                     |
| m        | Content modification time                 |
| c        | Metadata/status change time               |
| min      | Measure in minutes                        |
| time     | Measure in 24-hour periods                |
+----------+-------------------------------------------+

PERMISSION MODES
================

+----------+-------------------------------------------+
| MODE     | MEANING                                   |
+----------+-------------------------------------------+
| 644      | Exact permissions                         |
| -644     | All specified permission bits set         |
| /644     | At least one specified permission bit set |
+----------+-------------------------------------------+

EXAMPLES
========

+----------------------------------+-----------------------------+
| COMMAND                          | PURPOSE                     |
+----------------------------------+-----------------------------+
| find . -mmin -10                 | Modified within 10 minutes  |
| find . -mtime +7                 | Modified more than 7 days ago|
| find . -empty                    | Find empty files/directories|
| find . -iname "*.log"            | Case-insensitive log search |
| find . -type f -size +100M       | Files larger than 100 MiB   |
| find . -perm 644                 | Exact permissions 644       |
| find . -nouser                   | Files with no valid owner   |
| find . -newer backup.timestamp   | Newer than reference file   |
+----------------------------------+-----------------------------+

## Additional Tests

$ find ~ -type f -name "*.JPG" -size +1M | wc -l

    - Count number of files ending in .JPG of more than 1 megabyte.

## Operators

$ find ~ \( -type f -not -perm 0600 \) -or \( -type d -not -perm 0700 \)

    - Find all that arent files with permission 0600 or directories with permission 0700.

$ find ~ \( -type f -not -perm 0600 \) -and \( -type f -not -perm 0700 \)
    
    - Find all that arent files with permission 0600 and arent files with permission 0700.

## Predefined Actions

$ find ~ -name *.txt -type f -ls

    - Find all files ending in .txt and perform the equivalent of ls -dils on the matching files.

$ find ~ -name *.txt -type f -delete

    - Find all files ending in .txt and delete those files.

$ print ~ -name *.txt -type f -print

    - Find all files ending in .txt and print them. This is default with specifying any action.

## User-Defined Actions

$ find . -name *.txt -type f -exec ls -l '{}' ';'

    - Find all files ending in txt and execute command ls -l {} each time one is found.
    - {} is a symbolic representation of current pathname.
    - ; is end of executed command.
    - Note that this executes ls multiple times: ls -l file1; ls -l file2; ls -l file3;

$ find . -name *.txt -type f -exec ls -l '{}' +

    - Find all files ending in txt and execute command ls -l {} on the full output.
    - This executes ls once: ls -l file1 file2 file3;

## XARGS

$ find ~ -type f -name 'foo*' -print | xargs ls -l

    - xargs accepts input from standard input and converts into command-line argument list.
    - Will run somthing somthing similar to ls -l ./foo1.txt ./foo2.txt ./foo3.txt;
    - Number or arguments xargs can take is not unlimited.
    - Pipe ("|") passes stdout to sdin, while xargs passes stdout to command-line agruments.

## Other Options

$ find ~ -depth

    - Procesd directory files before the directory itself.

$ find ~ -maxdepth 3

    - Dont exceed directory depth of 3.

$ find ~ -mindepth 3

    - Only process after directory depth of 3.

$ find ~ -mount

    - Dont traverse directories on other file systems.

$ noleaf

    - Do not optimize on assumption that search is on Unix-like file system.
