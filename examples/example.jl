using TSne, Plots, Colors, GraphPlot, LightGraphs, SimpleWeightedGraphs,DelimitedFiles, StatsBase

tred=readdlm("data/networks/adyacencias.csv",'|')
Nodes=readdlm("data/networks/los_nombres.csv",',')
sen=readdlm("data/networks/senators.csv",'|')
partidos=readdlm("data/networks/los_partidos.csv",'|')

dic_nodes = Dict{String,Int64}(Dict(Nodes[i]=>i for i in 1:length(Nodes)))
g = SimpleWeightedGraph()
G = Graph()
last_node = Int64(length(Nodes))
add_vertices!(g,last_node)
add_vertices!(G,last_node)
for n in
    1:Int64(size(tred)[1])
    add_edge!(g,dic_nodes[tred[n,1]],
              dic_nodes[tred[n,2]],
              tred[n,3])
    add_edge!(G,dic_nodes[tred[n,1]],
              dic_nodes[tred[n,2]])
end

walks=simulate_walks(g,5,80,2,2)
model=learn_embeddings(walks)
vectors=model.vectors
senators=vectors[:,2:size(vectors)[2]]
dv=tsne(senators')
scatter(dv[:,1],dv[:,2],legend=false,show=true)

get_order=Array{String}(undef,128)
for j in 1:128
   for i in 1:128
       if sen[i,2]==Nodes[j]
           get_order[j]=sen[i,3]
       end
   end
end

the_nodes=model.vocab[2:end]
nodes_num = map(x->parse(Int64,x),the_nodes)
ord_party=Array{Any}(undef,128)
for i in eachindex(nodes_num)
    ord_party[i]=get_order[nodes_num[i]]
end

for i in 1:size(ord_party)[1]
    if ord_party[i]=="PRI"
        ord_party[i]=1
    elseif ord_party[i]=="PAN"
        ord_party[i]=2
    elseif ord_party[i]=="PRD"
        ord_party[i]=3
    elseif ord_party[i]=="PVEM"
        ord_party[i]=4
    elseif ord_party[i]=="PT"
        ord_party[i]=5
    elseif ord_party[i]=="Independiente"
        ord_party[i]=6
    end
end

nodecolor = [colorant"red",colorant"blue",colorant"yellow",colorant"green",colorant"orange",colorant"violet"]
nodefillc =  nodecolor[ord_party]

scatter(dv[:,1],dv[:,2],legend=false,color=nodefillc,markersize=4,
        markerstrokewidth=0.3,alpha=0.6,show=true)
title!("Mexican Senate - Node2Vec proj with p=2 q=2")
savefig("./node2vecp2q2.png")

# With DeepWalk

walks=simulate_walks(g,5,80,1,1)
model=learn_embeddings(walks)
vectors=model.vectors
senators=vectors[:,2:size(vectors)[2]]
dv=tsne(senators')
scatter(dv[:,1],dv[:,2],legend=false,show=true)

get_order=Array{String}(undef,128)
for j in 1:128
   for i in 1:128
       if sen[i,2]==Nodes[j]
           get_order[j]=sen[i,3]
       end
   end
end

the_nodes=model.vocab[2:end]
nodes_num = map(x->parse(Int64,x),the_nodes)
ord_party=Array{Any}(undef,128)
for i in eachindex(nodes_num)
    ord_party[i]=get_order[nodes_num[i]]
end

for i in 1:size(ord_party)[1]
    if ord_party[i]=="PRI"
        ord_party[i]=1
    elseif ord_party[i]=="PAN"
        ord_party[i]=2
    elseif ord_party[i]=="PRD"
        ord_party[i]=3
    elseif ord_party[i]=="PVEM"
        ord_party[i]=4
    elseif ord_party[i]=="PT"
        ord_party[i]=5
    elseif ord_party[i]=="Independiente"
        ord_party[i]=6
    end
end

nodecolor = [colorant"red",colorant"blue",colorant"yellow",colorant"green",colorant"orange",colorant"violet"]
nodefillc =  nodecolor[ord_party]

scatter(dv[:,1],dv[:,2],legend=false,color=nodefillc,markersize=4,
        markerstrokewidth=0.3,alpha=0.6,show=true)
title!("Mexican Senate - DeepWalk")
savefig("./deepwalk.png")

# Plot networks
draw(PNG("./plot.png",16cm,16cm),gplot(G,nodefillc=nodefillc,layout=spring_layout))
draw(PNG("./plot2.png",16cm,16cm),gplot(G,nodefillc=nodefillc,layout=spring_layout))
