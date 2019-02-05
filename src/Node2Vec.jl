module Node2Vec.jl
    using LightGraphs,SimpleWeightedGraphs,Random,Word2Vec,DelimitedFiles

    export node2vec_walk, simulate_walks, learn_embeddings

    include("rw.jl")
end # module
