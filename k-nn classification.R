rm(list=ls(all=TRUE))

#loading libraries
library(class)
library(caret)
library(e1071)


#reading data
library(readr)

universala.df <- read.csv('demooutput.csv')
universal.df <- universala.df[-1]
summary(universal.df)
View(universal.df)


#partition the data
set.seed(1)  
train.index <- sample(row.names(universal.df), 0.6*dim(universal.df)[1])
train.index
valid.index <- setdiff(row.names(universal.df), train.index)  
train.df <- universal.df[train.index,]
train.df
valid.df <- universal.df[valid.index,]
t(t(names(train.df)))
ttrain.df <- train.df[-4]
vvalid.df <- valid.df[-4]

#new customer information
new.cust <- data.frame(Spending = 20,                
                       Income = 8,    
                       Age = 50)


# normalize the data
train.norm.df <- train.df[,-4]
valid.norm.df <- valid.df[,-4]


new.cust.norm <- new.cust
norm.values <- preProcess(train.df[, -4], method=c("center", "scale"))
train.norm.df <- predict(norm.values, train.df[, -4])
train.norm.df
valid.norm.df <- predict(norm.values, valid.df[, -4])
valid.norm.df
new.cust.norm <- predict(norm.values, new.cust.norm)
new.cust.norm


#model
knn.pred <- class::knn(train = ttrain.df,
                       test = new.cust,
                       cl = train.df$Cluster, k = 3)


knn.pred
confusionMatrix(knn.pred, as.factor(valid.df$Cluster), positive = "1")
accuracy(knn.pred)

library(e1071)
# optimal k
accuracy.df <- data.frame(k = seq(1, 15, 1), overallaccuracy = rep(0, 15))
for(i in 1:15) {
  knn.pred <- class::knn(train = ttrain.df,
                         test = vvalid.df,
                         cl = train.df$Cluster, k = i)
  accuracy.df[i, 2] <- confusionMatrix(knn.pred,
                                       as.factor(valid.df$Cluster))$overall[1]}
 
accuracy.df

which(accuracy.df[,2] == max(accuracy.df[,2]))



knn.pred <- class::knn(train = train.norm.df,
                       test = valid.norm.df,
                       cl = train.df$Cluster, k = 3)
confusionMatrix(knn.pred, as.factor(valid.df$Cluster), positive = "1")




knn.pred <- class::knn(train = train.norm.df,
                       test = new.cust.norm,
                       cl = train.df$Cluster, k = 3)
knn.pred
