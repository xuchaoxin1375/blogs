[toc]

## 正则语法参考

- For details about regexp syntax see [Regular Expression Addresses](https://www.gnu.org/software/sed/manual/sed.html#Regexp-Addresses).
- [BRE|sed, a stream editor (gnu.org)](https://www.gnu.org/software/sed/manual/sed.html#BRE-syntax)
- [ERE|sed, a stream editor (gnu.org)](https://www.gnu.org/software/sed/manual/sed.html#ERE-syntax)

### Overview of regular expression in `sed`

- To know how to use `sed`, people should understand regular expressions (*regexp* for short). A regular expression is a pattern that is matched against a subject string from left to right. 
- Most characters are *ordinary*: they stand for themselves in a pattern, and match the corresponding characters. 
- Regular expressions in `sed` are specified <u>between two slashes`/`</u>.

- The following command prints lines containing the word ‘hello’:

```bash
sed -n '/hello/p'
#
➜  ~ echo "hellow sed \n editor.a-b-"|sed -n '/hello/p'
hellow sed
```

- The above example is equivalent to this `grep` command:

```bash
sed -n '/hello/p'
grep 'hello'
```

- The power of regular expressions comes from the ability to include alternatives and repetitions in the pattern. 
- These are encoded in the pattern by the use of *special characters*, which do not stand for themselves but instead are interpreted in some special way.

- The character `^` (caret) in a regular expression matches the beginning of the line.

-  The character `.` (dot) matches any single character.

-  The following `sed` command matches and prints lines which start with the letter ‘b’, 

  - `'/^b.d/p'`

  - followed by any single character, followed by the letter ‘d’:

  - ```
    $ printf "%s\n" abode bad bed bit bid byte body | sed -n '/^b.d/p'
    bad
    bed
    bid
    body
    ```

- The following sections explain the meaning and usage of special characters in regular expressions.





