using LightGraphs,SimpleWeightedGraphs,Random,Word2Vec,DelimitedFiles

function node2vec_walk(g, node, len,p,q)
    no,ed=preprocess_transition_probs(g,p,q)
    walk=[node]
    while length(walk) < len
        current=last(walk)
        neigh=neighbors(g, current)
        if length(neigh) > 0
            if length(walk)==1
                append!(walk,neigh[alias_draw(no[current][1],
                                              no[current][2])])
            else
                prev=walk[length(walk)-1]
                next=neigh[alias_draw(ed[(prev,current)][1],
                                      ed[(prev,current)][2])]
                append!(walk,next)
            end
        else
            break
        end
    end
    return walk
end

function simulate_walks(g,num_walks,len,p,q)
    walks=Array{Array}(undef,0)
    nodes=vertices(g) |> collect
    for i in 1:num_walks
        nodes=shuffle(nodes)
        for node in nodes
            push!(walks,node2vec_walk(g,node,len,p,q))
        end
    end
    walks
end

function get_alias_edge(g, src, dst,p,q)
    unnormalized_probs=Array{Float64}(undef,0)
    for dst_nbr in neighbors(g,dst)
        if dst_nbr == src
            append!(unnormalized_probs, g.weights[dst,dst_nbr]/p)
        elseif has_edge(g,dst_nbr,src)
            append!(unnormalized_probs, g.weights[dst,dst_nbr])
        else
            append!(unnormalized_probs, g.weights[dst,dst_nbr]/q)
        end
    end
    norm_const=sum(unnormalized_probs)
    normalized_probs=unnormalized_probs/norm_const
    alias_setup(normalized_probs)
end

function preprocess_transition_probs(g,p,q)
    alias_nodes=Dict()
    for node in vertices(g)
        unnormalized_probs=[g.weights[node,nbr] for nbr in neighbors(g,node)]
        norm_const=sum(unnormalized_probs)
        normalized_probs=unnormalized_probs/norm_const
        alias_nodes[node]=alias_setup(normalized_probs)
    end
    alias_edges=Dict()
    ## Directed networks
    if is_directed(g)
        for e in edges(g)
            alias_edges[(e.src,e.dst)]=get_alias_edge(g,e.src,e.dst,p,q)
        end
    else
    ## Undirected networks
        for e in edges(g)
            alias_edges[(e.src,e.dst)]=get_alias_edge(g,e.src,e.dst,p,q)
            alias_edges[(e.dst,e.src)]=get_alias_edge(g,e.dst,e.src,p,q)
        end
    end
    alias_nodes, alias_edges
end

function alias_setup(probs)
    K=length(probs)
    q=zeros(K)
    J=zeros(Int,K)

    smaller=Array{Float64}(undef,0)
    larger=Array{Float64}(undef,0)

    for (kk, prob) in enumerate(probs)
        q[kk]=K*prob
        if q[kk] < 1
            push!(smaller,kk)
        else
            push!(larger,kk)
        end
    end

    while length(smaller) > 0 && length(larger) > 0
        small=Int(pop!(smaller))
        large=Int(pop!(larger))

        J[small]=large
        q[large]=q[large]+q[small]-1.0
        if q[large] < 1.0
            append!(smaller,large)
        else
            append!(larger,large)
        end
    end
    J, q
end

function alias_draw(J,q)
    K=length(J)
    kk=Int(ceil(rand()*K))
    if rand() < q[kk]
        return kk
    else
        return J[kk]
    end
end

function learn_embeddings(walks;size::Int=100)
    str_walks=map(x -> string.(x),walks)
    if Sys.iswindows()
        rpath = pwd()
    else
        rpath = "/tmp"
    end
    the_walks = joinpath(rpath,"str_walk.txt")
    the_vecs = joinpath(rpath,"str_walk-vec.txt")

    writedlm(the_walks,str_walks)
    word2vec(the_walks,the_vecs,verbose=true,size=size)
    model=wordvectors(the_vecs)
    model
end
