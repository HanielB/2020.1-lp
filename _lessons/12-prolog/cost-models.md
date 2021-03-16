---
layout: page
title: Cost Models
---

# Cost Models
{: .no_toc .mb-2 }

- TOC
{:toc}

## Readings

- [Chamada de cauda](http://en.wikipedia.org/wiki/Tail_call)
- [Array programming](http://www.vector.org.uk/archive/v223/smill222.htm)
- [Recursão de cauda](http://en.wikipedia.org/wiki/Tail_recursion)
- Cost Models chapter from [Introduction to Programming Languages](https://en.wikibooks.org/wiki/Introduction_to_Programming_Languages).

## Important concepts

- A cost model describes the complexity of operations provided by a programming
  language in terms time and space of execution.

- In Prolog and ML, reading the first element of a list is `O(1)` (i.e.,
  constant time). On the other hand, reverting a list or concatenating two lists
  is `O(n)` (i.e., linear time), in which `n` is the size of the list.

- Tail recursion is an optimization applied in recursive calls, in which the
  tail call is the last operation made in the body of a function.

- Arrays are stored in sequences of lines, or sequences of columns, or like
  vectors of vectors. The sequential access of data is always preferable.

- Searches in Prolog have exponential behavior. Sometimes reordering clauses can
  significantly improve the program.
