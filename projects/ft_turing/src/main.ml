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

let print_step gauche droite state transition machine =
  print_string "[";
  List.iter print_string (List.rev gauche);
  print_string ("<" ^ List.hd droite ^ ">");
  List.iter print_string (List.tl droite);
  let tape_length = List.length gauche + List.length droite in
  let padding = if tape_length < 30 then 30 - tape_length else 0 in
  String.make padding (String.get machine.blank 0) |> print_string;
  print_string "] ";
  print_string ("(" ^ state ^ ", " ^ transition.read ^ ") -> (" ^ transition.to_state ^ ", " ^ transition.write ^ ", " ^ transition.action ^ ")");
  print_newline ()

let rec simulate machine gauche droite state =
  if List.mem state machine.finals then
    ()
  else
    let droite = if droite = [] then [machine.blank] else droite in
    let read_value = List.hd droite in
    let (_, transitions) =
      try List.find (fun (s, _) -> s = state) machine.transitions
      with Not_found ->
        Printf.printf "Error: no transitions defined for state '%s'\n" state;
        exit 1 
    in
    let transition = 
      try List.find (fun t -> t.read = read_value) transitions
      with Not_found ->
        Printf.printf "Error: machine is blocked in state '%s' reading '%s'\n" state read_value;
        exit 1
    in
    let new_droite = transition.write :: List.tl droite in
    print_step gauche droite state transition machine;
    if transition.action = "RIGHT" then
      simulate machine (List.hd new_droite :: gauche) (List.tl new_droite) transition.to_state
    else
      simulate machine (List.tl gauche) (List.hd gauche :: new_droite) transition.to_state

let convert_input input =
  List.init (String.length input) (fun i -> String.make 1 input.[i])

let print_header machine = 
  print_endline (String.make 80 '*');
  print_endline ("*" ^ String.make 78 ' ' ^ "*");
  let left_pad = (78 - String.length machine.name) / 2 in
  let right_pad = 78 - String.length machine.name - left_pad in
  print_endline ("*" ^ String.make left_pad ' ' ^ machine.name ^ String.make right_pad ' ' ^ "*");
  print_endline ("*" ^ String.make 78 ' ' ^ "*");
  print_endline (String.make 80 '*');
  print_endline ("Alphabet: [ " ^ String.concat ", " machine.alphabet ^ " ]");
  print_endline ("States : [ " ^ String.concat ", " machine.states ^ " ]");
  print_endline ("Initial State: " ^ machine.initial);
  print_endline ("Finals : [ " ^ String.concat ", " machine.finals ^ " ]");
  let transition_strings = 
    List.concat_map (fun (state, trans) -> List.map (fun t -> "(" ^ state ^ ", " ^ t.read ^ ") -> (" ^ t.to_state ^ ", " ^ t.write ^ ", " ^ t.action ^ ")") trans) machine.transitions in
  List.iter print_endline transition_strings;
  print_endline (String.make 80 '*')

let validate_machine machine =
  let all_states = machine.states in
  let all_symbols = machine.alphabet in
  let validate_transition (state, transitions) =
    if not (List.mem state all_states) then (
      Printf.printf "Error: state '%s' in transitions is not defined in states\n" state;
      exit 1
    );
    List.iter (fun t ->
      if not (List.mem t.to_state all_states) then (
        Printf.printf "Error: to_state '%s' in transition from state '%s' is not defined in states\n" t.to_state state;
        exit 1
      );
      if not (List.mem t.read all_symbols) then (
        Printf.printf "Error: read symbol '%s' in transition from state '%s' is not defined in alphabet\n" t.read state;
        exit 1
      );
      if not (List.mem t.write all_symbols) then (
        Printf.printf "Error: write symbol '%s' in transition from state '%s' is not defined in alphabet\n" t.write state;
        exit 1
      );
      if t.action <> "RIGHT" && t.action <> "LEFT" then (
        Printf.printf "Error: action '%s' in transition from state '%s' is invalid (must be 'RIGHT' or 'LEFT')\n" t.action state;
        exit 1
      )
    ) transitions
  in
  if not (List.mem machine.blank machine.alphabet) then (
    Printf.printf "Error: blank '%s' is not in alphabet\n" machine.blank;
    exit 1
  );
  if not (List.mem machine.initial machine.states) then (
    Printf.printf "Error: initial state '%s' is not in states\n" machine.initial;
    exit 1
  );
  if not (List.for_all (fun s -> List.mem s machine.states) machine.finals) then (
    Printf.printf "Error: some final states are not in states\n";
    exit 1
  );
  List.iter validate_transition machine.transitions

let () =
  if Array.length Sys.argv < 3 then (
      print_endline "usage: ft_turing jsonfile input";
      exit 1
    );
  let m = parse_json Sys.argv.(1) in
  let tape = convert_input Sys.argv.(2) in
  print_header m;
  validate_machine m;
  simulate m [] tape m.initial

