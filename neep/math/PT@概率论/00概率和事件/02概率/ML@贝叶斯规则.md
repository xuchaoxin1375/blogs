[toc]

- 我们经常会需要在已知 P (y | x) 时计算 P (x | y)。
  - 如果还知道 P (x)，我们可以用 贝叶斯规则（Bayes’ rule）来实现这一目的：
  - $P (x| y) = \frac{P (x)P (y | x)}{P(y)}$

-  $P (y)$ 出现在上面的公式中，它通常使用 $P (y) = \sum_x P (y | x)P (x)$ 来计算,所以我们并不需要事先知道 P (y) 的信息。

  - $$
    P(B_i|A)=\frac{P(B_iA)}{P(A)}
    =\frac{P(B_i|A)P(A)}{\sum\limits_{i\in I}P(A|B_i)P(B_i)}
    =\frac{MP(B_i|A)}{TP(B_i|A)}
    $$

    