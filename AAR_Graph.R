library(betareg)
library(ggplot2)
library(dplyr)

data <- read.csv("AAR_data.csv")
names(data) <- c("x","y")
data$y <- data$y/100
data <- data[-c(1:11),]
data[,1] <- data[,1] - 10
model <- betareg(y ~ x, data = data, link = "loglog")

extrapolation <- data.frame(x = seq(1, 149))
extrapolation$y <- predict(model, newdata = extrapolation, type = "response")
extrapolation <- mutate(extrapolation, group = "Predicted AAR Values")
data <- mutate(data, group = "Original AAR Values")

extra <- bind_rows(extrapolation, data)

ggplot(extra) + 
  geom_point(aes(x = x, y = y, color=group), size = 1.2) + scale_color_manual(values = c("Original AAR Values" = "red", "Predicted AAR Values" = "blue")) + 
  labs(color=NULL,title="Beta Regression of AAR on Medium.com (Using Log-Log Link Function)",y="AAR (AI Attribution Rate)",x="Months Since End of Nov. 2022") + 
  theme(plot.title = element_text(size=18,hjust = 0.5), axis.title = element_text(size = 14), axis.text = element_text(size = 10),legend.text=element_text(size=12))


View(extra)
View(data)
