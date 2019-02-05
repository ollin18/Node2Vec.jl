using Word2Vec, SimpleWeightedGraphs, DelimitedFiles, LightGraphs

tred=readdlm("../data/networks/adyacencias.csv",'|')
Nodes=readdlm("../data/networks/los_nombres.csv",',')

dic_nodes = Dict{String,Int64}(Dict(Nodes[i]=>i for i in 1:length(Nodes)))
g = SimpleWeightedGraph()
last_node = Int64(length(Nodes))
add_vertices!(g,last_node)
for n in
    1:Int64(size(tred)[1])
    add_edge!(g,dic_nodes[tred[n,1]],
              dic_nodes[tred[n,2]],
              tred[n,3])
end

walks=simulate_walks(g,5,80,2,2)
@test typeof(walks) == Array{Array,1}
@test @inferred length(length(walks)) == 640
@test @inferred length(length(walks)[1]) == 8
model=learn_embeddings(walks)
@test typeof(model) == WordVectors{String,Float64,Int64}
vectors=model.vectors
@test isa(vectors,Array)
@test @inferred size(vectors) == (100,129)
senators=vectors[:,2:size(vectors)[2]]
dv=tsne(senators')
@test @inferred size(dv) == (128,2)
