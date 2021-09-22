library(WGCNA)
library(ggraph)
library(tidygraph)
library(igraph)
setwd("C:/Users/Pioneer/Desktop/考题-20200413")
# Create graph of highschool friendships
load("highschool.rda")
load("flare.rda")


graph <- tidygraph::as_tbl_graph(highschool) %>% 
  mutate(Popularity = centrality_degree(mode = 'in'))
graph1 <- igraph::graph_from_data_frame(highschool)


# plot using ggraph
ggraph::ggraph(graph, layout = 'kk') + 
  geom_edge_fan(aes(alpha = stat(index)), show.legend = FALSE) + 
  geom_node_point(aes(size = Popularity)) + 
  facet_edges(~year) + 
  theme_graph(foreground = 'steelblue', fg_text_colour = 'white')


library(tweenr)
igraph_layouts <- c('star', 'circle', 'gem', 'dh', 'graphopt', 'grid', 'mds', 
                    'randomly', 'fr', 'kk', 'drl', 'lgl')
igraph_layouts <- sample(igraph_layouts)
graph <- graph_from_data_frame(highschool)
V(graph)$degree <- degree(graph)
layouts <- lapply(igraph_layouts, create_layout, graph = graph)
layouts_tween <- tween_states(c(layouts, layouts[1]), tweenlength = 1, 
                              statelength = 1, ease = 'cubic-in-out', 
                              nframes = length(igraph_layouts) * 16 + 8)
title_transp <- tween_t(c(0, 1, 0, 0, 0), 16, 'cubic-in-out')[[1]]
for (i in seq_len(length(igraph_layouts) * 16)) {
  tmp_layout <- layouts_tween[layouts_tween$.frame == i, ]
  layout <- igraph_layouts[ceiling(i / 16)]
  title_alpha <- title_transp[i %% 16]
  p <- ggraph(graph, 'fr') + 
    geom_edge_fan(aes(alpha = ..index.., colour = factor(year)), n = 15) +
    geom_node_point(aes(size = degree)) + 
    scale_edge_color_brewer(palette = 'Dark2') + 
    ggtitle(paste0('Layout: ', layout)) + 
    theme_bw() + 
    theme(legend.position = 'none', 
          plot.title = element_text(colour = alpha('black', title_alpha)))
  plot(p)
}

#
gr <- graph_from_data_frame(flare$edges, vertices = flare$vertices)
p<-ggraph(gr, layout = 'partition') + 
  geom_node_tile(aes(y = -y, fill = depth))
#
ggraph(gr, layout = 'dendrogram', circular = TRUE) + 
  geom_edge_diagonal() + 
  geom_node_point(aes(filter = leaf)) + 
  coord_fixed()
#
l <- ggraph(gr, layout = 'partition', circular = TRUE)
l + geom_edge_diagonal(aes(width = ..index.., alpha = ..index..), lineend = 'round') + 
  scale_edge_width(range = c(0.2, 1.5)) + 
  geom_node_point(aes(colour = depth)) + 
  coord_fixed()


graph <- graph_from_data_frame(flare$edges, vertices = flare$vertices)
layout <-create_layout(graph, 'circlepack')
p <- ggraph(graph, 'circlepack') + 
  geom_edge_link() + 
  geom_node_point(aes(size=size, colour = depth)) +
  coord_fixed()

ggraph(graph, layout)%>%
  extract2("data") %>% names()


library(UCSCXenaTools)
library(dplyr)
setwd("C:/Users/Pioneer/Desktop/考题-20200413")


# download dataset
COAD_data <- XenaScan(pattern = 'Colon Cancer', ignore.case = F) %>% # choose dataset pattern
  XenaGenerate(subset = XenaHostNames=="tcgaHub")%>%  # choose database host
  XenaFilter(filterDatasets = "COAD_clinicalMatrix") %>% # choose dataset
  XenaQuery() %>% XenaDownload() %>% XenaPrepare() 


new_var <- plyr::mapvalues(df$v1, 
                           from = levels(df$v1),
                           to = 1:length(levels(df$v1)))


data <- data.frame(x=c(2000, 500, 200, 100, 50, 30), 
                   y=c(0.001, 0.1, 2, 6, 10, 12))
lm(data$y~data$x)
