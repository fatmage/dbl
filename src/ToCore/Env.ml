(* This file is part of DBL, released under MIT license.
 * See LICENSE for details.
 *)

(** Environment of the translation *)

(* Author: Piotr Polesiuk, 2023,2024 *)

open Common

type t =
  { tvar_map : T.TVar.ex S.TVar.Map.t
  }

let empty =
  { tvar_map =
      T.BuiltinType.all
      |> List.map (fun (name, x) -> (List.assoc name S.BuiltinType.all, x))
      |> List.to_seq |> S.TVar.Map.of_seq
  }

let add_tvar env x =
  let (Ex k) = tr_kind (S.TVar.kind x) in
  let y = T.TVar.Ex (T.TVar.fresh k) in
  { tvar_map = S.TVar.Map.add x y env.tvar_map
  }, y

let add_named_tvar env (_, x) =
  add_tvar env x

let add_tvars env xs =
  List.fold_left_map add_tvar env xs

let add_tvar_ex' env x y =
  { tvar_map = S.TVar.Map.add x y env.tvar_map }

let add_tvars' env xs ys =
  List.fold_left2 add_tvar_ex' env xs ys

let lookup_tvar env x =
  try S.TVar.Map.find x env.tvar_map with
  | Not_found ->
    failwith "Internal error: unbound type variable"
