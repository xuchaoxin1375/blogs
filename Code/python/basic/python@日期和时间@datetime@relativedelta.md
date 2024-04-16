[toc]

## python datetime

- [datetime — Basic date and time types — Python 3.11.2 documentation](https://docs.python.org/3/library/datetime.html)

## relativedelta

- [relativedelta — dateutil 2.8.2 documentation](https://dateutil.readthedocs.io/en/stable/relativedelta.html)

  - 这种类型（type）是基于M.-A. Lemburg在他的mx.DateTime扩展中所做工作的规范。然而，需要注意的是，它并不实现与他的工作相同的算法。不要期望它的行为与mx.DateTime的对应物相同。简而言之，虽然两者有共同点，但是它们的具体实现可能会有所不同，因此不能完全等同对待。

  - There are two different ways to build a relativedelta instance. The first one is passing it two date/datetime classes:

    ```
    relativedelta(datetime1, datetime2)
    ```

    The second one is passing it any number of the following `keyword arguments`:

    ```bash
    relativedelta(arg1=x,arg2=y,arg3=z...)
    
    year, month, day, hour, minute, second, microsecond:
        Absolute information (argument is singular); adding or subtracting a
        relativedelta with absolute information does not perform an arithmetic
        operation, but rather REPLACES the corresponding value in the
        original datetime with the value(s) in relativedelta.
    
    years, months, weeks, days, hours, minutes, seconds, microseconds:
        Relative information, may be negative (argument is plural); adding
        or subtracting a relativedelta with relative information performs
        the corresponding arithmetic operation on the original datetime value
        with the information in the relativedelta.
    
    
    ```

  - ```
    weekday: 
        One of the weekday instances (MO, TU, etc) available in the
        relativedelta module. These instances may receive a parameter N,
        specifying the Nth weekday, which could be positive or negative
        (like MO(+1) or MO(-2)). Not specifying it is the same as specifying
        +1. You can also use an integer, where 0=MO. This argument is always
        relative e.g. if the calculated date is already Monday, using MO(1)
        or MO(-1) won't change the day. To effectively make it absolute, use
        it in combination with the day argument (e.g. day=1, MO(1) for first
        Monday of the month).
    
    leapdays:
        Will add given days to the date found, if year is a leap
        year, and the date found is post 28 of february.
    
    yearday, nlyearday:
        Set the yearday or the non-leap year day (jump leap days).
        These are converted to day/month/leapdays information.
    ```

### demo

- 

  ```python
  from datetime import date
  from dateutil.relativedelta import relativedelta
  
  d = date(2023, 3, 20)
  # 下周2
  rd0=relativedelta(weekday=TU)
  # weekday 配合 day参数,指定本月的第几个周2
  rd1 = relativedelta(weekday=TU, day=1)
  # 指定本月的第2个周2
  rd2=relativedelta(weekday=TU(2), day=1)
  # days参数和weekday参数同时设置时,产生叠加效果
  #叠加过大,可能会跑到下个月或更大的月份
  rd3=relativedelta(weekday=TU,days=2)
  rd4=relativedelta(weekday=TU(2),days=1)
  rd5=relativedelta(weekday=TU(3),days=1)
  # 效果和rd1一样,当weekday和day同时设置,取决于TU()
  rd6=relativedelta(weekday=TU(1),day=2)
  rd7=relativedelta(weekday=TU(1),weeks=1)
  d0=d+rd0
  d1=d+rd1
  d2=d+rd2
  d3=d+rd3
  d4=d+rd4
  d5=d+rd5
  d6=d+rd6
  d7=d+rd7
  print(f'{d0=}',d0.strftime('%A'))
  print(f'{d1=}',d1.strftime('%A'))  
  print(f'{d2=}')
  print(f'{d3=}')
  print(f'{d4=}')
  print(f'{d5=}')
  print(f'{d6=}')
  print(f'{d7=}')
  ```

- ```
  d0=datetime.date(2023, 3, 21) Tuesday
  d1=datetime.date(2023, 3, 7) Tuesday
  d2=datetime.date(2023, 3, 14)
  d3=datetime.date(2023, 3, 28)
  d4=datetime.date(2023, 3, 28)
  d5=datetime.date(2023, 4, 4)
  d6=datetime.date(2023, 3, 7)
  d7=datetime.date(2023, 3, 28)
  ```

  

- [matplotlib.dates — Matplotlib 3.7.1 documentation](https://matplotlib.org/stable/api/dates_api.html#matplotlib.dates.relativedelta)



## `timedelta`和`relativedelta`

- `timedelta`和`relativedelta`都是Python标准库`datetime`模块中用于处理日期和时间差异的类，它们的作用略有不同：

  1. `timedelta`用于表示一个时间段（时分秒毫秒），可以把它加到某个日期或时间上，得到另一个日期或时间。例如：

     ```python
     from datetime import datetime, timedelta
     
     dt = datetime(2023, 3, 20, 12, 0, 0)
     td = timedelta(days=7)
     
     new_dt = dt + td
     print(new_dt)   # 2023-03-27 12:00:00
     ```

     上面的代码中，我们创建了一个`datetime`对象，表示2023年3月20日12点整。然后，我们创建了一个`timedelta`对象，表示7天时间差异。最后，通过将时间差异加到原来的日期上，得到了新的日期：2023年3月27日12点。

  2. `relativedelta`用于表示日期之间的差异，并且可以处理更复杂的调整规则，例如“下个月的最后一天”、“下一个星期五”等。例如：

     ```python
     from datetime import date
     from dateutil.relativedelta import relativedelta
     
     d = date(2023, 3, 20)
     rd = relativedelta(d, months=1, day=31)
     
     new_d = d + rd
     print(new_d)   # 2023-04-30
     ```

     - 上面的代码中，我们创建了一个`date`对象，表示2023年3月20日。
     - 然后，我们创建了一个`relativedelta`对象，表示将日期调整到下个月的最后一天。
     - 最后，通过将日期调整应用到原来的日期上，得到了新的日期：2023年4月30日。

  因此，`timedelta`和`relativedelta`都是非常有用的类，可用于在Python中执行日期和时间计算。但是，它们的使用场景略有不同，需要根据具体情况进行选择。



### 获取星期几@strftime

- [strftime-and-strptime-format-codes|datetime — Basic date and time types — Python 3.11.2 documentation](https://docs.python.org/3/library/datetime.html#strftime-and-strptime-format-codes)

- ```python
  from datetime import datetime
  
  today = datetime.now().strftime('%A')
  print("今天是周几：", today)
  print("当前时间：", now)
  ```

  

## 日期范围

- numpy日期

  ```python
  xdates = np.arange(np.datetime64('2021-11-15'), np.datetime64('2021-12-25'),
                     np.timedelta64(1, 'h'))
  ```

  

- pandas日期返回

  ```python
  dates = pd.date_range("20130101", periods=6)
  ```

## pandas 日期

- [pandas.date_range — pandas 1.5.3 documentation (pydata.org)](https://pandas.pydata.org/docs/reference/api/pandas.date_range.html#pandas.date_range)
  - 返回一个固定频率的DatetimeIndex。 
  - 该函数返回一组等间隔的时间点，这些时间点之间的差距由给定的频率`freq`指定，使得它们都满足 start <= x <= end 的条件，其中第一个和最后一个时间点分别是该范围内落在 freq 边界上的第一个和最后一个时间点（如果 freq 以频率字符串的形式给出），或者是对于 freq 有效的第一个和最后一个时间点（如果 freq 给出为 pandas.tseries.offsets.DateOffset）。 
  - （如果 start、end 或 freq 中恰好有一个未指定，则可以通过 periods 计算出该缺失参数，periods 是该范围内时间步数的数量。）

### 日期偏移

- [pandas.tseries.offsets.DateOffset — pandas 1.5.3 documentation (pydata.org)](https://pandas.pydata.org/docs/reference/api/pandas.tseries.offsets.DateOffset.html)

- ```python
  from pandas.tseries.offsets import DateOffset
  d3=pd.date_range(start='1/10/2018', periods=5, freq='5d')
  # d4=pd.date_range(start='1/10/2018', periods=5, freq=pd.offsets)
  # 创建一个以'2022-01-01'为基准，每隔5天生成的日期范围
  # offset = pd.DateOffset(days=5)
  offset=DateOffset(days=5)
  d4 = pd.date_range(start='2022-01-10', end='2022-01-31', freq=offset)
  offset_M=DateOffset(months=1)
  d5=pd.date_range(start='2022-01-10',periods=5, freq=offset_M)
  print(d3,d4,d5)
  
  ```

  - ```
    (DatetimeIndex(['2018-01-10', '2018-01-15', '2018-01-20', '2018-01-25',
                    '2018-01-30'],
                   dtype='datetime64[ns]', freq='5D'),
     DatetimeIndex(['2022-01-10', '2022-01-15', '2022-01-20', '2022-01-25',
                    '2022-01-30'],
                   dtype='datetime64[ns]', freq='<DateOffset: days=5>'),
     DatetimeIndex(['2022-01-10', '2022-02-10', '2022-03-10', '2022-04-10',
                    '2022-05-10'],
                   dtype='datetime64[ns]', freq='<DateOffset: months=1>'))
    ```

