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