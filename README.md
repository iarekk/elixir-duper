# Duper

Duplicate-file-finding application.

Based on Chapter 19 of <https://pragprog.com/titles/elixir16/programming-elixir-1-6/>.

## Initial supervision structure

```mermaid
flowchart TD
    dsup[Duper Supervisor]
    wsup[Worker Supervisor]
    res([Results])
    path([Pathfinder])
    gath([Gatherer])
    w1([Worker1])
    w2([Worker2])
    wn([WorkerN])
    dsup --> res
    dsup --> path
    dsup --> wsup
    dsup --> gath
    wsup --> w1
    wsup --> w2
    wsup --> wn
    classDef sup fill:#696;
    class dsup,wsup sup;
```

## Sequence diagram

```mermaid
sequenceDiagram
participant P as Pathfinder
participant W as Worker
participant G as Gatherer
participant R as Results
activate W
W ->> P: next_path
P ->> W: path
W -) G: {path, hash}
G -) R: {path, hash}
W ->> P: next_path
P ->> W: path
W -) G: {path, hash}
G -) R: {path, hash}
W ->> P: next_path
P ->> W: nil
W -) G: :done
G ->> R: get_results
R ->> G: results

deactivate W
```

## Runtime metrics

```sh
➜ time mix run --no-halt > dups       
mix run --no-halt > dups  6.08s user 1.24s system 81% cpu 8.927 total # 1 worker
➜ time mix run --no-halt > dups
mix run --no-halt > dups  5.86s user 1.27s system 176% cpu 4.041 total # 2 workers
➜ time mix run --no-halt > dups       
mix run --no-halt > dups  6.05s user 1.41s system 207% cpu 3.598 total # 3 workers
➜ time mix run --no-halt > dups       
mix run --no-halt > dups  5.83s user 1.36s system 217% cpu 3.304 total # 4 workers
➜ time mix run --no-halt > dups       
mix run --no-halt > dups  6.30s user 1.70s system 246% cpu 3.243 total # 8 workers
➜ time mix run --no-halt > dups       
mix run --no-halt > dups  6.14s user 1.73s system 247% cpu 3.173 total # 80 workers
```