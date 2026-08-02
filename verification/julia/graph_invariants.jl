#!/usr/bin/env julia
"""
Numerical/graph verification of the field projection (generated/graph.json).

Invariants checked (deterministic, no AI):
  I1. Referential closure — every edge endpoint is a node id.
  I2. depends_on acyclicity — assumption-dependency must not be circular
      (a claim resting, transitively, on itself is a hidden bootstrap).
  I3. Tension symmetry — every open tension has ≥2 distinct records in
      `between` reachable in the graph (a tension needs two poles).
  I4. Attribution totality — every node has participant_type in
      {human, ai, collective}; nothing is unattributed.
  I5. Orphan report — nodes with degree 0 are reported (warning, not error:
      a new observation may legitimately await relations).
  I6. Independence caveat — count of AI-authored vs human-authored nodes,
      printed so reviewers see the balance; never used as a truth vote.

Run after: python verification/python/build_graph.py
Uses only Julia stdlib (JSON parsed via a minimal reader) to avoid
package-resolution burden in CI.
"""

# --- minimal JSON parsing via Julia stdlib-only approach ---------------------
# Julia stdlib has no JSON parser; to stay dependency-light we install JSON3
# only if missing, pinned by Project.toml in this directory.
import Pkg
try
    @eval using JSON3
catch
    Pkg.activate(@__DIR__)
    Pkg.instantiate()
    @eval using JSON3
end

const ROOT = normpath(joinpath(@__DIR__, "..", ".."))
const GRAPH_PATH = joinpath(ROOT, "generated", "graph.json")

function main()
    graph = JSON3.read(read(GRAPH_PATH, String))
    nodes = graph.nodes
    edges = graph.edges
    node_ids = Set(String(n.id) for n in nodes)
    failures = String[]
    warnings = String[]

    # I1: referential closure
    for e in edges
        for endpoint in (e.source, e.target)
            if !(String(endpoint) in node_ids)
                push!(failures, "I1: edge $(e.id) endpoint $(endpoint) is not a node")
            end
        end
    end

    # I2: depends_on acyclicity (DFS)
    adj = Dict{String,Vector{String}}()
    for e in edges
        if String(e.type) == "depends_on"
            push!(get!(adj, String(e.source), String[]), String(e.target))
        end
    end
    WHITE, GRAY, BLACK = 0, 1, 2
    color = Dict(id => WHITE for id in node_ids)
    function dfs(u::String)::Bool  # true if cycle found
        color[u] = GRAY
        for v in get(adj, u, String[])
            haskey(color, v) || continue
            if color[v] == GRAY
                return true
            elseif color[v] == WHITE && dfs(v)
                return true
            end
        end
        color[u] = BLACK
        return false
    end
    for id in node_ids
        if color[id] == WHITE && dfs(id)
            push!(failures, "I2: depends_on cycle reachable from $(id)")
        end
    end

    # I3: tension polarity
    for n in nodes
        if String(n.kind) == "tension" && String(n.status) == "open"
            poles = [String(e.target) for e in edges
                     if String(e.source) == String(n.id) && String(e.type) == "unresolved_with"]
            if length(unique(poles)) < 2
                push!(failures, "I3: tension $(n.id) has fewer than 2 poles")
            end
        end
    end

    # I4: attribution totality
    for n in nodes
        if !(String(n.participant_type) in ("human", "ai", "collective"))
            push!(failures, "I4: node $(n.id) lacks valid attribution")
        end
    end

    # I5: orphans (warning only)
    touched = Set{String}()
    for e in edges
        push!(touched, String(e.source)); push!(touched, String(e.target))
    end
    for id in node_ids
        id in touched || push!(warnings, "I5: node $(id) has no relations yet")
    end

    # I6: balance report
    n_ai = count(n -> String(n.participant_type) == "ai", nodes)
    n_human = count(n -> String(n.participant_type) == "human", nodes)
    println("I6: participant balance — ai-authored: $(n_ai), human-authored: $(n_human)")
    println("    (a count, not a vote; correlated AI agreement is not confirmation)")

    for w in warnings
        println("⚠ $(w)")
    end
    if !isempty(failures)
        println("GRAPH INVARIANTS FAILED — $(length(failures)) failure(s):")
        for f in failures
            println("  ✗ $(f)")
        end
        exit(1)
    end
    println("GRAPH INVARIANTS HOLD — I1..I4 pass over $(length(nodes)) nodes, $(length(edges)) edges")
end

main()
