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

- The (Church-Turing thesis)[https://en.wikipedia.org/wiki/Church%E2%80%93Turing_thesis]:

  - The lambda calculus is as powerful as Turing machines.

  - In other words, these are equivalent models of computation, i.e., of
    defining *algorithms*.

  - Turing and Churcil indepedently proved, in 1936, that:
    - program termination is undecidable (with Turing machines)
    - program equivalence is undecidable (with lambda calculus)

  - Thus both showed that the
    (*Entscheidungsproblem*)[https://en.wikipedia.org/wiki/Entscheidungsproblem],
    to David Hilbert's dismay, has a negative anwser:
    - There are undecidable problems. There are problems which we *cannot*
    solve, for every instance of the problem, with algorithms.

#### Notation

```
<expr> ::= <name>
         | \lambda <name> . <expr>
         | <expr> <expr>
```

A λ-expression is either a:
- variable
  - `x`
- λ-abstraction
  - `λ x . xx`
- application
  - `(λ x . xx) z`




#### Lambda reductions

##### Alpha

##### Beta

##### Eta

##### Reduction strategies


O Cálculo Lambda é uma notação para descrever computações tão poderosa quanto o máquina de Turing.
Variáveis livres.
Funções Currificadas.
Reduções Lambda:
Reduções alfa.
Reduções beta.
Reduções eta.
Existem diferentes estratégias de redução.
