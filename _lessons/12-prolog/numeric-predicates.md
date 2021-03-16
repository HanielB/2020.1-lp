---
layout: page
title: Numeric predicates
---

# Numeric predicates
{: .no_toc .mb-2 }

- TOC
{:toc}

## Readings

- [99 Problems in Prolog](https://prof.ti.bfh.ch/hew1/informatik3/prolog/p-99/).
- Math in Prolog chapter from [Introduction to Programming
  Languages](https://en.wikibooks.org/wiki/Introduction_to_Programming_Languages).

## Summary

- Prolog has several equality tests, for example:
  - **is** a clause `X is Y` evaluates `Y` and unifies the result with `X`. The
    clause `3 is 1+2` is valid, but the clause `1+2 is 3` is not. The clause `X
    is 1+Y` yields an exception if the variable `Y` is not associated no any
    value.
  - **=** the clause `X = Y` unifies `X` and `Y`. The unification does not
    trigger the evaluation of numerical values. Therefore `3 = 1+2` is not
    valid. Neither is `1+2 = 3`.
  - **=:=** The clause `X =:= Y` evaluates both `X` and `Y` and succeeds if both
    these terms have the same falue. So both `3 =:= 1+2` and `1+2 =:= 3` are
    valid.

- Prolog is a dynamically typed language.

- Prolog is a good language to formulate solutions for NP-complete problems via
  encodings into first-order logic.
  - A good example is the clause `findall`.
