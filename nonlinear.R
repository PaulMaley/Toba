##
## Example of non-linear dependence
##

# Simulated data
xs <- runif(100)
eps <- rnorm(100,sd=0.5)
ys <- xs^(-0.5) + eps

# Trying to fit directly
df <- data.frame(X=xs,Y=ys)
m1 <- lm(Y~X, data=df)
summary(m1)

# Plot it ..... rubbish
plot(xs,ys)
abline(m1)

# Suspected power lay .... log-log
ys2 <- log(ys)
xs2 <- log(xs)

# Try again ...
df2 <- data.frame(X=xs2, Y=ys2)
m2 <- lm(Y~X, data=df2)

plot(xs2,ys2)
abline(m2)

# Now to work in the original variables
# Build a function that uses the coefficients determined by the regression

f <- function(x) {exp(m2$coefficients[[1]]) * x^m2$coefficients[[2]] }
yfd <- sapply(xs,f) 
plot(xs,ys)
points(xs,yfd, col='red')


