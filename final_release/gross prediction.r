#install.packages("e1071")
# install.packages('rpart.plot')
# library(rpart.plot)
library(randomForest)
library(e1071)
library(rpart)
dataset <- read.csv('m.csv', header = TRUE)
dataset <- na.omit(dataset)
set.seed(100)

rmse <- function(error){
  sqrt(mean(error^2))
}

# training the model using random forest
model <- randomForest(dataset$gross ~ ., data = dataset)
predictedGross <- predict(model, dataset)
error <- dataset$gross - predictedGross
rmse(error)

# predictedGross <- predict(model, data_test) #random forest testing set
# error <- data_test$gross - predictedGross
# rmse(error)




#----------Predicting Gross-------------


#maleficient
y_pred = predict(model, data.frame(duration = 97 ,
                                   imdb_score = 6.2,  #6.2 is the predicted value
                                   budget = 180000000))


y_pred

#Deadpool 2
y_pred = predict(model, data.frame(duration = 119 ,
                                   imdb_score = 8.5,  #6.2 is the predicted value
                                   budget = 110000000))
y_pred



# live free or Die hard
y_pred = predict(model, data.frame(duration = 128 ,
                                   imdb_score = 6.7, #7.2  # predicted imdb is 6.7
                                   budget = 110000000))
y_pred
#86.4














#Hotel transylvania
y_pred = predict(model, data.frame(duration = 91 ,
                                   imdb_score = 7.1,
                                   budget = 85000000))
#87.2

#The Croods
y_pred = predict(model, data.frame(duration = 98 ,
                                   imdb_score = 7.2,
                                   budget = 135000000))

#83.9





#Logan
y_pred = predict(model, data.frame(duration = 137 ,
                                   imdb_score = 8.1,
                                   budget = 97000000))

#80.1














# index <- sample(1:nrow(dataset), round(0.85*nrow(dataset)))
# data_train <- dataset[index,]
## data_test<- read.csv('data_1.csv')
# data_test <- dataset[-index,]

# data_train <- data_train[,c(3,5,6,8,9,13,14,19,22,23,24,25,26,28)]
# data_test <- data_test[,c(3,5,6,8,9,13,14,19,22,23,24,25,26,28)]
# write.csv(data_test, file = "testing.csv")





# data_train[(apply(data_train, 1, function(y) any(y >100))),]
# model <- svm(dataset$gross ~ ., dataset)
# predictedGross <- predict(model, dataset)
# error <- dataset$gross - predictedGross

# rmse(error)

# x <- seq(1:20)
# {plot(x,data_train[1:20,]$gross,type = 'l', col='red', xlab = 'movie', ylab = 'Gross')
#   lines(x,predictedGross[1:20], col='blue')
#   legend("topright", legend = c('Actual Gross', 'Predicted Gross'), col = c('red', 'blue'), lty=1, cex=.75)}


# predictedGross <- predict(model, data_test)
# error <- data_test$gross - predictedGross
# rmse(error)






# model <- rpart(data_train$gross ~ ., data = data_train)
# predictedGross <- predict(model, data_train)   #decision tree training
# error <- data_train$gross - predictedGross
# rmse(error)
# 
# 
# model <- rpart(dataset$gross ~ ., data = dataset)
# predictedGross <- predict(model, dataset)   #decision tree training
# error <- dataset$gross - predictedGross
# rmse(error)
# 
# 
# predictedGross <- (predict(model, data_test)) #decision tree testing set
# error <- data_test$gross - predictedGross
# rmse(error)

#rpart.plot(model)


