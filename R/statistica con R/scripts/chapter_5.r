working_dir = getwd()

x  <- c(0.39, 0.68, 0.82, 1.35, 1.38, 1.62, 1.70, 1.71, 1.85, 2.14, 2.89, 3.69)
s2 <- var(x)
mx <- mean(x)
n  <-length(x)



t.test(x)
