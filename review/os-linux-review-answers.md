# Answer Key — OSTEP + TLCL Review

Commands assume you're in `~/review-lab` unless noted. Numbers were checked against the setup data; your dataset will match exactly because the generator uses a fixed seed.

---

### 1 · Redirection + grep
```bash
grep ERROR logs/risk_job.log > work/q01.txt
grep -c WARNING logs/risk_job.log >> work/q01.txt
```
`>` truncates and writes; `>>` appends. `grep -c` prints the count of matching lines.

### 2 · The process
A program is static: code and data sitting on disk. A process is a **running** program, i.e. the program plus the execution state the OS maintains for it. Its machine state includes:
- its **memory** (the address space: code, data, heap, stack);
- its **registers**, including the program counter, stack pointer, and frame pointer;
- its **I/O information**, such as the list of open files.

### 3 · What is a command?
- `cd` is a shell builtin.
- `ls` is usually aliased to `ls --color=auto` by Debian's default `~/.bashrc`.
- `grep` is an executable file, `/usr/bin/grep`. It may also show as an alias if your `.bashrc` defines a color alias.
- `type` is a shell builtin.

To see every match, use `type -a grep` or `command -v grep`. Running `file /usr/bin/grep` reports an *ELF 64-bit LSB pie executable*, i.e. a compiled binary, not a script.

### 4 · Limited direct execution
- **Direct:** the program runs straight on the CPU, so it is fast, with no interpretation layer.
- **Limited:** hardware support keeps the OS in charge. User mode can't run privileged instructions, privileged work goes through system calls (traps), and a timer interrupt hands the CPU back to the OS periodically.

You need both because pure direct execution would give up **control** (a process could take over the machine or run forever), while full emulation would give up **performance**.

### 5 · find with operators
```bash
cd tree && find . -type f \( -empty -o -size +1M \)
```
The escaped parentheses group the OR. Without them, `-type f` would bind only to `-empty`.

### 6 · Expansion and quoting
| Piece | Output | Expansion |
|---|---|---|
| `~` | `/home/you` | tilde |
| `*.log` | `risk_job.log` | pathname |
| `{a,b}{1,2}` | `a1 a2 b1 b2` | brace |
| `$((7/2))` | `3` | arithmetic (integer division) |
| `"$HOME"` | `/home/you` | parameter (double quotes allow `$`) |
| `'$HOME'` | `$HOME` | single quotes suppress all expansion |
| `\$HOME` | `$HOME` | the backslash escapes `$` |

### 7 · Scheduling metrics
- Turnaround = T_completion − T_arrival.
- Response = T_first_run − T_arrival.

SJF and STCF minimize turnaround by running short jobs to completion, but everything else waits behind them, so response time is poor. RR has excellent response time but stretches every job out, so turnaround is poor. The two metrics trade off against each other.

### 8 · Execute bit
`./risk_pipeline.sh` fails with **Permission denied** because the file has no execute bit (mode 644).
```bash
chmod u+x perms/risk_pipeline.sh
./perms/risk_pipeline.sh
stat -c '%a' perms/risk_pipeline.sh   # 744
```

### 9 · cut / sort / uniq
```bash
tail -n +2 data/risk_applications.csv | cut -d, -f3 | sort | uniq -c | sort -rn
```
Expected: `5014 approved`, `3011 rejected`, `1975 pending`. `uniq` only collapses *adjacent* duplicates, which is why you `sort` first.

### 10 · Your shell creates processes
The new shell's `$PPID` equals the old shell's `$$`, so the new shell is a **child** of the first. The parent shell called `fork()` to create a copy of itself, then the child called `exec()` to replace itself with `/bin/bash`. Meanwhile the parent sat in `wait()`/`waitpid()` until you typed `exit`.

### 11 · Three easy pieces
- **Virtualization:** the OS turns one CPU into the illusion of many and gives each process its own private memory.
- **Concurrency:** the OS coordinates many things happening at once, such as threads sharing data, correctly.
- **Persistence:** the OS stores data durably on disks and SSDs through file systems, so it survives crashes and power loss.

### 12 · grep -E + alternation
```bash
grep -Ei 'configuration|export' logs/risk_job.log   # 4 lines
```
In basic regex (no `-E`), `|` is a literal character, so grep searches for the text `configuration|export`, which never appears. (GNU grep does accept `\|` in BRE as an extension.)

### 13 · Directory permissions
- **r:** list the entries (`ls`).
- **w:** create, delete, or rename entries. This only works together with x.
- **x:** enter the directory and access entries by name (`cd`, path traversal).

With mode `300` (`-wx`), `ls` fails because there's no r, `cd` works, and `cat work/q13/f` works because x lets you reach a name you already know.

### 14 · Job control
```bash
sleep 300      # then Ctrl+Z
jobs           # [1]+ Stopped  sleep 300
bg %1
kill %1
jobs           # reports Terminated once, then empty
```

### 15 · Process states
- **Running → Ready:** descheduled. The OS takes the CPU away, e.g. after a timer interrupt.
- **Ready → Running:** scheduled. The OS's scheduler picks it.
- **Running → Blocked:** the process starts an operation it must wait for, such as a disk read.
- **Blocked → Ready:** the operation completes; the I/O interrupt is handled by the OS.

The process causes Running → Blocked. The OS decides the other transitions.

### 16 · Shell variable vs. environment variable
- **1: `[]`.** A plain assignment creates a *shell* variable, which isn't copied into a child's environment.
- **2: `[test]`.** `export` marks it for the environment, so children inherit it.
- **3: `[prod]`, then `after: test`.** `VAR=value cmd` sets the variable only in that one command's environment and leaves the shell's value unchanged.

### 17 · Address space
OSTEP's 16 KB example has three segments:
- **code** at the top (address 0), which is fixed in size;
- the **heap** right after the code, growing toward higher addresses;
- the **stack** at the bottom (16 KB), growing toward lower addresses.

They grow toward each other so both can expand into the same free region. That way neither needs a fixed maximum size decided in advance.

### 18 · awk group and sum
```bash
awk -F, 'NR>1 { t[$2] += $4 } END { for (p in t) print p, t[p] }' data/risk_applications.csv | sort -k2,2nr
```
Expected: invoice_financing 341846301 · term_loan 336861936 · working_capital 328617288. The grand total is 1007325525. `for (p in t)` has no guaranteed order, which is why you pipe the output to `sort`.

### 19 · `[ ]` vs `[[ ]]` vs `(( ))`
- `[` is a command (a builtin version of `test`). Its arguments undergo normal word splitting and globbing.
- `[[ ]]` is a shell *keyword*. Variables inside it aren't word-split or glob-expanded, and it adds `=~` (regex) and pattern matching.
- `(( ))` is for integer arithmetic. Its exit status is 0 if the result is nonzero.

With `x=""`, the test `[ $x = foo ]` becomes `[ = foo ]` and errors with *unary operator expected*. With `x="a b"`, it becomes `[ a b = foo ]` and errors with *too many arguments*. `[[ $x = foo ]]` handles both cases correctly.

### 20 · System calls and traps
1. The process executes a **trap** instruction with the system-call number.
2. The hardware saves the user registers on the process's kernel stack, switches to kernel mode, and jumps to the handler listed in the trap table.
3. The OS validates the request and does the work.
4. A **return-from-trap** restores the registers, switches back to user mode, and resumes the process.

The **trap table** is set up by the OS **at boot**, in kernel mode, using a privileged instruction. It tells the hardware where each trap handler lives. User code supplies only a syscall *number*, not an address. If it could jump to arbitrary kernel code, it could skip the permission checks.

### 21 · stdout vs. stderr
```bash
ls ~/review-lab/logs /nope > work/out.txt 2> work/err.txt   # (a)
ls ~/review-lab/logs /nope > work/all.txt 2>&1              # (b)  or: &> work/all.txt
ls ~/review-lab/logs /nope 2> /dev/null                     # (c)
```
(d) Redirections are processed **left to right**. `2>&1` points stderr at wherever stdout currently goes, which is the terminal. *Then* `> file` moves stdout alone to the file, so the errors still reach your screen.

### 22 · find + exec / xargs
```bash
find tree -name '*.py' -exec grep -l TODO {} +
find tree -name '*.py' | xargs grep -l TODO
```
The `{} +` form passes many files to a single `grep` call. Plain `xargs` breaks on filenames with spaces; use `find ... -print0 | xargs -0` to avoid that.

### 23 · ps states vs. OSTEP
- **`sleep`** shows `S`: interruptible sleep, waiting on a timer. That's OSTEP's **Blocked**.
- **`yes`** shows `R`: running *or* runnable. Linux doesn't distinguish OSTEP's **Running** from **Ready** here.
- After `kill -STOP`, `yes` shows `T` (stopped). The basic three-state model has no equivalent; it's an extra state.

Extra characters such as `+` (foreground process group) and `s` (session leader) are modifiers, not states.

### 24 · fork() and wait()
The program creates two processes in total: the parent plus one child. In a terminal it prints `A`, `B`, `C` in that order, and the order is deterministic. `wait(NULL)` makes the parent block until the child exits, so `B` always comes before `C`. Without the `wait`, the scheduler decides who runs first, so you could see `C` before `B`.

Bonus: if you redirect output to a file, `A` may print **twice**. Stdout is then fully buffered, so `A` is still sitting in the buffer when `fork()` runs, and the child gets a copy of that unflushed buffer.

### 25 · Numeric sort by field
```bash
tail -n +2 data/risk_applications.csv | sort -t, -k4,4nr | head -10 | cut -d, -f1,4
```
The first line should be `9015,199998`. Without `-n`, `sort` compares text, so `99999` sorts above `199998` because `9` > `1`.

### 26 · Finding documentation
- (a) `help cd`, since `cd` is a builtin.
- (b) `man find` or `find --help`.
- (c) `apropos compress` (same as `man -k compress`); `whatis` gives one-line summaries.

`man cd` fails because `cd` is a builtin with no separate man page. It's documented in `man bash`, unless the `manpages-posix` package is installed.

### 27 · First script
```bash
#!/usr/bin/env bash
TITLE="Lab info"

cat <<EOF
$TITLE
Date: $(date)
Host: $(hostname)
EOF
```
```bash
chmod +x scripts/lab-info
cd /tmp && ~/review-lab/scripts/lab-info
```
Because the `EOF` delimiter is unquoted, expansions inside the here document run. Quoting it (`<<'EOF'`) would print the text literally.

### 28 · Regaining control
- **Cooperative:** the OS trusts processes to give up the CPU, by making a system call, calling `yield`, or causing a fault. A process stuck in an infinite loop means rebooting.
- **Non-cooperative:** a hardware **timer interrupt** fires every few milliseconds and runs an OS handler. This guarantees the OS regains control no matter what the process does.

A context switch saves registers twice:
1. On the interrupt, the hardware saves the user registers onto the process's kernel stack.
2. When the OS decides to switch, it saves the kernel registers into process A's structure (PCB), restores B's from B's structure, and switches to B's kernel stack. Return-from-trap then resumes B.

### 29 · Anchors, classes, quantifiers
```bash
grep -cE '^[0-9]{4}-[0-9]{2}-[0-9]{2}' logs/risk_job.log                 # 17
grep -oE '[0-9]{2}:[0-9]{2}:[0-9]{2}' logs/risk_job.log                  # 17 times
```
The equivalent with POSIX classes is `'^[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}'`.

### 30 · FIFO vs. RR
| | Avg turnaround | Avg response |
|---|---|---|
| FIFO | (5+10+15)/3 = **10** | (0+5+10)/3 = **5** |
| RR (slice 1) | (13+14+15)/3 = **14** | (0+1+2)/3 = **1** |

RR is far better on response but worse on turnaround: the jobs are equal length, and RR stretches each one out until nearly the end.

### 31 · umask and numeric chmod
Debian's default `umask` is `0022`. New files get 666 − 022 = **644** (`-rw-r--r--`) and new directories get 777 − 022 = **755** (`drwxr-xr-x`).
```bash
chmod 400 perms/secret.txt   # -r--------
chmod 600 perms/secret.txt   # restore
```

### 32 · Why `cd` is a builtin
External commands run in a **child** created with `fork()` + `exec()`. The current working directory is per-process state. A `/usr/bin/cd` would change its *own* directory and then exit, leaving the parent shell exactly where it was. Anything that must change the shell itself has to be a builtin, for the same reason: `cd`, `export`, `exit`, `source`.

### 33 · Functions + file tests
```bash
#!/usr/bin/env bash

check_file() {
    local path="$1"
    if [[ ! -e "$path" ]]; then echo "not found: $path" >&2; return 1; fi
    if [[ ! -f "$path" ]]; then echo "not a regular file: $path" >&2; return 2; fi
    if [[ ! -r "$path" ]]; then echo "not readable: $path" >&2; return 3; fi
    if [[ ! -s "$path" ]]; then echo "empty: $path" >&2; return 4; fi
    echo "ok: $path"
}

check_file "$1"
exit $?
```
Expected exit statuses: `valid.csv` → 0, `empty.csv` → 4, `tree/data` → 2, `/nope` → 1. Quote `"$1"` and `"$path"`, or filenames with spaces will break.

### 34 · Virtual memory goals
- **Transparency:** programs behave as if they had their own private memory and are unaware that it's virtualized.
- **Efficiency:** translation must cost little time and space, which needs hardware support such as the TLB.
- **Protection (isolation):** a process can't read or write another process's memory, or the OS's.

Any address a user program prints is **virtual**. The OS and the hardware translate it to a physical address.

### 35 · Word splitting
`wc -l tree/data/*.csv` works because the results of pathname expansion aren't word-split again: each matched filename stays one word. `wc -l $f` undergoes word splitting on the space, so `wc` receives two arguments, `tree/data/Q3` and `report.csv`, and neither exists. `"$f"` keeps it as one word. Rule: always quote variable expansions.

### 36 · Keyboard and history
- (a) `Ctrl+R`
- (b) `Alt+.` (interactive) or `!$`
- (c) `!grep`
- (d) `Ctrl+A`
- (e) `Ctrl+K`

### 37 · Hard vs. symbolic links
```bash
cp -r tree work/tree_bak
ln -s ~/review-lab/logs/risk_job.log work/latest_log
ln logs/risk_job.log work/hard_log
ls -li logs/risk_job.log work/hard_log work/latest_log
```
A hard link is a second *name* for the same inode. It shows the same inode number, and the link count becomes 2. A symlink is a separate small file that contains a *path*, so it has its own inode.

If you delete the original, the hard link still works, because the data stays until the link count reaches 0. The symlink becomes dangling.

### 38 · Program → process
1. Load the code and static data from the executable on disk into the process's address space.
2. Allocate the **stack** and initialize it with `argc`/`argv`.
3. Allocate an initial **heap**.
4. Set up I/O: file descriptors 0, 1, and 2 (stdin, stdout, stderr).
5. Jump to `main()` and transfer control of the CPU to the process.

Loading lazily means bringing pieces of the program into memory only when they're actually used, through paging and swapping. It gives faster startup and lower memory use.

### 39 · Signals
```bash
yes > /dev/null & pid=$!
kill -STOP "$pid"; ps -o pid,stat,comm -p "$pid"   # T
kill -CONT "$pid"; ps -o pid,stat,comm -p "$pid"   # R
kill "$pid"                                         # SIGTERM (default)
```
**SIGKILL** and **SIGSTOP** can't be caught, blocked, or ignored.

### 40 · SJF vs. STCF
- **SJF:** A runs 0–100, B 100–110, C 110–120. Turnarounds are 100, 100, and 110, averaging **103.33**.
- **STCF:** A runs 0–10, B 10–20, C 20–30, and A resumes 30–120. Turnarounds are 120, 10, and 20, averaging **50**.

STCF relaxes the assumption that **jobs run to completion**: it can preempt a running job when a shorter one arrives.

### 41 · sed, tr, diff
```bash
sed 's/WARNING/WARN/' logs/risk_job.log > work/short.log
diff logs/risk_job.log work/short.log          # changes on lines 4, 8, 14
head -1 data/risk_applications.csv | tr '[:lower:]' '[:upper:]'
```
`sed` writes to stdout and doesn't modify the input file unless you pass `-i`.

### 42 · Environment inheritance
`fork()` gives the child a **copy** of the parent's memory, environment included. The child's `export` changes only its own copy, and that copy disappears when it exits. Information never flows back up to the parent.

`bash ~/.bashrc` runs the file in a child shell, so its settings are lost on exit. `source ~/.bashrc` (also written `. ~/.bashrc`) runs it in the *current* shell.

### 43 · `&&` and `||`
```bash
[[ -d work/reports ]] || mkdir work/reports && echo ready   # or: mkdir -p work/reports && echo ready
[[ -e data/nope.csv ]] || echo missing
```
`true && false || echo fallback` prints `fallback`. In `a && b || c`, `c` runs whenever the whole left side fails, which includes the case where `a` succeeds but `b` fails. A true if/else would never run `c` once `a` had succeeded.

### 44 · PCB / process list
The OS keeps a **process list** with one entry, the PCB, per process. xv6's `struct proc` holds:
- a pointer to its memory and its size;
- the bottom of its kernel stack;
- its **state** (UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE);
- its pid and a pointer to its parent;
- the channel it's sleeping on and a killed flag;
- its open files and current directory;
- the saved **register context** and the trap frame.

The register context must be saved because a stopped process can only resume exactly where it left off if its PC, stack pointer, and other registers are restored.

### 45 · ps
```bash
ps -eo pid,%mem,comm --sort=-%mem | head -6     # header + top 5
ps -o pid,ppid,comm -p $$                       # your shell
ps -o pid,ppid,comm -p $PPID                    # its parent (terminal emulator, sshd, ...)
```

### 46 · Virtualizing CPU and memory
- **CPU:** several copies of `cpu` all appear to run at once on a single CPU, creating the illusion of many CPUs. The OS gets there through time sharing.
- **Memory:** each copy of `mem` seems to have the whole memory to itself.

Both print the same address because it's a **virtual** address. Each process has its own private address space, and the OS maps those identical virtual addresses to different physical memory. (The book notes you must disable address-space randomization to see identical addresses.)

### 47 · Prompt
```bash
PS1='\u:\w [$?]\$ '
false; true
```
With single quotes, `$?` is stored literally and re-expanded every time the prompt is drawn. Double quotes would expand `$?` once, at assignment, and freeze it. Open a new shell to get your old prompt back.

### 48 · find by age
```bash
cd tree && find . -type f -mtime +2 ! -name '*.log' -ls
```
The only result is `./archive/old_export.csv`. `-mtime` counts age in whole 24-hour periods with fractions discarded, so `+2` means "more than 2", i.e. at least 3 full days old. A file touched exactly 3 days ago qualifies.

### 49 · Scheduling with I/O
While a job is blocked waiting for I/O, it can't use the CPU, so the scheduler runs another job. This **overlap** keeps both the CPU and the disk busy. If each CPU burst of an interactive job is treated as a short independent job, an STCF-like scheduler favors those bursts. The interactive job then gets the CPU quickly whenever it's ready, and the CPU-bound job fills in the gaps.

### 50 · Mini script
```bash
#!/usr/bin/env bash
DATA=~/review-lab/data/risk_applications.csv

if [[ ! -r "$DATA" ]]; then
    echo "cannot read: $DATA" >&2
    exit 1
fi

avg=$(awk -F, 'NR>1 && $3=="approved" { s+=$6; n++ } END { if (n) printf "%.2f", s/n }' "$DATA")
avg_int=$(echo "$avg" | cut -d. -f1)

echo "Average approved score: $avg"
if (( avg_int > 600 )); then echo HIGH; else echo LOW; fi
```
Expected output: `624.62` → `HIGH`. `(( ))` is integers only, so `(( 624.62 > 600 ))` is a syntax error. That's why the decimal part is cut off first.
