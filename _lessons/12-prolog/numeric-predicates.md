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

## Using numerical predicates

How would we define a predicate in Prolog to determine the length of a list?

``` prolog
myLength([], 0).
myLength([_|Tail], Len) :- myLength(Tail, TailLen), Len = TailLen + 1.
```

The predicate `myLength` successively decomposes a list and, at each step,
"increments" its length. So for example

``` prolog
?- myLength([1], 0).
false.
?- myLength([1], 1).
true.
```

But how does this actually work, since we know that all computation in Prolog is
done via unification? For the query `myLength([1], 1).` to hold its negation
must resolve with the clausal form of the `myLength` rule:

``` prolog
myLength([_|Tail], Len) v ~myLength(Tail, TailLen) v ~(Len = TailLen + 1)
```

which has an unifier `{Tail = [], Len = 1}`. Thus we obtain the clause

``` prolog
~myLength([], TailLen) v ~(1 = TailLen + 1)
```

We can now resolve this clause with the fact `myLength([], 0)` via the unifier `{TailLen = 0}`. Thus we obtain the clause

``` prolog
~(1 = 0 + 1)
```

There are no other resolutions we apply, but nevertheless Prolog built a
refutation for the negation of the query `myLength([1], 1)`. How so? By unifying
`1` and `0 + 1`, which allows deriving `~(true)`, then `false`, thus fininshing
the refutation.

Prolog is capable of performing *unification modulo arithmetic*, i.e., it can
apply arithmetic reasoning during unification and unify terms that are not
syntactically equal if they can be evaluated to equal terms.

### The `is` predicate

This predicate allows us to do explicity do unification modulo arithmetic.

``` prolog
?- X = 1, Y is X + 2.
X = 1,
Y = 3.
```

The `is` predicate works by evaluating the arithmetic expression into a
number. Above when the interpreter reason on `Y is X + 2` the variable `X` has
been instantiated to `1`, so `X+2` became `1+2`, which is evaluated to `3` and
`Y` is instantiated to it.

When the arithmetic expression cannot be evaluated into a number the interpreter
will rase an exception, for example

``` prolog
?- Y is X + 2, X = 1.
```

will lead to such an error. Another limitation of `is` is that it is not
commutative. For example, `2 is 1+1` holds but `1+1 is 2` does not. Only the
second argument is evaluated when doing the unification.

In building arithmetic expressions to be evaluated, one can use the following
binary predicates `+, -, *, /, <, >, =<, >=, =:=, =\=` and unary predicates:
`abs(Z), sqrt(Z), -`.

So we can for example do the following queries

``` prolog
?- X is 1/2.
?- X is 1.0/2.0.
?- X is 2/1.
?- X is 2.0/1.0.
?- 2 < 3.
?- 1+1 = 2.
?- 1+1 =:= 2.
```

Note that the fact that `is` only evaluates its second argument is very
important for writing Prolog rules. For example, if we write

``` prolog
myLength([], 0).
myLength([_|T], N) :- myLength(T, N1), N =:= N1 + 1.
```

we force both `N` and `N1 + 1` in the last term of the rule to be evaluated. We could still use this definition in a query

``` prolog
?- myLength([1], 1).
```

but what about

``` prolog
?- myLength([1], N).
```

## Examples

Unification modulo arithmetic allows us easily write Prolog programs for doing
some mathematics.

### Summing the elements of a list

``` prolog
sum([],0).
sum([Head|Tail],X) :- sum(Tail,TailSum), X is Head + TailSum.
```

### Factorial

``` prolog
fact(0, 1).
fact(1, 1).
fact(N, F) :- N > 1, N1 is N - 1, fact(N1, F1), F is F1 * N.
```

Prolog also has predicates to check whether a term has a predefined meaning. For
example, `integer` checks whether a term is an integer number, while `number`
whether a term is an integer or real number. For example we could rewrite the above definition to automatically fail on computations requested on non-integers:

``` prolog
fact(0, 1).
fact(1, 1).
fact(N, F) :- integer(N), N > 1, N1 is N - 1, fact(N1, F1), F is F1 * N.
```

### Greatest common divisor

``` prolog
gcd(X, Y, Z) :- X =:= Y, Z is X.
gcd(X, Y, Denom) :- X > Y, NewY is X - Y, gcd(Y, NewY, Denom).
gcd(X, Y, Denom) :- X < Y, gcd(Y, X, Denom).
```

## The `findall` predicate

How would we compute all the subsets of a set (represented as a list)?

``` prolog
subSet([], []).
subSet([H|T], [H|R]) :- subSet(T, R).
subSet([_|T], R) :- subSet(T, R).
```

### All the permutations of a list9

``` prolog
perm([], []).
perm(List, [H|Perm]) :- select(H, List, Rest), perm(Rest, Perm).
```

## The eight-queens problem


## Sudoku

How would you solve [sudoku](https://en.wikipedia.org/wiki/Sudoku) in Prolog? A
solution is available
[here](https://www.swi-prolog.org/pldoc/man?section=clpfd-sudoku).
