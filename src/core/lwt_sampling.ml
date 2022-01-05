
(* current issue - not everything that is created is cancelled or resolved *)

type id = int

type tracer = {
  sample : unit -> bool;
  on_create : id -> unit;
  on_resolve : id -> unit;
  on_cancel : id -> unit;
}

let next_id : id ref = ref 1

let printing_tracer = {
  sample = (fun () -> true);
  on_create = (fun _ -> print_endline "on_create");
  on_resolve = (fun _ -> print_endline "on_resolved");
  on_cancel = (fun _ -> print_endline "on_cancelled");
}

let current_tracer = ref printing_tracer

let on_create ()  =
  print_endline "lwt on_create" ;
  let current_tracer = !current_tracer in
  if current_tracer.sample () then
    let id = !next_id in
    let () = current_tracer.on_create id in
    let regular_callback = fun () -> current_tracer.on_resolve id in
    let cancel_callback = fun () -> current_tracer.on_cancel id in
    let () = next_id := id + 1 in
    Some (regular_callback, cancel_callback)
  else
    None
