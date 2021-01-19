Control.Print.printDepth := 100;

(* How can we bind functional values? *)
fun f x = x + 1;
f 1;

(* This declaration corresponds to binding a to 5 and retrieving the
value 5, from the environment state, when a + 5 is evaluated. *)
val a = 5;
a + 5;

(* In this declaration we need to bind f to a value in the environment
that, when evaluated in f 1, is so that the parameter of f is
instantiated with 1 and the symbol defined in its declaring scope,
i.e., a, is mapped to its value at that moment. So when evaluating "f
1" we have as a result x + a{x-> 1, a -> 5} = 1 + 5 = 6. *)
fun f x = x + a;
f 1;

(* Changing the value of free symbol's from f's body does not change
its evaluation since the declaration environment is saved in f's
value. *)
val a = 3;
f 1;

(* A closure will be defined as a tuple

  (f, x, fBody, fDeclEnv)

 where

  f         -> name of the function
  x         -> argument of the function
  fBody     -> definition of the function
  fDeclEnv  -> definitions of the free variables in fBody in the scope
  in which f was declared.

 In the above example the value of f is:

  ("f", "x", "x + a", [("a", 5)])
*)

(* Generalizing the expression language for Booleans *)
datatype expr =
         IConst of int
         | BConst of bool
         | Prim2 of string * expr * expr
         | Prim1 of string * expr
         | Ite of expr * expr * expr
         | Var of string
         | Let of string * expr * expr
         (* Declaring functions
            (f, x, fBody, fDeclEnv)
         *)
         | LetFun of string * string * expr * expr
         (* For evaluating closure values *)
         | Call of expr * expr;

(* Defining the state, which will map to variables, functional or not, to values *)
type 'v env = (string * 'v) list;

(* Values will be integers or closures *)
datatype value =
         Int of int
         (* (f, x, fBody, (freeVars f) -> their values) *)
         | Closure of string * string * expr * value env;

exception EvalError;
exception PrimError;
exception FreeVar;

fun lookup [] id = raise FreeVar
  | lookup ((k:string, v)::t) id = if k = id then v else lookup t id;

fun intToBool 1 = true
  | intToBool 0 = false
  | intToBool _ = raise Match;

fun boolToInt true = 1
  | boolToInt false = 0;

fun eval (e:expr) (st: (string * value) list) : int =
    case e of
        (IConst i) => i
      | (BConst b) => boolToInt b
      | (Var v) =>
        let val vv = lookup st v in
            case vv of
                (Int i) => i
              | _ => raise EvalError
        end
      | (Prim2(f, e1, e2)) =>
        let
            val v1 = (eval e1 st);
            val v2 = (eval e2 st) in
        case f of
            ("+") => v1 + v2
          | ("-") => v1 - v2
          | ("*") => v1 * v2
          | ("/") => v1 div v2
          | ("=") => if v1 = v2 then 1 else 0
          | ("<") => if v1 < v2 then 1 else 0
          | ("and") => boolToInt ((intToBool v1) andalso (intToBool v2))
          | ("or") => boolToInt ((intToBool v1) orelse (intToBool v2))
          | _ => raise PrimError
        end
      | (Prim1("not", e1)) => boolToInt (not (intToBool (eval e1 st)))
      | (Ite(c, t, e)) => if (intToBool (eval c st)) then eval t st else eval e st
      | (Let(x, e1, e2)) => eval e2 ((x, Int (eval e1 st))::st)
      (* Declaring a function generates a closure with the current
      state saved as the declaration environment *)
      | (LetFun(f, x, e1, e2)) => eval e2 ((f, Closure(f, x, e1, st))::st)
      (* We force the language to be first-order by allowying only
      named functions to be called and only accepting non-functional
      arguments *)
      | (Call(Var f, e)) =>
        let val fv = (lookup st f) in
            case fv of
                (Closure(f, x, e1, fSt)) =>
                let
                    (* the function input is evaluated in the current state *)
                    val ev = Int(eval e st);
                    (* the function body is evaluated in the scope
                    saved in the closure. *)
                    val st' = (x, ev) :: (f, fv) :: fSt
                in
                    eval e1 st'
                end
             | _ => raise EvalError
        end
      | _ => raise Match;

(* Machinery for checking whether expressions are closed *)
fun isIn x s =
    case s of
        [] => false
      | (h::t) => if x = h then true else isIn x t;

fun union s1 s2 =
    case s1 of
        [] => s2
      | (h::t) => if isIn h s2 then union t s2 else union t (h::s2);

fun diff s1 s2 =
    case s1 of
        [] => []
      | (h::t) => if isIn h s2 then diff t s2 else h::(diff t s2);

fun freeVars e : string list =
    case e of
        IConst _ => []
      | BConst _ =>  []
      | (Var v) => [v]
      | (Prim2(_, e1, e2)) => union (freeVars e1) (freeVars e2)
      | (Prim1(_, e1)) => freeVars e1
      | (Ite(c, t, e)) => union (union (freeVars c) (freeVars t)) (freeVars e)
      | (Let(v, e1, e2)) =>
        let val v1 = freeVars e1;
            val v2 = freeVars e2
        in
            union v1 (diff v2 [v]) (* let binds x in e2 but not in e1 *)
        end
      | (LetFun(f, x, e1, e2)) =>
        let val v1 = freeVars e1;
            val v2 = freeVars e2
        in
            (* letFun binds f in e2 and x in e1 *)
            union (diff v1 [x]) (diff v2 [f])
        end
      | (Call(Var f, e)) => freeVars e
      | _ => raise Match;

fun closed e = (freeVars e = []);

exception NonClosed;

fun run e =
    if closed e then
        eval e []
    else
        raise NonClosed;

(* Examples *)
val e0 = LetFun("f", "x", Prim2("+", Var "x", Var "a"), Call(Var "f", IConst 1));
freeVars e0;
val e1 = Let("a", IConst 5, e0);
freeVars e1;
run e1;

val e2 = Let("a", IConst 5,
             LetFun("f", "x", Prim2("+", Var "x", Var "a"),
                    Let("a", IConst 3,
                        Call(Var "f", IConst 1)
                       )
            ));

run e2;

(* And what about recursive functions? That's why when building the
environment for evaluating a function call we include the function's
value, as the declaration environment for the function does not
include its value.

 (Call(Var f, e)) =>
 let val fv = (lookup st f) in
     case fv of
         (Closure(f, x, e1, fSt)) =>
         let val ev = Int(eval e st);
             val st' = (x, ev) :: (f, fv) :: fSt
                                  ------
                                   ^
                                   allows recursive calls
         in
             eval e1 st'
         end
*)

(* fun fact x = if x = 0 then 1 else x*(fact (x-1)); *)
fun fact n = LetFun("fact", "x",
                    Ite(Prim2("=", Var "x", IConst 0),
                        IConst 1,
                        Prim2("*",
                              Var "x",
                              Call(Var "fact", Prim2("-", Var "x", IConst 1)))),
                    Call(Var "fact", IConst n)
                   );

fact 0;
run (fact 0);
fact 5;
run (fact 5);
