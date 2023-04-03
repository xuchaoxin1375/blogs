[toc]

## refs

- [关于函数 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3#piping-objects-to-functions)

### 本地文档

- ```powershell
  PS D:\repos\blogs> help *pipeline*
  
  Name                              Category  Module                    Synopsis
  ----                              --------  ------                    --------
  about_Pipelines                   HelpFile
  about_Pipeline_Chain_Operators    HelpFile
  ```

- `help about_Pipeline_Chain_Operators`

## Why Pipeline-Support Matters

Let’s quickly look _why_ Pipeline-Support is so useful, and why your own functions should support it.

Most built-in commands support the pipeline, so users can effortlessly create simple but powerful one-liners like this one:

```powershell
# get the top 5 sources for errors of past 90 days in the system eventlog:
Get-WinEvent -FilterHashtable @{LogName="System";Level=1,2;StartTime=(Get-Date).AddDays(-90)} |
 Group-Object -Property ProviderName | 
Sort-Object -Property Count -Descending | 
Select-Object -First 5 -Property Count, Name
```

### Re-Usable Code

Each command in this line is a specialist for a given task, and thanks to the pipeline, you can refine raw results until you get what you need:

* `Get-WinEvent`: **reads** events from _any_ of the windows event logs.
  * In the example, the _system_ event log is searched for events of level _Critical_ and _Error_ (values 1 and 2) from the past 90 days.
* `Group-Object`: **groups** objects based on values in one or more properties.
  * Essentially, `Group-Object` shows the _distribution_ of objects.
  * In the example, events with the same _ProviderName_ are grouped.
* `Sort-Object`: **sorts** objects based on one or more properties.
  * In the example, the resulting groups are sorted by _Count_ in _descending_ order, placing the largest groups on top.
* `Select-Object`: **selects** the _first_ or _last_ number of objects, and can select the properties you are interested in.
  * In the example, it picks the first 5 objects (resembling the five largest groups), and shows the group _Count_ and _Name_.

> * When you want to evaluate event logs, `Get-WinEvent` is much more powerful than the older `Get-EventLog`. While `Get-WinEvent` can read _any_ of the hundreds of windows and application logs, `Get-EventLog` is limited to the few default windows logs.
> * Both commands support accessing remote systems via **\-ComputerName**.
> * Filtering events is a little more complex with `Get-WinEvent`: you submit a hashtable to **\-FilterHashtable** and `specify the properties you are after`.
> * Some values like _Level_ are `code numbers`. Here is a way to identify the code numbers:
>
> ```plaintext
> # get level id numbers for existing levels:
> Get-WinEvent -FilterHashtable @{LogName=”System"} | Group-Object -Property LevelDisplayName | Foreach-Object { $_.Group | Select-Object -First 1 -Property Level, LevelDisplayName }
> ```
>
> The command can take some time to execute: it examines all events in the _System_ event log and groups them by _LevelDisplayName_. Then, for each group, the first element is taken, and the line outputs the clear-text _LevelDisplayName_ and the corresponding code number:
>
> ```plaintext
> Level LevelDisplayName
> ----- ----------------
>     4 Information
>     3 Warning
>     2 Error
>     1 Critical
> ```
>
> For more information, visit the [**online documentation**](https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Diagnostics/Get-WinEvent?view=powershell-7&viewFallbackFrom=powershell-3.0).

## Processing Pipeline Input In Real-Time

* The most simplistic approach is to use a _Simple Function_:
* the incoming pipeline elements surface in `$_` within `the _process_ block`.
  * Use the keyword **filter** to create `a function` with ` a default _process_ block`:

```plaintext
filter Test-PipelineInput
{
	Write-Warning "receiving $_"
    # for example, create IP addresses:
    "10.12.100.$_"
}

1..10 | Test-PipelineInput
```

* If you don’t like the uncommon keyword **filter**, you can use **function** and define the _process_ block manually:

```plaintext
function Test-PipelineInput
{
	process
	{
        Write-Warning "receiving $_"
        # for example, create IP addresses:
        "10.12.100.$_"
    }
}

1..10 | Test-PipelineInput
```

> This approach works in _Simple Functions_ only. Once you start adding attributes to your code, you create _Advanced Functions_ that explicitly define pipeline-aware parameters (see below).

### **Supporting** _****Begin****_ **And** _**End**_

* If you want to add code that runs _once_ before `the pipeline executes` and runs _once_ after ` the pipeline finishes`,
* use the keyword **function**, and define the blocks _begin_, _process_, and _end_ manually:

> * Once you define these blocks manually, all scriptblock code must be assigned to any of these blocks,
> * and no code may exist outside of them.
> * If you don’t need one of these blocks you can safely remove it.

```plaintext
function Out-Voice
{
  # do initialization tasks
  begin
  {
    $sapi = New-Object -ComObject Sapi.SPVoice
  }
  
  # process pipeline input
  process
  {
    $null = $sapi.Speak($_)
  }

  # do cleanup tasks
  end
  {
    # nothing to do
  }
}

'Hello','This is a test' | Out-Voice
```

This way, you can also create very fast counters. `Count-Object`counts the number of objects, for example:

```plaintext
function Count-Object
{
	begin
	{
		$x = 0
	}
	process
	{
		$x++
	}
	end
	{
		$x
	}
}

Get-Service | Count-Object
```

> * This example leverages the _streaming_ nature of the pipeline:
>   * you get the total number of objects without the need to store the total number of objects in memory.
>   *  This approach works, too, but costs a lot more memory:
>
> ```plaintext
> (Get-Service).Count
> ```

* Likewise, `Get-FolderSize` reports the total size of files in a folder:

```plaintext
function Get-FolderSize
{
	begin
	{
		$x = 0
	}
	process
	{
		if ($_ -is [System.IO.FileInfo])
		{ $x += $_.Length }
	}
	end
	{
		$x
	}
}

# count the sum of all exe files in the windows folder:
Get-ChildItem -Path 'c:\windows' -Filter '*.exe' -File | Get-FolderSize

# get the total size of the windows folder (including hidden files)
Get-ChildItem -Path $env:windir -Recurse -File -Force -ErrorAction Ignore | Get-FolderSize
```

### **Using Named Parameters**

* If you’d like to _name_ your parameters and not use the generic variable `$_`,
  * use an _Advanced Function_: define the parameters using a **param()** structure,
  * and add **\[Parameter()\]** attributes to define which parameters get pipeline input:

```plaintext
function Out-Voice
{
  # define parameters
  param
  (
    [Parameter(Mandatory,ValueFromPipeline)]
    [string]
    $Text,
  
    [ValidateRange(-10,10)]
    [int]
    $Speed = 0
  )
  
  # do initialization tasks
  begin
  {
    $sapi = New-Object -ComObject Sapi.SPVoice
    $sapi.Rate = $Speed
  }
  
  # process pipeline input
  process
  {
    $null = $sapi.Speak($Text)
  }

  # do cleanup tasks
  end
  {
    # nothing to do
  }
}

'Hello','This is a test' | Out-Voice -Speed 6
```

> * When you use _Advanced Functions_, you may see a slight performance degradation compared to _Simple Functions_.
> *  Here is a [**discussion**](https://powershell.one/tricks/performance/pipeline#it-is-not-the-parameter-binder) about the cause, and some workarounds.

### Using Array Input

* When you accept pipeline data, your command automatically supports arrays because the pipeline always _unwraps_ array elements and processes each element individually.
* The _process_ block in your code acts like a loop.
* If you’d like to also accept array input when your command runs stand-alone, change the parameter type to an array type, and add your own loop to the _process_ block:

```plaintext
function Out-Voice
{
  param
  (
    [Parameter(Mandatory,ValueFromPipeline)]
    # allow string arrays:
    [string[]]
    $Text,
  
    [ValidateRange(-10,10)]
    [int]
    $Speed = 0
  )
  
  # do initialization tasks
  begin
  {
    $sapi = New-Object -ComObject Sapi.SPVoice
    $sapi.Rate = $Speed
  }
  
  # process pipeline input
  process
  {
    # unwrap arrays manually that were assigned to the
    # parameter directly:
    foreach($element in $Text)
    {
      $null = $sapi.Speak($element)
    }
  }
}

# accepts pipeline input:
'Hello','This is a test' | Out-Voice -Speed 6

# accepts same data via direct call as well:
 Out-Voice -Text 'Hello','This is a test' -Speed -5
```

### **Binding To Object **Properties

* Your pipeline-enabled parameter(s) can read information from incoming object properties, too. If you want to bind a parameter to object properties,
  * add **\[Parameter(ValueFromPipelineByPropertyName)\]** and make sure the property is called like the parameter name.
  * Else, add **\[Alias()\]** to define one or more alias names.
* Here is a revised `Out-Voice` that accepts text but also accepts objects with the properties _Text_,
  * _DisplayName_, and _Name_ (in this order). So you can now pipe objects to `Out-Voice` that have at least one of these properties:

```plaintext
function Out-Voice
{
  # define parameters
  param
  (
    [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
    # define property names
    [Alias('DisplayName','Name')]
    [string[]]
    $Text,
  
    [ValidateRange(-10,10)]
    [int]
    $Speed = 0
  )
  
  # do initialization tasks
  begin
  {
    $sapi = New-Object -ComObject Sapi.SPVoice
    $sapi.Rate = $Speed
  }
  
  # process pipeline input
  process
  {
    # unwrap arrays manually that were assigned to the
    # parameter directly:
    foreach($element in $Text)
    {
      $null = $sapi.Speak($element)
    }
  }
}

# accepts objects with properties Text, DisplayName, or Name:
Get-Process -Id $pid | Out-Voice -Speed -2
Get-Service | Select-Object -First 4 | Out-Voice
```

## Processing All Pipeline Input

* For some use cases, it may be necessary to first collect all incoming pipeline data and process it in one chunk.
*  Sorting would be one of these scenarios, but there are many more.

### Automatic Collection

* A very convenient built-in way of collecting all pipeline input is the automatic variable `$Input`. I
* t is available in _Simple Functions_ and surfaces in the _end_ block provided you _do not_ use a _process_ block:

```plaintext
function Test-CollectData
{
	# convert enumerator to array
	$all = @($Input)

	# work with collection of received data:
	$count = $all.Count
	"I received $count elements."
	"Received: $all"
}

1..10 | Test-CollectData

```

* `$Input` is an enumerator, not an array. Enclose it in `@()` to turn it `into a real array`.

> * If you work with `$Input` directly, you may encounter strange behavior: the variable can be read only _once_ and is empty afterwards.
> * That’s because it really is an _enumerator_, and if you’d like to read it again, you’d have to call its method **Reset()**.
>
> That’s why for most scenarios it is easier to use `@()` and turn the enumerator into a default array.

### Manual Collection

* The previously used automatic variable `$Input` is not available in _Advanced Functions_, so
* if you require any of the features of _Advanced Functions_, simply create your own collection:

```plaintext
function Test-CollectData
{
  param
  (
    [Parameter(Mandatory,ValueFromPipeline)]
    [Object]
    $InputData
  )
  
  begin
  {
    # initialize empty generic list
    $all = [System.Collections.Generic.List[Object]]::new()
  }
  
  process
  {
    # add incoming pipeline object to list:
    $all.Add($_)
  }
  
  end
  {
    # work with collection of received data:
    $count = $all.Count
    "I received $count elements."
    "Received: $all"
  }
}

1..10 | Test-CollectData
```

* One of the most efficient ways of collecting data is to use a generic list.
* In the example above, the code uses a generic list of type **\[Object\]** so it accepts any type of object.
*  You can use more specific types as well.

For example if your function accepts strings via the pipeline, use **\[string\]** both for your parameter and the generic list.

> * Never use a simple array and the operator **+=** to collect data.
> * This is slowing down your code tremendously because each time you add an element to a simple array, the entire array needs to be copied to a larger array.

## Wrap-Up

As part of the examples, you just created a pipeline-aware new command called `Out-Voice`. Let’s add it to the one-liner from the beginning to read the top worst sources from your system log to you:

```plaintext
# I am adding the new command definition for completeness:
function Out-Voice
{
  # define parameters
  param
  (
    [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
    # define property names
    [Alias('DisplayName','Name')]
    [string[]]
    $Text,
  
    [ValidateRange(-10,10)]
    [int]
    $Speed = 0
  )
  
  # do initialization tasks
  begin
  {
    $sapi = New-Object -ComObject Sapi.SPVoice
    $sapi.Rate = $Speed
  }
  
  # process pipeline input
  process
  {
    # unwrap arrays manually that were assigned to the
    # parameter directly:
    foreach($element in $Text)
    {
      $null = $sapi.Speak($element)
    }
  }
}

# get the top 5 sources for errors of past 90 days in the system eventlog:
Get-WinEvent -FilterHashtable @{LogName="System";Level=1,2;StartTime=(Get-Date).AddDays(-90)} | Group-Object -Property ProviderName | Sort-Object -Property Count -Descending | Select-Object -First 5 -Property Count, Name | Foreach-Object { '{0} caused {1} incidents' -f $_.Name, $_.Count} | Out-Voice
```

> * I would never insist that anything possible actually makes sense. And reading loud event log data may not be the best example, especially when your computer is not using the US locale. But you get the idea:
> * Once a command supports pipeline input, it automatically becomes compatible to a ton of other commands. Next time you want to read out a text file, try this:
>
> ```plaintext
> Get-Content -Path "c:\romeoAndJuliet.txt" | Out-Voice
> ```
