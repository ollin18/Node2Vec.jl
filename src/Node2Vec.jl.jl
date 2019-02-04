__precompile__()
module Node2Vec.jl
    using LightGraphs
    using SimpleWeightedGraphs
    using Word2Vec
    using Pkg
    using DelimitedFiles
    Pkg.instantiate()

    import LightGraphs:
        _NI, AbstractGraph, AbstractEdge, AbstractEdgeIter,
        src, dst, edgetype, nv, ne, vertices, edges, is_directed,
        add_vertex!, add_edge!, rem_vertex!, rem_edge!,
        has_vertex, has_edge, inneighbors, outneighbors,
        indegree, outdegree, degree, has_self_loops, num_self_loops,

        add_vertices!, adjacency_matrix, weights, connected_components, cartesian_product,

        AbstractGraphFormat, loadgraph, loadgraphs, savegraph,
        pagerank, induced_subgraph

    import SimpleWeightedGraphs:
        AbstractSimpleWeightedGraph,
        AbstractSimpleWeightedEdge,
        SimpleWeightedEdge,
        SimpleWeightedGraph,
        SimpleWeightedGraphEdge,
        SimpleWeightedDiGraph,
        SimpleWeightedDiGraphEdge,
        weight,
        weighttype,
        get_weight,
        WGraph,
        WDiGraph,
        SWGFormat


    export node2vec_walk, simulate_walks, learn_embeddings

    include("rw.jl")
end # module
