data <- read.csv("AAR_data.csv")
names(data) <- c("x","y")
data$y <- data$y/100
data <- data[-c(1:11),]
data[,1] <- data[,1] - 10
model <- betareg(y ~ x, data = data, link = "loglog")

extrapolation <- data.frame(x = seq(1, 39, 5))
extrapolation$y <- predict(model, newdata = extrapolation, type = "response")

chat <- data.frame(x=extrapolation[,1],y=extrapolation[,2] * 1380000 * (60.7/(60.7+14+13.5)))
gemini <- data.frame(x=extrapolation[,1],y=extrapolation[,2] * 1380000 * (14/(60.7+14+13.5)))
copilot <- data.frame(x=extrapolation[,1],y=extrapolation[,2] * 1380000 * (13.5/(60.7+14+13.5)))
human <- data.frame(x=extrapolation[,1],y=(1-extrapolation[,2]) * 1380000)

chat <- mutate(chat,Source="ChatGPT")
gemini <- mutate(gemini,Source="Gemini")
copilot <- mutate(copilot,Source="Copilot")
human <- mutate(human,Source="Human")
all <- bind_rows(chat,gemini,copilot, human)

df_percent <- all %>% group_by(x) %>% mutate(total = sum(y),percent = y / total * 100)
df_percent$x <- as.factor(df_percent$x)

View(df_percent)

ggplot(df_percent,aes(x=x,y=percent,fill=Source)) + geom_bar(stat="identity") +
  labs(y="Percent",x="Months Since Nov. 2022",title="Percent Composition of New Monthly Generated Data on Medium.com") + 
  theme(plot.title = element_text(size=18,hjust = 0.5), axis.title = element_text(size = 14), axis.text = element_text(size = 10),legend.text=element_text(size=12),legend.title=element_text(size=14))

