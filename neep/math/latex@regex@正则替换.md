[toc]

- $sinx,cosx,sin(nx)\to{\sin{x},\cos{x},\sin(nx)}$
  - `([^\\])(sin|cos)((\(.*?\))|(\w|\d|\d\w)(,))`
  - `$1\\$2{$4$5}$6`