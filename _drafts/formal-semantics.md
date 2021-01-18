---
layout: page
title: Formal semantics
---

# Formal semantics
{: .no_toc .mb-2 }

{:toc}

## Readings

- (Operational semantics)[http://www.cs.uiowa.edu/~slonnegr/plf/Book/Chapter8.pdf], Sections Seções 8.5 (you can ignore "completeness and consistency") and 8.6.
- [Introduction to Programming Languages](https://en.wikibooks.org/wiki/Introduction_to_Programming_Languages), entry on semantics.

- [The lambda calculus](http://www.cs.uiowa.edu/~slonnegr/plf/Book/Chapter5.pdf), Sections 5.1, 5.2 (pag. 139 to 159).

### Recommended readings

- [Semantics with applications: an appetizer](https://www.springer.com/gp/book/9781846286919), Chapters 1 and 2.
- [A bit on the history of computing](http://www.people.cs.uchicago.edu/~soare/History/turing.pdf), Chapters 1-3.

## Class notes

### Overview

- *Syntax* defines what the programs we write look like, while *semantics*
  defines their meaning.

- The semantics of a language `L1` can be defined via a interpreted for `L1` in
  another language `L2` with a well-defined semantics.

  - Note this is the approach we've taken with our [expression language](), using
    SML as the interpreter language.

  - However, how do we define the semantics of `L2`?

- There are formal notations to define the semantics of programming languages. For example:
  - Operational semantics
  - Axiomatic semantics
  - Denotational semantics

- Operational semantics specifies, step by step, what happens while a program is executed.

### Notations

**TODO** update for expression language

- Judements for writing inference rules:
  - Premises are written above the line.
  - Conclusion below the line.
  - Label by the lines denote the rule name
  - Arrows represent how expressions are evaluated.

```
 E1 -> v1      E2 -> v2              E1 -> v1      E2 -> v2
------------------------ EvPlus     -------------------------- EvMinus
Plus(E1, E2) -> v1 + v2             Minus(E1, E2) -> v1 - v2

------------- EvIConst
IConst n -> n
```

The above establishes how expressions built with `IConst`, `Plus` and `Minus`
are evaluated, i.e., in terms of the semantics of `+`, `-`.

#### Big step and small step semantics

- The above is often called "big step semantics", as opposed to "small step
semantics":
  - only one computation at a time

```
 E1 -> v1      E2 -> v2              E1 -> v1      E2 -> v2
------------------------ EvPlus     -------------------------- EvMinus
Plus(E1, E2) -> v1 + v2             Minus(E1, E2) -> v1 - v2

------------- EvIConst
IConst n -> n
```

#### How to define the semantics of ITE?

```

E1 -> true       E2 -> v2            E1 -> false      E3 -> v3
-------------------------     or     -------------------------
  if(E1, E2, E3) -> v2                 if(E1, E2, E3) -> v3
```

#### How to add variables?

```
(E1, C) -> v1    (E2, C) -> v2             (E1, C) -> v1     (E2, C) -> v2
------------------------------             -------------------------------
 (plus(E1, E2), C) -> v1 + v2               (times(E1, E2), C) -> v1 * v2


(var(v), C) -> lookup(C, v)                (const(n), C) -> eval(n)


(E1, C) -> v1    (E2, [bind(x, v1)|C]) -> v2
--------------------------------------------
        (let(x, E1, E2), C) -> v2
```

### Static vs dynamic semantics

- Static semantics: program meaning known at compilation time.
- Dynamic semantics: program meaning known at run time.

### Program equivalence

* Semantic equivalence
17) What does it mean to say that two programs P1 and P2 are equivalent?
<P1, B> -> <v, B'> iff <P2, B> -> <v, B'>
- or -
<P1, B> -> stuck iff <P2, B> -> stuck

18) Prove that
if be then c1 else c2 == if not(be) then c2 else c1

The proof is by induction on the rules used to evaluate the expression.

18.1) What are these rules?

```
be -> true     c1 -> v                      be -> true
---------------------- IfTrue           ----------------- NotTrue
 if(be, c1, c2) -> v                     not(be) -> false

be -> false     c2 -> v                      be -> false
---------------------- IfFalse           ----------------- NotFalse
 if(be, c1, c2) -> v                      not(be) -> true
```

Case 1)

```
be -> true       c1 -> v
------------------------
  if(be, c1, c2) -> v
```

What do we know? We know that (i) "be -> true" and (ii) "c1 -> v"
From (i) and rule NotTrue we know that "not(be) -> false", thus:

```
not(be) -> false       (ii) c1 -> v
-----------------------------------
    if(not(be), c2, c1) -> v
```

Case 2)

```
be -> false      c2 -> v
------------------------
  if(be, c1, c2) -> v
```

What we know? We know that (i) "be -> false" and (ii) "c2 -> v"
From (i) plus NotFalse we know that "not(be) -> true", thus:

```
not(be) -> true     (ii) c2 -> v
--------------------------------
   if(not(be), c2, c1) -> v
```

### The Lambda Calculus

- The lambda calculus is a notation to describe computations

  - It thus offers a precise formal semantics for programming languages.

- The [Church-Turing thesis](https://en.wikipedia.org/wiki/Church%E2%80%93Turing_thesis):

  - The lambda calculus is as powerful as Turing machines.

  - In other words, these are equivalent models of computation, i.e., of
    defining *algorithms*.

  - Turing and Churcil indepedently proved, in 1936, that:
    - program termination is undecidable (with Turing machines)
    - program equivalence is undecidable (with lambda calculus)

  - Thus both showed that the
    [*Entscheidungsproblem*](https://en.wikipedia.org/wiki/Entscheidungsproblem),
    to David Hilbert's dismay, is unsolvable.
    - There are undecidable problems. There are problems which we *cannot*
    solve, for every instance of the problem, with algorithms.

  - Both built on Kurt Gödel's [incompleteness
    theorems](https://en.wikipedia.org/wiki/G%C3%B6del%27s_incompleteness_theorems),
    which first showed the limits of mathematical logic.

#### Notation

The lambda calculus consists of writing λ-expressions and reducing
them. Intuitively it is a notation for writing functions and their application.

A λ-expression is either:
- a variable
```
x
```

- an abstraction ("a function")

```
λ x . x
```

in which the variable after the lambda is called its *bound variable* and the
expression after the dot its *body*.

- an application ("of a function to an argument")
```
(λ x . x) z
```

in which the right term is the argument of the application.

This means that λ-expressions follow the syntax:

```
<expr> ::= <name>
         | (\lambda <name> . <expr>)
         | (<expr> <expr>)
```

Expressions can be manipulated via reductions. Intuitively they correspond to
computing with functions.

#### Beta (β-reduction)

- Captures the idea of function application.
- It is defined via substitution:
  - an application is β-reduced via the replacement, in the body of the
  abstraction, of all occurrences of the bound variable by the argument of the
  application.

- Consider the example application above:

```
(λ x . x) z
=>_β
z
```

Intuitively `(λ x . x)` corresponds to the *identity function*: whatever
expression it is applied to will be the result of the application.

#### Alpha (α-conversion)

- Renames bound variables.

```
(λ x . x)
=>_α
(λ y . y)
```

- Expressions that are only different in the names of their bound variables are
  called *α-equivalent*.
  - Intuitevely, the names of the bound variables do not change the meaning of the function.
  - Both `(λ x . x)` and `(λ y . y)` correspond to the identity function.

#### Free and bound variables

- Not all renaming is legal.
```
(λ x . (λ y . y x))
=>_α
(λ y . (λ y . y y))
```
- This renaming changes what the function computes, as `x` was renamed to a
  variable, `y`, that was *not free* in the body of the expression.
  - As example, consider the following SML code:

  ``` ocaml
  val y = 1
  fun f1 x = y + x
  fun f2 z = y + z
  fun f3 y = y + y
  ```
  You will note that `f1` and `f2` are equivalent, while `f1` and `f3` are not.


- Free variables are those that are *not* bound by any lambda abstraction enclosing it.
  ```
  (λ w . z w)
  ```
   - In the body of the expression `w` is bound while `z` is free.

- To avoid this issue, α-conversion must be applied with *capture-avoiding*
  substitutions:
  - When recursively traversing the expression to apply the subsitution, if the
    range of the substitution contains a variable that is bound in an
    abstraction, rename the bound variable so that the free variable is not
    *captured*.
  - In the above example, to do a substitution of `x:=y` on `(λ x . (λ y . y x))`, written

  ```
  (λ x . (λ y . y x))[x:=y]
  ```

  we will do `(λ y . y x)[x:=y]`. Since `y` is bound in the expression in which
  we are doing the substitution, we rename the bound variable to avoid capture:


   ```
   (λ y . y x) =>_α (λ z . z x)
   ```

   Now we can do `(λ z . z x)[x:= y]` so that the variable `x`, which was is
   free in this expression, does not become bound by it. Thus we obtain:
   ```
   (λ x . (λ y . y x))
   =>_α
   (λ y . (λ z . z y))
   ```
   which are equivalent functions.

<!-- #### Eta (η-reduction) -->

<!-- - Captures the idea of *extensionality*: functions are equal if and only if they -->
<!--   always produce the same result on all arguments. -->

<!-- - The intuition is that an abstraction can be lifted when its application -->
<!--   corresponds to the application of the expression within it -->

<!-- ``` -->
<!-- (λ x . f x) -->
<!-- =>_η -->
<!-- f -->
<!-- ``` -->
<!-- if `f` does not contain `x` free. -->
