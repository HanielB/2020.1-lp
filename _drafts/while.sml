Control.Print.printDepth := 100;

datatype Aexpr =
         Num of int
         | Var of string
         | Plus of Aexpr * Aexpr
         | Mult of Aexpr * Aexpr
         | Minus of Aexpr * Aexpr;

datatype Bexpr =
         True
         | False
         | Not of Bexpr
         | And of Bexpr * Bexpr
         | Eq of Aexpr * Aexpr
         | Leq of Aexpr * Aexpr;

datatype Stm =
         Assign of Aexpr * Aexpr
       | Skip
       | Comp of Stm * Stm
       | If of Bexpr * Stm * Stm
       | While of Bexpr * Stm;

exception FreeVar
fun lookup [] id = raise FreeVar
  | lookup ((k:string, v)::t) id = if k = id then v else lookup t id;

fun evalA (Num n) _ = n
  | evalA (Var x) s = lookup s x
  | evalA (Plus(e1, e2)) s = (evalA e1 s) + (evalA e2 s)
  | evalA (Mult(e1, e2)) s = (evalA e1 s) * (evalA e2 s)
  | evalA (Minus(e1, e2)) s = (evalA e1 s) - (evalA e2 s)

(* evalA (Plus(Var "x", Num 5)) [("x", 1)] *)

fun evalB True _ = true
  | evalB False _ = false
  | evalB (Not e) s = not (evalB e s)
  | evalB (And(e1, e2)) s = (evalB e1 s) andalso (evalB e2 s)
  | evalB (Eq(e1, e2)) s = (evalA e1 s) = (evalA e2 s)
  | evalB (Leq(e1, e2)) s = (evalA e1 s) < (evalA e2 s)


fun evalStm (stm:Stm) (s: (string * int) list) =
    case stm of
        (Assign(Var x, e)) => (x, evalA e s)::s
      | Skip => s
      | (Comp(stm1, stm2)) =>
        let val s1 = evalStm stm1 s in
            evalStm stm2 s1
        end
      | (If(c, e1, e2)) => if (evalB c s) then evalStm e1 s else evalStm e2 s
      (* | While ... => ... *)
      | _ => raise Match;

val p1 =
    Comp
    (Assign (Var "x",Num 1),
     Comp
       (Assign (Var "y",Plus (Var "x",Num 5)),
        If(Leq (Var "y",Num 6),
           Assign (Var "z",Var "y"),
           Assign (Var "z",Mult (Var "y",Num 2)))));

evalStm p1 [];
