## Example

## Generate data, xs, which is distributed uniformly on [5,10]
xs <- runif(100, min=5, max = 10)

## Generate dependent data with linear dependence:
## Scatter data about the mean
eps <- rnorm(100,sd=0.1)
ys <- 1 + 0.5*xs + eps

# Pack into a data frame
df <- data.frame(X=xs, Y=ys)

# Single variable regression
m1 <- lm(Y ~X, data = df)
summary(m1)

# Look at the data
plot(xs,ys)
abline(m1)


# Compare with first rscaling xs so that it is more normally distributed
# First show the non-normality of xs
qqnorm(xs)

# powerTransform function is in the car package
library(car)
l <- powerTransform(xs)
summary(l)

# I find lambda approx. 0.7 ... so you could use a sqrt transformation
# For lambda close to 0 use a log transformation
xs2 <- sqrt(xs)
qqnorm(xs2)

# Add the transformed data to the data frame and refit
df$Z <- xs2

m2 <- lm(Y~Z, data=df)
summary(m2)

plot(xs2,ys)
abline(m2)

