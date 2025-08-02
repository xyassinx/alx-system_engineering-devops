# Shell, init files, variables and expansions

This project demonstrates my understanding of Linux shell commands, environment variables, and scripting basics. Each subsection describes the corresponding shell script found in this repository.

---

## 0-alias

Creates an alias `ls` that removes all contents in the current directory.

```
$ ls
0-alias  file1  file2
$ source ./0-alias
$ ls
$ \ls
0-alias  file1  file2
```

## 1-hello\_you

Prints “hello” followed by the current logged-in user.

```
$ ./1-hello_you
hello ubuntu
```

## 2-path

Adds `/action` to the end of the `$PATH` environment variable.

```
$ echo $PATH
/usr/bin:/bin
$ source ./2-path
$ echo $PATH
/usr/bin:/bin:/action
```

## 3-paths

Counts the number of directories in the `$PATH`.

```
$ echo $PATH
/usr/bin:/bin:/action
$ ./3-paths
3
```

## 4-global\_variables

Prints all global environment variables.

```
$ ./4-global_variables
SHELL=/bin/bash
USER=ubuntu
PATH=/usr/bin:/bin
...
```

## 5-local\_variables

Prints local variables and shell functions.

```
$ ./5-local_variables
BASH=/bin/bash
myfunc () {
  echo "hello"
}
```

## 6-create\_local\_variable

Creates a local variable `BEST=School`.

```
$ source ./6-create_local_variable
$ echo $BEST
School
```

## 7-create\_global\_variable

Creates a global variable `BEST=School` using `export`.

```
$ source ./7-create_global_variable
$ echo $BEST
School
```

## 8-true\_knowledge

Adds 128 to the value in `TRUEKNOWLEDGE`.

```
$ export TRUEKNOWLEDGE=22
$ ./8-true_knowledge
150
```

## 9-divide\_and\_rule

Divides `POWER` by `DIVIDE` and prints the result.

```
$ export POWER=100
$ export DIVIDE=5
$ ./9-divide_and_rule
20
```

## 10-love\_exponent\_breath

Calculates `BREATH ** LOVE` and prints the result.

```
$ export BREATH=2
$ export LOVE=10
$ ./10-love_exponent_breath
1024
```

## 11-binary\_to\_decimal

Converts binary number to decimal.

```
$ export BINARY=101
$ ./11-binary_to_decimal
5
```

## 12-combinations

Prints all two-letter lowercase combinations except `oo`.

```
$ ./12-combinations
aa
ab
...
on
op
...
oz
pa
...
zz
```

## 13-print\_float

Prints a float with 2 decimal places.

```
$ export NUM=3.14159
$ ./13-print_float
3.14
```

## 100-decimal\_to\_hexadecimal

Converts decimal to hexadecimal.

```
$ export DECIMAL=255
$ ./100-decimal_to_hexadecimal
ff
```

## 101-rot13

Encodes and decodes text using ROT13.

```
$ echo "hello" | ./101-rot13
uryyb
```

## 102-odd

Prints every other line from standard input.

```
$ cat myfile.txt | ./102-odd
line 1
line 3
line 5
```

## 103-water\_and\_stir

Adds two numbers from custom base inputs using `WATER` and `STIR` and outputs
in a different base defined by `BESTCHOL`.

```
$ export WATER="ewwatratewa"
$ export STIR="ti.itirtrtr"
$ ./103-water_and_stir
shtbeolhc
```
