using LightGraphs
using SimpleWeightedGraphs

function alias_draw(J,q)
    K = length(J)
    kk = Int(floor(rand()*k))
    if rand() < q[kk]
        return kk
    else
        return J[kk]
    end
end

function alias_setup(probs)
    K = length(probs)
    q = zeros(K)
    J = zeros(Int,K)

    smaller = Array{Float64}(undef,0)
    larger = Array{Float64}(undef,0)

    for kk, prob in enumerate(probs)
        q[kk] = K*prob
        if q[kk] < 1
            push!(smaller,kk)
        else
            push!(larger,kk)
        end
    end

    while length(smaller) > 0 and length(larger) > 0
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

function preprocess_transition_probs(g)
    for node in 1:nv(g)




function the_walk(g, node, length)
    walk = [node]
    while length(walk) < length
        current = last(walk)
        neigh = neighbors(g, current)
        if length(neigh) > 0

    return walk
end

