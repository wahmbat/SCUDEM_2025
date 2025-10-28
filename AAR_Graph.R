library(betareg)
library(ggplot2)


data <- read.csv("AAR.csv")
names(data) <- c("x","y")
data$y <- data$y/100
data <- data[-c(1:11),]
data[,1] <- data[,1] - 11
model <- betareg(y ~ x, data = data, link = "loglog")

extrapolation <- data.frame(x = seq(0, 150))
extrapolation$pred <- predict(model, newdata = extrapolation, type = "response")
ggplot() +
  geom_point(data = data, aes(x = x, y = y), color = "gray50", alpha = 0.6) +
  geom_point(data = extrapolation, aes(x = x, y = pred), color = "blue", size = 1.2)

View(extrapolation)
View(data)
