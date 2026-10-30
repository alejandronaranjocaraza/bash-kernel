# OSTEP + The Linux Command Line — Review Question Bank

**Scope:** TLCL (2nd ed. numbering) Ch. 1–11, 13, 17, 19, 20, 24–27 · OSTEP Ch. 2, 4, 5, 6, 7, 13 (theory only)
**Environment:** Bash on Debian (GNU tools)

## How to use

- Work through the list **in order**, doing 1–5 questions per session (5–15 min).
- **Answer first, look up second.** Write or say your answer, then check it with the "Look in" pointers.
- Mark each question: **S** solid · **W** wobbly · **X** couldn't do it. At the end of the week, redo the W/X ones.
- Lab outputs go in `~/review-lab/work/` so the originals stay untouched.
- Tags: **Lab** = do it in the terminal · **Theory** = explain it · **Bridge** = connects a terminal observation to OSTEP.

## Setup (run once; to reset: `rm -rf ~/review-lab` and run again)

```bash
mkdir -p ~/review-lab && cd ~/review-lab
mkdir -p logs data perms scripts work tree/{data,logs,scripts,archive}

# --- Log file (17 lines) ---
cat > logs/risk_job.log <<'EOF'
2026-10-10 01:00:01 INFO Starting risk calculation
2026-10-10 01:00:02 INFO Loading customer data
2026-10-10 01:00:04 INFO Loaded 12000 records
2026-10-10 01:00:07 WARNING Missing income for customer 1042
2026-10-10 01:00:08 INFO Starting score calculation
2026-10-10 01:00:12 ERROR Failed to read configuration
2026-10-10 01:00:13 INFO Retrying configuration load
2026-10-10 01:00:15 WARNING Retry attempt 1
2026-10-10 01:00:17 ERROR Configuration file not found
2026-10-10 01:00:18 INFO Job terminated
2026-10-10 02:00:01 INFO Starting second job
2026-10-10 02:00:03 INFO Loading customer data
2026-10-10 02:00:06 INFO Loaded 15000 records
2026-10-10 02:00:12 WARNING Query took longer than expected
2026-10-10 02:00:15 INFO Starting score calculation
2026-10-10 02:00:30 INFO Score calculation completed
2026-10-10 02:00:32 INFO Export completed successfully
EOF

# --- Directory tree for find / globbing ---
printf 'id,score\n101,720\n102,680\n'   > tree/data/customers.csv
printf 'id,amount\n101,1500\n102,2300\n' > tree/data/exposures.csv
printf 'q3,draft\n'                      > "tree/data/Q3 report.csv"
printf 'old,example\n'                   > tree/archive/old_export.csv
printf 'INFO pipeline started\nERROR pipeline failed\n' > tree/logs/pipeline.log
printf 'INFO job completed\n'            > tree/logs/finished.log
printf '# TODO: validate customer IDs\n' > tree/scripts/validate.py
printf 'print("hello")\n'                > tree/scripts/hello.py
touch tree/data/empty.csv
truncate -s 2M tree/data/large_export.csv
touch -d '3 days ago' tree/logs/finished.log tree/archive/old_export.csv

# --- 10,000-row synthetic risk dataset ---
python3 - <<'PY'
import csv, random
random.seed(7)
products = ["working_capital", "invoice_financing", "term_loan"]
statuses = ["approved", "rejected", "pending"]
with open("data/risk_applications.csv", "w", newline="") as f:
    w = csv.writer(f, lineterminator="\n")
    w.writerow(["application_id","product","status","exposure","dpd","score"])
    for i in range(1, 10001):
        w.writerow([i, random.choice(products),
                    random.choices(statuses, weights=[50,30,20])[0],
                    random.randint(1000, 200000),
                    random.choices([0,5,15,30,45,60], weights=[55,10,10,10,10,5])[0],
                    random.randint(400, 850)])
PY

# --- Small CSVs for script checks ---
printf 'customer_id,score,exposure\n101,720,15000\n' > data/valid.csv
printf 'id,score,exposure\n101,720,15000\n'          > data/wrong_header.csv
printf 'customer_id,score,exposure\n'                > data/header_only.csv

# --- Permissions files ---
printf '#!/usr/bin/env bash\necho "Risk pipeline started"\n' > perms/risk_pipeline.sh
printf 'synthetic confidential data\n' > perms/secret.txt
chmod 644 perms/risk_pipeline.sh
chmod 600 perms/secret.txt

echo "Setup done: $(find ~/review-lab -type f | wc -l) files"
```

---

## Questions

### 1 · Redirection + grep · Lab ☐
In `~/review-lab`, save every `ERROR` line from `logs/risk_job.log` to `work/q01.txt`. Then **append** the number of `WARNING` lines to the same file, without opening an editor.
**Done when:** `work/q01.txt` has 3 lines and the last line is `3`.
**Look in:** TLCL Ch. 6 "Redirecting Standard Output", "Pipelines" · `man grep` (`-c`)

### 2 · OSTEP: the process · Theory ☐
What is a process, as opposed to a program? List at least three parts of a process's *machine state* that the OS has to keep track of.
**Look in:** OSTEP Ch. 4 §4.1 "The Abstraction: A Process"

### 3 · What is a command? · Lab ☐
Run `type cd`, `type ls`, `type grep`, and `type type`, and classify each one (builtin, alias, keyword, or executable file). Then find the full path of the `grep` executable and run `file` on it.
**Done when:** you can name grep's path, say what kind of file it is, and explain why `ls` may show up as an alias on Debian.
**Look in:** TLCL Ch. 5 "What Exactly Are Commands?", "Identifying Commands" · Ch. 3 "Determining a File's Type with file" · `help type`

### 4 · OSTEP: limited direct execution · Theory ☐
What does *limited direct execution* mean? What part is "direct", what part is "limited", and why does an OS need both?
**Look in:** OSTEP Ch. 6 intro, §6.1 "Basic Technique", §6.2 "Problem #1: Restricted Operations"

### 5 · find with operators · Lab ☐
In `~/review-lab/tree`, write **one** `find` command that lists regular files that are either empty **or** larger than 1 MB.
**Done when:** the output is exactly `./data/empty.csv` and `./data/large_export.csv` (in either order).
**Look in:** TLCL Ch. 17 "find" → "Tests", "Operators" (pay attention to the parentheses) · `man find`

### 6 · Expansion and quoting · Theory → Lab ☐
From `~/review-lab/logs`, first **predict** the output of the command below, then run it and explain each piece:
```bash
echo ~ *.log {a,b}{1,2} $((7/2)) "$HOME" '$HOME' \$HOME
```
**Look in:** TLCL Ch. 7 "Expansion" (all subsections), "Quoting"

### 7 · OSTEP: scheduling metrics · Theory ☐
Define **turnaround time** and **response time**. Why can a scheduler that is optimal for one of them be poor for the other?
**Look in:** OSTEP Ch. 7 §7.2 "Scheduling Metrics", §7.6 "A New Metric: Response Time"

### 8 · Permissions: execute bit · Lab ☐
In `perms/`, run `./risk_pipeline.sh`. Explain the error you get. Fix it by giving execute permission **to the owner only**, using symbolic notation. Then print the file's mode in octal.
**Done when:** the script prints `Risk pipeline started` and `stat -c '%a' perms/risk_pipeline.sh` shows `744`.
**Look in:** TLCL Ch. 9 "Reading, Writing, and Executing" → chmod · Ch. 24 "Executable Permissions" · `man stat`

### 9 · cut / sort / uniq pipeline · Lab ☐
Using `data/risk_applications.csv`, count applications by `status`, most frequent first, excluding the header. Use `cut`, `sort`, and `uniq` (no awk).
**Done when:** you get 3 lines whose counts add up to 10000.
**Look in:** TLCL Ch. 20 "Revisiting Some Old Friends" (sort, uniq), "Slicing and Dicing" (cut) · Ch. 6 "Pipelines" · `man tail` (`-n +2`)

### 10 · Bridge: your shell creates processes · Bridge ☐
Run `echo $$`, then start a new shell with `bash`, run `echo $$ $PPID`, and then `exit`. What does the output tell you about the relationship between the two shells? Which system calls did the first shell most likely use to start the second one, and what was the parent doing while the child ran?
**Look in:** OSTEP Ch. 5 §5.1 `fork()`, §5.2 `wait()`, §5.3 `exec()` · TLCL Ch. 10 "How a Process Works" · `man bash` → "Special Parameters"

### 11 · OSTEP: the three easy pieces · Theory ☐
What are the three "easy pieces" the book is organized around? For each one, give a one-sentence example of what the OS does.
**Look in:** OSTEP Ch. 2 §2.1–2.4

### 12 · grep: extended regex + alternation · Lab ☐
With a **single** `grep`, find the lines in `logs/risk_job.log` that mention either "configuration" or "export", ignoring case.
**Done when:** you get 4 lines. Also explain why `grep 'configuration|export'` (no `-E`) returns nothing.
**Look in:** TLCL Ch. 19 "POSIX Basic vs. Extended Regular Expressions", "Alternation" · `man grep` (`-E`, `-i`)

### 13 · Permissions on directories · Theory (+ optional check) ☐
What do `r`, `w`, and `x` mean on a **directory**? Predict what happens if you own a directory with mode `300` (`-wx------`): can you `ls` it? `cd` into it? `cat` a file inside whose name you already know?
**Optional check:**
```bash
mkdir work/q13 && echo hi > work/q13/f && chmod 300 work/q13
ls work/q13; cat work/q13/f; chmod 700 work/q13
```
**Look in:** TLCL Ch. 9 "Reading, Writing, and Executing" (the permission attributes table)

### 14 · Job control · Lab ☐
Run `sleep 300` in the foreground. Suspend it, list your jobs, resume it in the background, and then terminate it using its **job spec** (not its PID).
**Done when:** `jobs` is empty and `pgrep -x sleep` doesn't show your process.
**Look in:** TLCL Ch. 10 "Controlling Processes" (all subsections) · `help jobs`, `help bg`, `help kill`

### 15 · OSTEP: process states · Theory ☐
Draw the process state diagram with Running, Ready, and Blocked. Label every transition with what causes it (who decides it, and what event triggers it).
**Look in:** OSTEP Ch. 4 §4.4 "Process States" (Figure 4.2)

### 16 · Shell variable vs. environment variable · Lab ☐
Run each step and explain the three results:
```bash
LAB_MODE=test;        bash -c 'echo "1: [$LAB_MODE]"'
export LAB_MODE;      bash -c 'echo "2: [$LAB_MODE]"'
LAB_MODE=prod         bash -c 'echo "3: [$LAB_MODE]"'; echo "after: $LAB_MODE"
unset LAB_MODE
```
**Look in:** TLCL Ch. 11 "What Is Stored in the Environment?" · `help export` · `man bash` → "ENVIRONMENT"

### 17 · OSTEP: the address space · Theory ☐
Sketch OSTEP's simple address space: which three segments it has and where each one sits. Why do the heap and the stack grow toward each other?
**Look in:** OSTEP Ch. 13 §13.3 "The Address Space"

### 18 · awk: group and sum · Lab ☐
Using `awk`, compute the **total exposure by product** from `data/risk_applications.csv`, skipping the header, and sort the result by total descending.
**Done when:** you get 3 lines, and their sum equals `awk -F, 'NR>1{s+=$4} END{print s}' data/risk_applications.csv`.
**Look in:** `man awk` (Debian's default awk is usually `mawk`; awk isn't covered in TLCL) · TLCL Ch. 20 "sort" · `man sort` (`-n`, `-r`, `-k`)

### 19 · `[ ]` vs `[[ ]]` vs `(( ))` · Theory ☐
What's the difference between the three? Show a value of `x` that makes `[ $x = foo ]` fail with an error, while `[[ $x = foo ]]` works fine, and explain why.
**Look in:** TLCL Ch. 27 "Using test", "A More Modern Version of test", "(( )) — Designed for Integers"

### 20 · OSTEP: system calls and traps · Theory ☐
Walk through a system call step by step, from user mode, through the trap and kernel mode, to the return-from-trap. What is the **trap table**, who sets it up, and when? Why can't a user program simply jump to any kernel address it wants?
**Look in:** OSTEP Ch. 6 §6.2 (Figure 6.2 / the LDE protocol table)

### 21 · stdout vs. stderr · Lab ☐
Run `ls ~/review-lab/logs /nope` four ways:
(a) stdout to `work/out.txt` and stderr to `work/err.txt`;
(b) both streams to `work/all.txt`;
(c) discard only the errors;
(d) run `ls ~/review-lab/logs /nope 2>&1 > work/wrong.txt` and explain why the error still shows on your screen.
**Look in:** TLCL Ch. 6 "Redirecting Standard Error", "Redirecting Standard Output and Standard Error to One File", "Disposing of Unwanted Output"

### 22 · find + exec / xargs · Lab ☐
Under `tree/`, list the `.py` files that contain `TODO`, printing only the file names. Do it twice: once with `find ... -exec grep -l ... {} +` and once with `find ... | xargs grep -l ...`.
**Done when:** both print `tree/scripts/validate.py` (or `./scripts/validate.py`).
**Look in:** TLCL Ch. 17 "User-Defined Actions", "Improving Efficiency", "xargs" · `man find`

### 23 · Bridge: ps states vs. OSTEP states · Bridge ☐
Start `sleep 120 &` and `yes > /dev/null &`, then view them with `ps -o pid,stat,comm`. Run `kill -STOP` on the `yes` process and check again. Map each STAT letter you see (R, S, T) to OSTEP's process states, or explain why it doesn't map cleanly. Kill both processes when you're done.
**Look in:** `man ps` → "PROCESS STATE CODES" · OSTEP Ch. 4 §4.4 · TLCL Ch. 10 "Viewing Processes with ps"

### 24 · OSTEP: fork() and wait() · Theory ☐
How many processes does this program create, and what does it print when run in a terminal? Is the output order guaranteed? What would change if you removed the `wait(NULL)`?
```c
int main() {
    printf("A\n");
    int rc = fork();
    if (rc == 0) { printf("B\n"); }
    else         { wait(NULL); printf("C\n"); }
    return 0;
}
```
**Look in:** OSTEP Ch. 5 §5.1 "The fork() System Call", §5.2 "The wait() System Call"

### 25 · sort by a numeric field · Lab ☐
Print the **10 largest exposures** together with their `application_id`, largest first. Then explain what would go wrong if you left out `-n`.
**Done when:** you get 10 lines, and the first exposure equals `awk -F, 'NR>1 && $4>m{m=$4} END{print m}' data/risk_applications.csv`.
**Look in:** `man sort` (`-t`, `-k`, `-n`, `-r`) · TLCL Ch. 20 "sort"

### 26 · Finding documentation · Theory ☐
Which tool would you use for help with each of these: (a) `cd`, (b) `find`, (c) a task where you don't know the command name, such as "compress files"? Why does `man cd` probably fail on your Debian machine?
**Look in:** TLCL Ch. 5 "Getting a Command's Documentation" (help, --help, man, apropos, whatis, info)

### 27 · Your first script · Lab ☐
Create `scripts/lab-info` with a shebang, one constant (for example, `TITLE`), and a **here document** that prints a short report including the current date and the hostname. Make it executable and run it **from a different directory** using its path.
**Look in:** TLCL Ch. 24 "How to Write a Shell Script", "Script File Format" · Ch. 25 "Variables and Constants", "Here Documents"

### 28 · OSTEP: regaining control of the CPU · Theory ☐
Compare the *cooperative* and *non-cooperative* approaches to switching between processes. What does the timer interrupt guarantee? During a context switch, what gets saved, and where is it stored?
**Look in:** OSTEP Ch. 6 §6.3 "Problem #2: Switching Between Processes"

### 29 · Regex: anchors, classes, quantifiers · Lab ☐
(a) Count the lines in `logs/risk_job.log` that **start** with a `YYYY-MM-DD` date, using an anchored extended regex with quantifiers.
(b) Use `grep -o` to extract only the `HH:MM:SS` times.
**Done when:** (a) prints 17 and (b) prints 17 time values.
**Look in:** TLCL Ch. 19 "Anchors", "Bracket Expressions and Character Classes", "Quantifiers" · `man grep` (`-o`, `-c`)

### 30 · OSTEP: FIFO vs. Round Robin (calculate) · Theory ☐
Jobs A, B, and C all arrive at t=0 and each needs 5 time units. Compute the average **turnaround** and average **response** time under (a) FIFO and (b) Round Robin with a time slice of 1. What does the comparison show?
**Look in:** OSTEP Ch. 7 §7.3 "FIFO", §7.7 "Round Robin"

### 31 · umask and numeric chmod · Lab ☐
Run `umask`. **Predict** the permissions of a new file and a new directory, then create them in `work/` and check with `ls -l`. After that, use numeric notation to make `perms/secret.txt` read-only for the owner, confirm it, and restore it to `600`.
**Done when:** your predictions match `ls -l`, and `secret.txt` ends up back at `-rw-------`.
**Look in:** TLCL Ch. 9 "chmod", "umask"

### 32 · Bridge: why is `cd` a builtin? · Bridge ☐
Explain why `cd` *has* to be a shell builtin rather than a program in `/usr/bin`. Base your answer on how the shell runs external commands.
**Look in:** OSTEP Ch. 5 §5.3 "The exec() System Call", §5.4 "Why? Motivating the API" · TLCL Ch. 5 "What Exactly Are Commands?"

### 33 · Functions + file tests + exit status · Lab ☐
Write `scripts/check-file` with a function `check_file` that takes a path (use `$1`, which is covered in Ch. 32). The function should check that the path exists, is a regular file, is readable, and is not empty. On failure it prints a clear message and returns nonzero, and the script exits with that status.
Test it on `data/valid.csv`, `tree/data/empty.csv`, `tree/data`, and `/nope`.
**Done when:** `echo $?` gives `0` only for `valid.csv`, and each failure prints a different message.
**Look in:** TLCL Ch. 26 "Shell Functions", "Local Variables" · Ch. 27 "Exit Status", "File Expressions" · Ch. 32 "Accessing the Command Line"

### 34 · OSTEP: goals of virtual memory · Theory ☐
Name and explain the three goals of a virtual memory system. If a C program prints the address of a variable, is that a physical or a virtual address? Why?
**Look in:** OSTEP Ch. 13 §13.4 "Goals" (and the aside on "every address you see is virtual")

### 35 · Word splitting and filenames with spaces · Lab ☐
`tree/data/` contains `Q3 report.csv`. Use a glob to run `wc -l` on every CSV in that directory, and note that it works. Then run:
```bash
f="tree/data/Q3 report.csv"; wc -l $f; wc -l "$f"
```
Explain why the glob handled the space correctly but the unquoted `$f` didn't.
**Look in:** TLCL Ch. 7 "Double Quotes" (word splitting), "Pathname Expansion" · Ch. 4 "Wildcards"

### 36 · Keyboard and history tricks · Theory ☐
How do you: (a) search your history backward interactively, (b) reuse the last argument of the previous command, (c) rerun the most recent command that started with `grep`, (d) jump to the beginning of the line, (e) delete from the cursor to the end of the line?
**Look in:** TLCL Ch. 8 "Command Line Editing", "Using History"

### 37 · Hard links vs. symbolic links · Lab ☐
From `~/review-lab`: copy `tree/` recursively to `work/tree_bak`; create a symlink `work/latest_log` pointing to `logs/risk_job.log` (use an absolute path); create a hard link `work/hard_log` to the same file. Then run `ls -li` on all three.
**Done when:** you can explain why the hard link shares the original's inode number and link count while the symlink doesn't, and what happens to each one if the original is deleted.
**Look in:** TLCL Ch. 4 "cp", "ln", "Hard Links", "Symbolic Links" · Ch. 3 "Symbolic Links"

### 38 · OSTEP: from program to process · Theory ☐
What steps does the OS take to turn a program stored on disk into a running process? What does "loading lazily" mean, and why do modern OSes do it?
**Look in:** OSTEP Ch. 4 §4.3 "Process Creation: A Little More Detail"

### 39 · Signals · Lab ☐
Start `yes > /dev/null &` and save its PID with `pid=$!`. Send it SIGSTOP and check its state with `ps -o pid,stat,comm -p "$pid"`. Send SIGCONT and check again. Then send SIGTERM. Which two signals can a process **not** catch or ignore?
**Done when:** you saw the states change (T, then R), and `ps -p "$pid"` finally shows nothing.
**Look in:** TLCL Ch. 10 "Signals", "Sending Signals to Processes with kill" · `kill -l` · `man 7 signal`

### 40 · OSTEP: SJF vs. STCF (calculate) · Theory ☐
Job A (runtime 100) arrives at t=0. Jobs B and C (runtime 10 each) arrive at t=10. Compute the average turnaround time under **SJF** (non-preemptive) and under **STCF**. Which assumption does STCF relax?
**Look in:** OSTEP Ch. 7 §7.4 "Shortest Job First", §7.5 "Shortest Time-to-Completion First"

### 41 · sed, tr, diff · Lab ☐
(a) Write a copy of `logs/risk_job.log` to `work/short.log` in which `WARNING` becomes `WARN`, using `sed`.
(b) Use `diff` to show what changed.
(c) Print the header of `data/risk_applications.csv` in uppercase using `tr`.
**Done when:** `diff` shows exactly 3 changed lines and the original log is unchanged.
**Look in:** TLCL Ch. 20 "Editing on the Fly" (tr, sed), "Comparing Text" (diff)

### 42 · Bridge: environment inheritance · Bridge ☐
Why does `export X=1` run inside a child `bash` have no effect on the parent shell once the child exits? Explain using what `fork()` copies. Then explain the difference between `bash ~/.bashrc` and `source ~/.bashrc`.
**Look in:** OSTEP Ch. 5 §5.1 · TLCL Ch. 11 "How Is the Environment Established?", "Activating Our Changes" · `help source`

### 43 · Control operators `&&` and `||` · Lab ☐
Without using `if`:
(a) create `work/reports` only if it doesn't already exist, and then print `ready`;
(b) print `missing` if `data/nope.csv` doesn't exist.
Then predict the output of `true && false || echo fallback` and explain why `a && b || c` isn't a true if/else.
**Look in:** TLCL Ch. 27 "Control Operators: Another Way to Branch", "File Expressions"

### 44 · OSTEP: process data structures (PCB) · Theory ☐
What is a process control block / the process list? List the kinds of information xv6's `struct proc` keeps, and explain why the **register context** has to be saved there.
**Look in:** OSTEP Ch. 4 §4.5 "Data Structures" (Figure 4.5, xv6 proc structure)

### 45 · Inspecting processes with ps · Lab ☐
(a) Show the 5 processes using the most memory, with PID, %MEM, and command name, using `ps` alone (no `top`).
(b) Show the PID, PPID, and command of your current shell, and of its parent.
**Look in:** TLCL Ch. 10 "Viewing Processes with ps", "Viewing Processes Dynamically with top" · `man ps` (`-o`, `--sort`, `-p`)

### 46 · OSTEP: virtualizing the CPU and memory · Theory ☐
In Ch. 2, running several copies of `cpu` (and of `mem`) shows two illusions the OS creates. What are they? Why do two copies of `mem` print the **same** address while working on different data?
**Look in:** OSTEP Ch. 2 §2.1 "Virtualizing the CPU", §2.2 "Virtualizing Memory"

### 47 · Customizing the prompt · Lab ☐
For the current session only, set `PS1` to show your username, the current directory, and the **exit status of the previous command**. Check it by running `false` and then `true`. Why do you need single quotes rather than double quotes to make the exit status update?
**Look in:** TLCL Ch. 13 "Anatomy of a Prompt", "Trying Some Alternative Prompt Designs" · `man bash` → "PROMPTING"

### 48 · find by age and negation · Lab ☐
Under `tree/`, find regular files that were modified **more than 2 days ago** and are **not** `.log` files, and show their details using `-ls`.
**Done when:** the only result is `archive/old_export.csv`. Explain how `-mtime +2` rounds file ages.
**Look in:** TLCL Ch. 17 "Tests" (`-mtime`), "Operators" (`-not` / `!`), "Predefined Actions" (`-ls`) · `man find` → `-atime` (explains the rounding)

### 49 · OSTEP: scheduling with I/O · Theory ☐
How does a scheduler take I/O into account? Explain the idea of **overlap**, and why it helps to treat each CPU burst of an interactive job as its own "job".
**Look in:** OSTEP Ch. 7 §7.8 "Incorporating I/O", §7.9 "No More Oracle"

### 50 · Mini script: awk + `(( ))` + exit codes · Lab ☐
Write `scripts/avg-score` that:
1. exits with status 1 and a message if `data/risk_applications.csv` isn't readable;
2. uses `awk` to compute the **average score of approved applications**;
3. uses `(( ))` to print `HIGH` if the average is above 600 and `LOW` otherwise.
Watch out for the integer limitation of `(( ))`.
**Done when:** it prints the average and `HIGH`, and it exits nonzero if you temporarily point it at a missing file.
**Look in:** TLCL Ch. 27 "(( )) — Designed for Integers", "Exit Status", "File Expressions" · Ch. 25 "Variables and Constants" · `man awk` (`printf`)

---

*Topic recurrence: grep 1·12·22·29 · find 5·22·48 · redirection 1·21 · sort/cut/uniq 9·25 · awk 18·50 · permissions 8·13·31 · processes/jobs/signals 14·23·39·45 · environment 16·42·47 · expansion/quoting 6·35 · scripting 19·27·33·43·50 · links/files 37 · docs/commands 3·26·32 · OSTEP processes 2·15·38·44 · fork/exec 10·24·32·42 · LDE 4·20·28 · scheduling 7·30·40·49 · address spaces 17·34·46 · OS intro 11·46*
