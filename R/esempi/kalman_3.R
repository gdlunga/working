library(lattice)
grid <- expand.grid(x=x1,y=x2)
grid$Prior <- as.vector(z)
grid$Likelihood <- as.vector(z2)
grid$Posterior <- as.vector(z3)
grid$Predictive <- as.vector(z4)
contourplot(Prior + Likelihood + Posterior + Predictive ~ x*y, 
            data=grid, col.regions=mycols, region=TRUE,
            as.table=TRUE, 
            xlab=expression(x[1]),
            ylab=expression(x[2]),
            main="Kalman Filter",
            panel=function(x,y,...){
              panel.grid(h=-1, v=-1)
              panel.contourplot(x,y,...)
            })