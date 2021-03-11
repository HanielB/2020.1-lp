---
layout: page
title: Unification and Resolution
---

# Unification and Resolution
{: .no_toc .mb-2 }

- TOC
{:toc}

## Readings

- [Tutorial sobre unificação em Prolog](http://www.amzi.com/AdventureInProlog/a10unif.php) (faça os exercícios)
- [Unification in first-order logic](https://en.wikipedia.org/wiki/Unification_(computer_science)#Syntactic_unification_of_first-order_terms)
- [Occurs check](https://en.wikipedia.org/wiki/Occurs_check)

## What is unification?

The concept of unification comes from first-order logic: given two terms `s` and
`t`, to *unify* them means to find a *substitution* `σ` over their free
variables such that `sσ = tσ`. A substitution unifying two terms is called a
*unifier* for them.

Some examples of unification queries in Prolog terms:

``` prolog
?- a = b.
?- f(X, b) = f(a, Y).
?- f(X, b) = g(X, b).
?- a(X, X, b) = a(b, X, X).
?- a(X, X, b) = a(c, X, X).
?- a(X, f) = a(X, f).
```

For each one, if there is a substitution for the varibales of terms that makes
them equal, we have that substitution as a result, otherwise we have `false`.
For example, in the first query the terms `a` and `b` have no variables. Since
they are not equal, it's impossible to unify them and the result is `false`.

## Most general unifier

There may exist many unifiers for a given unification problem. An important
concept is that of the *most general unifier* (mgu). Given two terms `s` and
`t`, their most general unifier `σ` is a unifier such that if there exists
another unifier `θ` for these terms then `θ=σρ`, for some substitution `ρ`. This is to say: `θ` is a specialization of `σ`

Consider the unification problem

``` prolog
?- parent(X, Y) = parent(kim, Y).
```

and assume it has these two solutions: `{X = kim}` and `{X = kim, Y = holly}` in
the current context. The most general unifier is the first substiution, since
every other unifier (like the second substitution here) necessarily will be also
instantiating `Y` and is thus a specialization of the mgu, which only
instantiates `X`.

## Occurs check

An important aspect of any unification algorithm (i.e., an algorithm to solve
unification problems) is to avoid a cyclic behavior: it's not possible to unify
a variable with a term that contains that variable. The test to avoid this issue
is called the `occurs check`, as one checks whether the variable occurs in the
term to which it's trying to be unified.

In Prolog however this test is ommitted (not in all interpreters, though) for
reasons of ecciciency: checking whether a variable occurs in a term has
complexity linear in the size of the term. So for example:

``` prolog
?- f(X) = f(f(X)).
```

can yield `X = f(X)`. One can avoid this wrong behavior using the binary
predicate `unify_with_occurs_check`, which performs the correct (but more
expensive) unification algorithm. So for example:

``` prolog
?- unify_with_occurs_check(f(X), f(f(X))).
```

yields `false`.

## Resolution
