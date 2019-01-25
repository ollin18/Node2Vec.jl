using LightGraphs,SimpleWeightedGraphs

function node2vec_walk(g, node, length)
    walk = [node]
    while length(walk) < length
        current = last(walk)
        neigh = neighbors(g, current)
        if length(neigh) > 0
        end
    end

    return walk
end

function simulate_walks(g, num_walks, walk_length)
    #
    #
    #
end

function get_alias_edge(g, src, dst)
    #
    #
    #
end

function preprocess_transition_probs(g)
    for node in 1:nv(g)
        unnormalized_probs=[weigths[nbr] for nbr in neighbors(g,node)]
        norm_const = sum(unnormalized_probs)
        normalized_probs = unnormalized_probs / norm_const
        alias_nodes[node] = alias_setup(normalized_probs)
    end
end

function alias_setup(probs)
    K = length(probs)
    q = zeros(K)
    J = zeros(Int,K)

    smaller = Array{Float64}(undef,0)
    larger = Array{Float64}(undef,0)

    for (kk, prob) in enumerate(probs)
        q[kk] = K*prob
        if q[kk] < 1
            push!(smaller,kk)
        else
            push!(larger,kk)
        end
    end

    while length(smaller) > 0 && length(larger) > 0
        small = pop!(smaller)
        large = pop!(larger)

        J[small] = large
        q[large] = q[large] + q[small] - 1.0
        if q[large] < 1.0
            append!(smaller,large)
        else
            append!(larger,large)
        end
    end
    J, q
end

function alias_draw(J,q)
    K = length(J)
    kk = Int(floor(rand()*k))
    if rand() < q[kk]
        return kk
    else
        return J[kk]
    end
end