p <- plot_ly(mtcars, x = ~wt, y = ~hp, z = ~qsec,
             marker = list(color = ~mpg, colorscale = c('#FFE1A1', '#683531'), showscale = TRUE),
             width = NULL,
             height = NULL) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'Weight'),
                      yaxis = list(title = 'Gross horsepower'),
                      zaxis = list(title = '1/4 mile time')),
         annotations = list(
           x = 1.13,
           y = 1.05,
           text = 'Miles/(US) gallon',
           xref = 'paper',
           yref = 'paper',
           showarrow = FALSE
         ))


saveWidget(p, "p1.html", selfcontained = F, libdir = libdir)
orca(p, file = "p1.pdf",width = 800, height = 600)
orca(p, file = "p1.png",width = 800, height = 600)

mtcars$am[which(mtcars$am == 0)] <- 'Automatic'
mtcars$am[which(mtcars$am == 1)] <- 'Manual'
mtcars$am <- as.factor(mtcars$am)

p2 <- plot_ly(mtcars, x = ~wt, y = ~hp, z = ~qsec, color = ~am, 
              colors = c('#BF382A', '#0C4B8E')
) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'Weight'),
                      yaxis = list(title = 'Gross horsepower'),
                      zaxis = list(title = '1/4 mile time')))


saveWidget(p2, "p2.html", selfcontained = F, libdir = libdir)
orca(p2, file = "p2.pdf",width = 800, height = 600)
orca(p2, file = "p2.png",width = 800, height = 600)
