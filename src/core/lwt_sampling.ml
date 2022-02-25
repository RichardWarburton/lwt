
type promise_id = int

type tracer = {
  sample : unit -> bool;
  on_create : promise_id -> promise_id -> unit;
  on_resolve : promise_id -> unit;
  on_cancel : promise_id -> unit;
}

let no_parent_id : promise_id = 0

let default_tracer = {
  sample = (fun () -> true);
  on_create = (fun id parent -> print_endline ("on_create: " ^ (string_of_int id) ^ " from " ^ (string_of_int parent)));
  on_resolve = (fun id -> print_endline ("on_resolved: " ^ string_of_int id));
  on_cancel = (fun id -> print_endline ("on_cancelled: " ^ string_of_int id));
}

let current_tracer = ref default_tracer
