[toc]



## 数组



 [Bash](https://mywiki.wooledge.org/Bash) 支持多种参数类型。其中，变量可以包含单个值（标量），也可以包含多个值（数组）。

字符串无疑是最常用的参数类型，但同时也是最容易被误用的参数类型。务必记住，一个字符串只能容纳**一个**元素。例如，将命令的输出结果放入字符串参数中，意味着该参数只能包含**一个**字符串，无论这个字符串代表的是二十个文件名、二十个数字还是二十个人名。

就像所有将多个项目放入同一个字符串的情况一样，这些项目必须以某种方式彼此分隔开来。作为人类，我们通常能够通过查看字符串来辨别不同的文件名。我们通常会假设字符串中的每一行或每个单词代表一个文件名。虽然这种假设可以理解，但它本身也存在缺陷。每个文件名都可以包含任何你可能想用来分隔字符串中文件名的字符。这意味着，从技术上讲，我们无法确定字符串中第一个文件名的结束位置，因为没有哪个字符可以表示“我表示这个文件名的结束”，因为该字符本身也可能是文件名的一部分。

人们常常会犯这样的错误：



```
# This does NOT work in the general case
$ files=$(ls ~/*.jpg); cp $files /backups/
```



这时，使用数组表示法（稍后将在下一节中解释）可能是一个更好的选择：



```
# This DOES work in the general case
$ files=(~/*.jpg); cp "${files[@]}" /backups/
```



第一次尝试备份当前目录中的文件存在缺陷。我们将 `ls` 的输出放入名为 `files` 的字符串中，然后使用**未加引号的** `$files` 参数扩展将该字符串分割成参数（依赖于*单词分割* ）。如前所述，参数分割和单词分割都会在字符串中出现空格的地方将其分割成多个部分。依赖这种方法意味着我们假设文件名中不会包含任何空格。如果文件名包含空格，则文件名将被截断一半或更多。结论： **不好** 。

在 Bash 中，表示**多个**字符串元素的唯一安全方法是使用数组。数组是一种将**整数映射到字符串的**变量。它本质上是一个编号的字符串列表。由于每个字符串都是一个独立的实体（元素），因此它可以安全地包含任何字符，甚至包括空格。

为了获得最佳效果并减少麻烦，请记住，如果您有一系列事物，则应始终将其放入数组中。

与其他一些编程语言不同，Bash 不提供列表、元组等，只有数组和关联数组（这是 Bash 4 中的新功能）。



------



- *数组* ：数组是字符串的编号列表：它将整数映射到字符串。



------





## 创建数组



创建数组或向数组填充数据的方法有很多种。没有唯一正确的方法：你需要使用的方法取决于你的数据来源和数据类型。

创建包含数据的简单数组的最简单方法是使用 `=()` 语法：



```
$ names=("Bob" "Peter" "$USER" "Big Bad John")
```



这种语法非常适合创建包含静态数据或已知字符串参数集的数组，但它在添加大量数组元素方面灵活性很差。如果需要更大的灵活性，您还可以指定显式索引：



```
$ names=([0]="Bob" [1]="Peter" [20]="$USER" [21]="Big Bad John")
# or...
$ names[0]="Bob"
```



请注意，在本例中索引 1 到 20 之间存在一个空隙。这种包含空隙的数组称为*稀疏数组* 。Bash 允许使用稀疏数组，而且这通常非常有用。

如果你想用文件名填充一个数组，那么你可能需要使用 *Glob 模式* ：



```
$ photos=(~/"My Photos"/*.jpg)
```



请注意，我们这里用引号括起了 `My Photos` 部分，因为它包含一个空格。如果不加引号，Bash 会将其拆分成 `photos=('~/My' 'Photos/'*.jpg )` ，这显然**不是**我们想要的结果。还要注意，我们**只**用引号括起了包含空格的部分。这是因为我们不能用引号括起 `~` 或 `*` ；如果这样做，它们就会变成字面值，Bash 将不再把它们视为特殊字符。

不幸的是，通过以下方式很容易创建包含大量文件名的数组， **从而造成歧义** ：



```
$ files=$(ls)    # BAD, BAD, BAD!
$ files=($(ls))  # STILL BAD!
```



请记住， **务必避免**使用 `ls. ` 。第一个方法会创建一个包含 `ls` 输出的**字符串** 。由于 `Arrays` 引言中提到的原因，该字符串无法安全使用。第二个方法更接近目标，但仍然会用空格分割文件名。

这是正确的做法：



```
$ files=(*)      # Good!
```



这条语句会生成一个数组，其中每个文件名都是一个单独的元素。 `*` 是 `any string` 的 glob 模式，它会将路径名展开为当前目录中的所有文件名（就像 `rm *` 一样）。路径名展开后，命令将类似于 `files=([each file in the current directory that matches *])` ，它会将所有文件赋值给数组 `files` 。完美！

*我们即将介绍的这一部分包含一些高级概念。如果您感到困惑，建议您在阅读完整指南后再返回此处。如果您想保持学习的简单性，可以直接跳到 [“使用数组”部分 ](https://mywiki.wooledge.org/BashGuide/Arrays#Using_Arrays)。*

Now, sometimes we want to build an array from a string or the output of a command. Commands (generally) just output strings: for instance, running a `find` command will enumerate filenames, and separate these filenames with newlines (putting each filename on a separate line). So to parse that one big string into an array we need to tell Bash where each element ends. (Note, this is a bad example, because filenames can **contain** a newline, so it is not safe to delimit them with newlines! But see below.)

Breaking up a string is what `IFS` is used for:



```
$ IFS=. read -ra ip_elements <<< "127.0.0.1"
```



Here we use `IFS` with the value `.` to cut the given IP address into array elements wherever there's a `.`, resulting in an array with the elements `127`, `0`, `0` and `1`. (The builtin command `read` and the `<<<` operator will be covered in more depth in the [Input and Output](https://mywiki.wooledge.org/BashGuide/InputAndOutput) chapter.)

We could do the same thing with a `find` command, by setting `IFS` to a newline. But then our script would fail when someone creates a filename with a newline in it (either accidentally or maliciously).

So, is there any way to get a list of elements from an external program (like `find`) into a Bash array? In general, the answer is yes, provided there is a reliable way to delimit the elements.

In the specific case of filenames, the answer to this problem is NUL bytes. A NUL byte is a byte which is just all zeros: `00000000`. Bash strings can't contain NUL bytes, because of an artifact of the "C" programming language: NUL bytes are used in C to mark the end of a string. Since Bash is written in C and uses C's native strings, it inherits that behavior.

A data stream (like the output of a command, or a file) can contain NUL bytes. Streams are like strings with three big differences: they are read sequentially (you usually can't jump around); they're *unidirectional* (you can read from them, or write to them, but typically not both); and they can contain NUL bytes.

File *names* cannot contain NUL bytes (since they're implemented as C strings by Unix), and neither can the vast majority of human-readable things we would want to store in a script (people's names, IP addresses, etc.). That makes NUL a great candidate for separating elements in a stream. Quite often, the command whose output you want to read will have an option that makes it output its data separated by NUL bytes rather than newlines or something else. `find` (on GNU and BSD, anyway) has the option `-print0`, which we'll use in this example:



```
$ files=()
$ while read -r -d ''; do
>     files+=("$REPLY")
> done < <(find /foo -print0)
```



This is a safe way of parsing a command's output into strings. Understandably, it looks a little confusing and convoluted at first. So let's take it apart:

- The first line `files=()` creates an empty array named `files`.
- We're using a [while loop](https://mywiki.wooledge.org/BashGuide/TestsAndConditionals#Conditional_Loops) that runs a `read` command each time. The `read` command uses the `-d ''` option to specify the delimiter and it interprets the empty string as a NUL byte (`\0`) (as Bash arguments can not contain NULs). This means that instead of reading a line at a time (up to a newline), we're reading up to a NUL byte. It also uses `-r` to prevent it from treating backslashes specially.
- Once `read` has read some data and encountered a NUL byte, the `while` loop's body is executed. We put what we read (which is in the parameter `REPLY`) into our array.
- To do this, we use the `+=()` syntax. This syntax adds one or more element(s) to the end of our array.
- Finally, the `< <(..)` syntax is a combination of *File Redirection* (`<`) and *Process Substitution* (`<(..)`). Omitting the technical details for now, we'll simply say that this is how we send the output of the `find` command into our `while` loop.

The `find` command itself uses the `-print0` option as mentioned before to tell it to separate the filenames it finds with a NUL byte.

As an aside, check out [globstar](https://mywiki.wooledge.org/glob#globstar_.28since_bash_4.0-alpha.29) if you are using bash >= 4.0 and just want to recursively walk directories.



------



- **Good Practice:
  Arrays are a safe list of strings. They are perfect for storing multiple filenames.
  If you have to parse a stream of data into component elements, there must be a way to tell where each element starts and ends. The NUL byte is very often the best choice for this job.
  If you have a list of things, keep it in list form as long as possible. Don't smash it into a string or a file until you absolutely have to. If you do have to write it out to a file and read it back in later, keep in mind the delimiter problem we mentioned above.**



------



- **In The Manual: [Arrays](http://www.gnu.org/software/bash/manual/bashref.html#Arrays)**



------



- **In the FAQ:
  [How can I use array variables?](https://mywiki.wooledge.org/BashFAQ/005)
  [How can I use variable variables (indirect variables, pointers, references) or associative arrays?](https://mywiki.wooledge.org/BashFAQ/006)
  [How can I find and deal with file names containing newlines, spaces or both?](https://mywiki.wooledge.org/BashFAQ/020)
  [I set variables in a loop. Why do they suddenly disappear after the loop terminates? Or, why can't I pipe data to read?](https://mywiki.wooledge.org/BashFAQ/024)**



------





## Using Arrays



Once we have an array, there are several things we can do with it.



### Expanding Elements



First of all, we can print the contents to see what's in it:



```
$ declare -p myfiles
declare -a myfiles='([0]="/home/wooledg/.bashrc" [1]="billing codes.xlsx" [2]="hello.c")'
```



The `declare -p` command prints the contents of one or more variables. In addition, it shows you what Bash thinks the *type* of the variable is, and it does all of this using code that you could copy and paste into a script. In our case, the `-a` means this is an array. There are three elements, with indices 0, 1 and 2, and we can see what each one contains.

If we want something a bit less technical, we can also print the array using `printf`:



```
$ printf '%s\n' "${myfiles[@]}"
/home/wooledg/.bashrc
billing codes.xlsx
hello.c
```



This prints each array element, in order by index, with a newline after each one. Note that if one of the array elements happens to *contain* a newline character, we won't be able to tell where each element starts and ends, or even how many there are. That's why it's important to keep our data safely contained in the array as long as possible. Once we print it out, there's no way to reverse that.

The syntax `"${myfiles[@]}"` is extremely important. It works just like `"$@"` does for the positional parameters: it expands to a list of words, with each array element as *one* word, no matter what it contains. Even if there are spaces, tabs, newlines, quotation marks, or any other kind of characters in one of the array elements, it'll still be passed along as one word to whichever command we're running.

The `printf` command implicitly loops over all of its arguments. But what if we wanted to do our own loop? In that case, we can use a [for loop](https://mywiki.wooledge.org/BashGuide/TestsAndConditionals#Conditional_Loops) to iterate over the elements:



```
$ for file in "${myfiles[@]}"; do
>     cp "$file" /backups/
> done
```



We use the **quoted** form again here: `"${myfiles[@]}"`. Bash replaces this syntax with each element in the array properly quoted – similar to how positional parameters (arguments that were passed to the current script or function) are expanded.

The following two examples have the same effect:



```
$ names=("Bob" "Peter" "$USER" "Big Bad John")
$ for name in "${names[@]}"; do echo "$name"; done
```





```
$ for name in "Bob" "Peter" "$USER" "Big Bad John"; do echo "$name"; done
```



The first example creates an array named `names` which is filled up with a few elements. Then the array is expanded into these elements, which are then used by the `for` loop. In the second example, we skipped the array and just passed the list of elements directly to `for`.

Remember to **quote** the `${arrayname[@]}` expansion properly. If you don't, you'll lose all benefit of having used an array at all: leaving arguments unquoted means you're telling Bash it's OK to wordsplit them into pieces and break everything again.

The above example expanded the array in a `for`-loop statement. But you can expand the array anywhere you want to put its elements as arguments; for instance in a `cp` command:



```
$ myfiles=(db.sql home.tbz2 etc.tbz2)
$ cp "${myfiles[@]}" /backups/
```



This runs the `cp` command, replacing the `"${myfiles[@]}"` part with every filename in the `myfiles` array, properly quoted. After expansion, Bash will effectively run this:



```
$ cp "db.sql" "home.tbz2" "etc.tbz2" /backups/
```



`cp` will then copy the files to your `/backups/` directory.

Of course, a `for` loop offers the ultimate flexibility, but `printf` and its implicit looping over arguments can cover many of the simpler cases. It can even produce NUL-delimited streams, perfect for later retrieval:



```
$ printf "%s\0" "${myarray[@]}" > myfile
```



You can also expand single array elements by referencing their element number (called **index**). Remember that by default, arrays are *zero-based*, which means that their **first element** has the index **zero**:



```
$ echo "The first name is: ${names[0]}"
$ echo "The second name is: ${names[1]}"
```



(You could create an array with no element 0. Remember what we said about *sparse arrays* earlier -- you can have "holes" in the sequence of indices, and this applies to the beginning of the array as well as the middle. It's your responsibility as the programmer to know which of your arrays are potentially sparse, and which ones are not.)

There is also a second form of expanding all array elements, which is `"${arrayname[*]}"`. This form is **ONLY** useful for converting arrays into a single string with all the elements joined together. The main purpose for this is outputting the array to humans:



```
$ names=("Bob" "Peter" "$USER" "Big Bad John")
$ echo "Today's contestants are: ${names[*]}"
Today's contestants are: Bob Peter lhunath Big Bad John
```



Notice that in the resulting string, there's no way to tell where the names begin and end! This is why we keep everything separate as long as possible.

Remember to still keep everything nicely **quoted**! If you don't keep `${arrayname[*]}` quoted, once again Bash's [WordSplitting](https://mywiki.wooledge.org/WordSplitting) will cut it into bits.

You can combine `IFS` with `"${arrayname[*]}"` to indicate the character to use to delimit your array elements as you merge them into a single string. This is handy, for example, when you want to comma delimit names:



```
$ names=("Bob" "Peter" "$USER" "Big Bad John")
$ ( IFS=,; echo "Today's contestants are: ${names[*]}" )
Today's contestants are: Bob,Peter,lhunath,Big Bad John
```



Notice how in this example we put the `IFS=,; echo ...` statement in a [Subshell](https://mywiki.wooledge.org/BashGuide/CompoundCommands#Subshells) by wrapping `(` and `)` around it. We do this because we don't want to change the default value of `IFS` in the main shell. When the subshell exits, `IFS` still has its default value and no longer just a comma. This is important because `IFS` is used for a lot of things, and changing its value to something non-default will result in very odd behavior if you don't expect it!

Alas, the `"${array[*]}"` expansion only uses the *first* character of `IFS` to join the elements together. If we wanted to separate the names in the previous example with a comma and a space, we would have to use some other technique (for example, a `for` loop).

One final tip: you can get the number of elements of an array by using `${#array[@]}`



```
$ array=(a b c)
$ echo ${#array[@]}
3
```





### Expanding Indices



Sometimes a problem requires more than just expanding the values of an array in order. You may need to refer to multiple elements at the same time, or refer to the same index in multiple arrays at the same time. In these cases, it's better to expand the array indices, instead of the array values.

Let's say we have two arrays: `first` and `last`. These will hold the first names, and the last names, of a list of people. Obviously we need to make sure that the first and last names of each person are properly matched up. We do this by keeping careful control of the indices.



```
$ first=(Jessica Sue Peter)
$ last=(Jones Storm Parker)
```



Now, to print the full name of the person with index 1:



```
$ echo "${first[1]} ${last[1]}"
Sue Storm
```



If we want to loop over all of the names, we can't just loop over `"${first[@]}"` or `"${last[@]}"`. If we do that, we won't have an index into the *other* array, so we won't know how to match them up. Instead, we'll loop over the indices of one of the arrays (arbitrarily chosen), and then use that same index in both arrays together:



```
$ for i in "${!first[@]}"; do
> echo "${first[i]} ${last[i]}"
> done
Jessica Jones
Sue Storm
Peter Parker
```



So, we have a new piece of syntax: `"${!arrayname[@]}"` expands to a list of the *indices* of an array, in sequential order.

Another feature worth mentioning is that the `[...]` around the index of an array actually creates an arithmetic context. You can do math there, without wrapping it in `$((...))`. Let's suppose we want to process an array two elements at a time, and let's also suppose we know this array can't be *sparse*. Then:



```
$ a=(a b c q w x y z)
$ for ((i=0; i<${#a[@]}; i+=2)); do
> echo "${a[i]} and ${a[i+1]}"
> done
```



We use the arithmetic expression `i+1` as an array index. Bash will evaluate the `i` parameter first, and keep evaluating the value it receives as long as it is a valid *Name*, until it gets to an integer. Then it will add 1, and use that as the real index.



### Sparse Arrays



We've mentioned sparse arrays already, so this will be brief. Most arrays simply have indices 0, 1, 2, 3, etc. But an array can also have "holes" in the sequence. This can be done either by assigning directly to an index that's way out past the current end of the array, or by *removing* an element from an existing array.



```
$ nums=(zero one two three four)
$ nums[70]="seventy"
$ unset 'nums[3]'
$ declare -p nums
declare -a nums='([0]="zero" [1]="one" [2]="two" [4]="four" [70]="seventy")'
```



Note that we quoted `'nums[3]'` in the `unset` command. This is because an *unquoted* `nums[3]` could be interpreted by Bash as a filename glob. If it happens to match a file in the current directory, then `nums[3]` becomes `nums3` and we will unset the wrong variable. That would be bad!

If you follow the practices we've outlined so far, sparse arrays shouldn't cause you any special concerns.

- Don't assume that your indices are sequential.
- If the index values matter, always iterate over the indices instead of making assumptions about them.
- If you loop over the values instead, don't assume anything about which index you might be on currently.
- In particular, don't assume that just because you're currently in the first iteration of your loop, that you must be on index 0!

When you expand the values of a sparse array using `"${arrayname[@]}"` you will get a list with no gaps in it. There is no way to tell what kind of array these values came from. This can be useful if you want to *re-index* an array to remove all of the gaps:



```
$ array=("${array[@]}")      # This re-creates the indices.
```





------



- **Good Practice:
  Always quote your array expansions properly, just like you would your normal parameter expansions.
  Use `"${myarray[@]}"` to expand all your array elements and ONLY use `"${myarray[\*]}"` when you want to merge all your array elements into a single string.**



------





## Associative Arrays



Until recently, Bash could only use numbers (more specifically, non-negative integers) as keys of arrays. This means you could not "map" or "translate" one string to another. This is something a lot of people missed. People began to (ab)use [variable indirection](https://mywiki.wooledge.org/BashFAQ/006) as a means to address the issue.

Since Bash 4 was released, there is no longer any excuse to use indirection (or **worse**, `eval`) for this purpose. You can now use full-featured associative arrays.

To create an associative array, you need to declare it as such (using `declare -A`). This is necessary, because otherwise bash doesn't know what kind of array you're trying to make. Here's how you make an associative array:



```
$ declare -A fullNames
$ fullNames=( ["lhunath"]="Maarten Billemont" ["greycat"]="Greg Wooledge" )
$ echo "Current user is: $USER.  Full name: ${fullNames[$USER]}."
Current user is: lhunath.  Full name: Maarten Billemont.
```



We can print the contents of an associative array very much like we did with regular arrays:



```
$ declare -A dict
$ dict[astro]="Foo Bar"
$ declare -p dict
declare -A dict='([astro]="Foo Bar")'
```



With the same syntax as for indexed arrays, you can iterate over the keys (indices) of associative arrays:



```
$ for user in "${!fullNames[@]}"
> do echo "User: $user, full name: ${fullNames[$user]}."; done
User: lhunath, full name: Maarten Billemont.
User: greycat, full name: Greg Wooledge.
```



Two things to remember, here: First, the order of the keys you get back from an associative array using the `"${!array[@]}"` syntax is unpredictable; it won't necessarily be the order in which you assigned elements, or any kind of sorted order. Likewise, if you expand the elements using `"${array[@]}"` you will get them in an unpredictable order. Associative arrays are *not* well suited to storing lists that need to be processed in a specific order.

Second, you cannot omit the `$` if you're using a parameter as the key of an associative array. With standard indexed arrays, the `[...]` part is an arithmetic context. In an arithmetic context, a *Name* can't possibly be a valid number, and so BASH assumes it's a parameter and that you want to use its content. This doesn't work with associative arrays, since a *Name* could just as well be a valid associative array key.

Let's demonstrate with examples:



```bash
$ indexedArray=( "one" "two" )
$ declare -A associativeArray=( ["foo"]="bar" ["alpha"]="omega" )
$ index=0 key="foo"
$ echo "${indexedArray[$index]}"
one
$ echo "${indexedArray[index]}"
one
$ echo "${indexedArray[index + 1]}"
two
$ echo "${associativeArray[$key]}"
bar
$ echo "${associativeArray[key]}"

$ echo "${associativeArray[key + 1]}"
```



As you can see, both `$index` and `index` work fine with indexed arrays. They both evaluate to `0`. You can even do math on it to increase it to `1` and get the second value. No go with associative arrays, though. Here, we need to use `$key`; the others fail.

