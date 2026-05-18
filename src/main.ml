type transition = {
  read     : string;
  to_state : string;
  write    : string;
  action   : string;
}

type machine = {
  name        : string;
  alphabet    : string list;
  blank       : string;
  states      : string list;
  initial     : string;
  finals      : string list;
  transitions : (string * transition list) list;
}

let parse_transition t =
  let open Yojson.Basic.Util in
  {
    read     = t |> member "read"     |> to_string;
    to_state = t |> member "to_state" |> to_string;
    write    = t |> member "write"    |> to_string;
    action   = t |> member "action"   |> to_string;
  }

let parse_json filename =
  let json = Yojson.Basic.from_file filename in
  let open Yojson.Basic.Util in
  {
    name     = json |> member "name" |> to_string;
    alphabet = json |> member "alphabet" |> to_list |> List.map to_string;
    blank    = json |> member "blank" |> to_string;
    states   = json |> member "states" |> to_list |> List.map to_string;
    initial  = json |> member "initial" |> to_string;
    finals   = json |> member "finals" |> to_list |> List.map to_string;
    transitions = json |> member "transitions" |> to_assoc |> List.map (fun (state,trans) -> (state, trans |> to_list |> List.map parse_transition));
  }

let rec simulate machine gauche droite state =
  if List.mem state machine.finals then
    ()
  else
    let droite = if droite = [] then [machine.blank] else droite in
    let read_value = List.hd droite in
    let (_,transitions) = List.find (fun (s,_) -> s = state) machine.transitions in
    let transition = List.find (fun t -> t.read = read_value) transitions in
    let new_droite = transition.write :: List.tl droite in
    if transition.action = "RIGHT" then
      simulate machine (List.hd new_droite :: gauche) (List.tl new_droite) transition.to_state
    else
      simulate machine (List.tl gauche) (List.hd gauche :: new_droite) transition.to_state

let convert_input input =
  List.init (String.length input) (fun i -> String.make 1 input.[i])

let () =
  if Array.length Sys.argv < 3 then (
      print_endline "usage: ft_turing jsonfile input";
      exit 1
    );
  let m = parse_json Sys.argv.(1) in
  let tape = convert_input Sys.argv.(2) in
  simulate m [] tape m.initial

