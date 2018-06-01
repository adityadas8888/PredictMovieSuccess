library(shiny)
library(ggplot2)
library(readr)
library(dplyr)
library(corrplot)
library(tidyr)
library(rworldmap)
library(classInt)
library(RColorBrewer)
# install.packages('plotly')
library(plotly)
library(randomForest)
library(pROC)
library(mlbench)
library(caret)
library(e1071)
library(neuralnet)
# install.packages('openssl')
library(openssl)

function(input, output) {
  
  movies <- read_csv("movie_metadata.csv")
  
  output$plot <- renderPlot({
    if(input$options == "Visualization" && input$visOpts=="Number of movies Vs Years")
    {
      p <-ggplot(data=movies,aes(x = title_year))+geom_histogram(binwidth=1)
    } 
    else if(input$options == "Visualization" && input$visOpts=="Imdb Score Vs Duration")
    {
      p<-ggplot(data=movies,aes(x = duration))+geom_histogram(binwidth=3)+xlim(c(0,quantile(movies$duration,0.99, na.rm = T)))
    }
    else if(input$options == "Visualization" && input$visOpts=="Number of movies vs Genre" )
    {
      genre_df <- movies %>% separate_rows(genres, sep = "\\|") %>% group_by(Genres= trimws(genres, which= c("both"))) %>% summarise(Movie_Count = n()) %>% arrange(desc(Movie_Count))
      p <- ggplot(genre_df, aes(x = Genres, y = Movie_Count, fill=Genres, width=0.5)) + geom_bar(stat = "identity")+theme(axis.text.x = element_text(angle = 60, hjust = 1))
      
    }
    else if(input$options == "Visualization" && input$visOpts=="Mean Imdb score vs Genre")
    {
      genre_df <- movies %>% separate_rows(genres, sep = "\\|") %>% group_by(gen= trimws(genres, which= c("both"))) %>% summarise(avg = mean(imdb_score)) %>% arrange(desc(avg))
      p<- ggplot(genre_df, aes(x = gen, y = avg, fill=gen, width=0.5)) +geom_bar(stat = "identity")+theme(axis.text.x = element_text(angle = 60, hjust = 1))
      
    }
    else if(input$options == "Visualization" && input$visOpts=="Gross vs Imdb score vs Genre")
    {
      movie<- movies %>% separate_rows(genres, sep = "\\|")
      p <- plot_ly(movie, x = ~genres, y = ~imdb_score, z= ~gross, type = 'scatter3d', mode = 'markers',
                   size = ~imdb_score,sizes = c(25,26) ,color = ~genres, colors = 'Paired')
    }
    else if(input$options == "Visualization" && input$visOpts=="Country vs Mean Ratings")
    {
      country_rating <- movies %>% separate_rows(country, sep = "\\|") %>% group_by(country=trimws(country, which= c("both"))) %>% summarise(Ratings = mean(imdb_score)) %>% arrange(desc(Ratings))
      country_rating_data <-head(country_rating, 50)
      ratingMap<- joinCountryData2Map(country_rating_data, joinCode = 'NAME' , nameJoinColumn = "country",verbose=TRUE)
      p<-mapCountryData(ratingMap, nameColumnToPlot = "Ratings")
    }
    else if(input$options == "Correlation Analysis")
    {
      num = sapply(movies, is.numeric)
      fact = sapply(movies, is.factor)
      imdb_numeric = movies[, num]
      imdb_factor = movies[, fact]
      M<- cor(na.omit(imdb_numeric), use="complete.obs", method="pearson")
      p<-corrplot(M, method="circle")
      
    }
    else if(input$options== "Random Forest")
    {
      set.seed(0)
      movies_with_good_variables = movies[, c("imdb_score",
                                              "director_facebook_likes", 
                                              "cast_total_facebook_likes", 
                                              "actor_1_facebook_likes",
                                              "actor_2_facebook_likes",
                                              "actor_3_facebook_likes",
                                              "movie_facebook_likes", 
                                              "facenumber_in_poster",
                                              "gross",
                                              "budget")]
      mvs = na.omit(movies_with_good_variables)
      #finding mean imdb score
      mean_rating <- mean(mvs$imdb_score)
      mvs$rating <- ifelse(mvs$imdb_score < (floor(mean_rating)-1),'poor',ifelse(mvs$imdb_score > ceiling(mean_rating),'good', 'average'))
      #convert to factors 
      mvs$rating <- as.factor(mvs$rating)
      #66.32% of data is recommended to be ideal training size for random forest hence 36.8% for test
      index = sample(1:nrow(mvs), size=0.368*nrow( mvs))
      test = mvs[index,]
      train = mvs[-index,]
      control <- trainControl(method="repeatedcv", number=2, repeats=2, search="grid")
      set.seed(7)
      seed <- 7
      metric <- "Accuracy"
      set.seed(seed)
      #mtry <- sqrt(ncol(train))
      customRF <- list(type = "Classification", library = "randomForest", loop = NULL)
      customRF$parameters <- data.frame(parameter = c("mtry", "ntree"), class = rep("numeric", 2), label = c("mtry", "ntree"))
      customRF$grid <- function(x, y, len = NULL, search = "grid") {}
      customRF$fit <- function(x, y, wts, param, lev, last, weights, classProbs, ...) {
        randomForest(x, y, mtry = param$mtry, ntree=param$ntree, ...)
      }
      customRF$predict <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
        predict(modelFit, newdata)
      customRF$prob <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
        predict(modelFit, newdata, type = "prob")
      customRF$sort <- function(x) x[order(x[,1]),]
      customRF$levels <- function(x) x$classes
      tunegrid <- expand.grid(.mtry=c(2:4), .ntree=c(100, 200))
      rf_gridsearch <- train(rating ~. -imdb_score, data=train, method=customRF, metric=metric, tuneGrid=tunegrid, trControl=control)
      print(rf_gridsearch)
      pred<- predict(rf_gridsearch, train)
      table(pred, train$rating)
      pred<- predict(rf_gridsearch, test)
      table(pred, test$rating)
      rightPred <- pred == test$rating
      accuracy <- sum(rightPred)/nrow(test)
      p<-plot(rf_gridsearch)
      
    }
    else if(input$options== "Linear Regression")
    {
      numeric_attributes<-sapply(movies,is.numeric)
      
      #attributes containing only numeric data
      movies_numeric <- movies[,numeric_attributes]
      
      #removing missing values
      movies_missing_removed <- na.omit(movies_numeric)
      
      #movie_data scaled
      scaled_movie_data <- data.frame(lapply(movies_missing_removed, function(x) scale(x, center = FALSE, scale = max(x, na.rm = TRUE))))  
      
      index_start<- 1:nrow(scaled_movie_data)
      
      #For 50-50
      #splitting into training and test data 
      index_test50 <- sample(index_start, trunc(length(index_start)*0.50))
      test_data50 <- scaled_movie_data[index_test50,]
      
      index_train50 <- sample(index_start, trunc(length(index_start)*0.50))
      
      train_data50 <- scaled_movie_data[index_train50,]
      
      
      #create model using linear regression
      
      linear_model <-glm(imdb_score ~., data = train_data50)
      
      #applying the model created on test data to obtain predictions
      linear_predictions1 <- predict(linear_model, test_data50)
      
      # plot(linear_predictions1,test_data50$imdb_score,col=c("red","green"), xlab="Predicted",ylab="Actual")
      
      #root mean square error
      mean((test_data50$imdb_score - linear_predictions1)^2) #changed predictions to predictions1
      
      
      #For 60-40
      #splitting into training and test data 
      index_test40 <- sample(index_start, trunc(length(index_start)*0.40))
      test_data40 <- scaled_movie_data[index_test40,]
      
      index_train60 <- sample(index_start, trunc(length(index_start)*0.60))
      
      train_data60 <- scaled_movie_data[index_train60,]
      
      
      #create model using linear regression
      
      linear_model <-glm(imdb_score ~., data = train_data60)
      
      #applying the model created on test data to obtain predictions
      linear_predictions2 <- predict(linear_model, test_data40)
      
      #plot(linear_predictions,test_data40$imdb_score,col=c("red","green"), xlab="Predicted",ylab="Actual")
      
      #root mean square error
      mean((test_data40$imdb_score - linear_predictions2)^2) 
      
      #For 75-25
      #splitting into training and test data 
      index_test25 <- sample(index_start, trunc(length(index_start)*0.25))
      test_data25 <- scaled_movie_data[index_test25,]
      
      index_train75 <- sample(index_start, trunc(length(index_start)*0.75))
      
      train_data75 <- scaled_movie_data[index_train75,]
      
      
      #create model using linear regression
      
      linear_model <-glm(imdb_score ~., data = train_data75)
      
      #applying the model created on test data to obtain predictions
      linear_predictions3 <- predict(linear_model, test_data25)
      
      #plot(linear_predictions,test_data25$imdb_score,col=c("red","green"), xlab="Predicted",ylab="Actual")
      
      #root mean square error
      mean((test_data25$imdb_score - linear_predictions3)^2) 
      
      
      #For 80-20
      #splitting into training and test data 
      index_test20 <- sample(index_start, trunc(length(index_start)*0.20))
      test_data20 <- scaled_movie_data[index_test20,]
      
      index_train80 <- sample(index_start, trunc(length(index_start)*0.80))
      
      train_data80 <- scaled_movie_data[index_train80,]
      
      
      #create model using linear regression
      
      linear_model <-glm(imdb_score ~., data = train_data80)
      
      #applying the model created on test data to obtain predictions
      linear_predictions4 <- predict(linear_model, test_data20)
      
      #plot(linear_predictions,test_data20$imdb_score,col=c("red","green"), xlab="Predicted",ylab="Actual")
      
      #root mean square error
      mean((test_data20$imdb_score - linear_predictions4)^2) 
      
      par(mfrow=c(2,2))
      plot(linear_predictions1,test_data50$imdb_score,col=rainbow(2), xlab="Predicted",ylab="Actual", main="Test data 50")
      plot(linear_predictions2,test_data40$imdb_score,col=rainbow(2), xlab="Predicted",ylab="Actual", main= "Test data 40")
      plot(linear_predictions3,test_data25$imdb_score,col=rainbow(2), xlab="Predicted",ylab="Actual", main="Test data 25")
      plot(linear_predictions4,test_data20$imdb_score,col=rainbow(2), xlab="Predicted",ylab="Actual",main="Test data 20")
      
    }
    print(p)
    
  }, height=700)
  output$info <-renderText(
    if(input$options== "Random Forest")
    {
      set.seed(0)
      movies_with_good_variables = movies[, c("imdb_score",
                                              "director_facebook_likes", 
                                              "cast_total_facebook_likes", 
                                              "actor_1_facebook_likes",
                                              "actor_2_facebook_likes",
                                              "actor_3_facebook_likes",
                                              "movie_facebook_likes", 
                                              "facenumber_in_poster",
                                              "gross",
                                              "budget")]
      mvs = na.omit(movies_with_good_variables)
      #finding mean imdb score
      mean_rating <- mean(mvs$imdb_score)
      mvs$rating <- ifelse(mvs$imdb_score < (floor(mean_rating)-1),'poor',ifelse(mvs$imdb_score > ceiling(mean_rating),'good', 'average'))
      #convert to factors 
      mvs$rating <- as.factor(mvs$rating)
      #66.32% of data is recommended to be ideal training size for random forest hence 36.8% for test
      index = sample(1:nrow(mvs), size=0.368*nrow( mvs))
      test = mvs[index,]
      train = mvs[-index,]
      #control <- trainControl(method="repeatedcv", number=2, repeats=2, search="grid")
      set.seed(7)
      seed <- 7
      metric <- "Accuracy"
      set.seed(seed)
      #mtry <- sqrt(ncol(train))
      customRF <- list(type = "Classification", library = "randomForest", loop = NULL)
      customRF$parameters <- data.frame(parameter = c("mtry", "ntree"), class = rep("numeric", 2), label = c("mtry", "ntree"))
      customRF$grid <- function(x, y, len = NULL, search = "grid") {}
      customRF$fit <- function(x, y, wts, param, lev, last, weights, classProbs, ...) {
        randomForest(x, y, mtry = param$mtry, ntree=param$ntree, ...)
      }
      customRF$predict <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
        predict(modelFit, newdata)
      customRF$prob <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
        predict(modelFit, newdata, type = "prob")
      customRF$sort <- function(x) x[order(x[,1]),]
      customRF$levels <- function(x) x$classes
      tunegrid <- expand.grid(.mtry=c(2:4), .ntree=c(100, 200))
      rf_gridsearch <- train(rating ~. -imdb_score, data=train, method=customRF, metric=metric, tuneGrid=tunegrid)
      print(rf_gridsearch)
      pred<- predict(rf_gridsearch, train)
      table(pred, train$rating)
      pred<- predict(rf_gridsearch, test)
      table(pred, test$rating)
      rightPred <- pred == test$rating
      accuracy <- sum(rightPred)/nrow(test)
      p<- "Random forest accuracy :"
      p<- paste(p, accuracy," ")
      print (p)
    }
    else if(input$options== "Linear Regression")
    {
      numeric_attributes<-sapply(movies,is.numeric)
      
      #attributes containing only numeric data
      movies_numeric <- movies[,numeric_attributes]
      
      #removing missing values
      movies_missing_removed <- na.omit(movies_numeric)
      
      #movie_data scaled
      scaled_movie_data <- data.frame(lapply(movies_missing_removed, function(x) scale(x, center = FALSE, scale = max(x, na.rm = TRUE))))  
      
      index_start<- 1:nrow(scaled_movie_data)
      
      #For 50-50
      #splitting into training and test data 
      index_test50 <- sample(index_start, trunc(length(index_start)*0.50))
      test_data50 <- scaled_movie_data[index_test50,]
      
      index_train50 <- sample(index_start, trunc(length(index_start)*0.50))
      
      train_data50 <- scaled_movie_data[index_train50,]
      
      
      #create model using linear regression
      
      linear_model <-glm(imdb_score ~., data = train_data50)
      
      #applying the model created on test data to obtain predictions
      linear_predictions1 <- predict(linear_model, test_data50)
      
      # plot(linear_predictions1,test_data50$imdb_score,col=c("red","green"), xlab="Predicted",ylab="Actual")
      
      #root mean square error
      mean((test_data50$imdb_score - linear_predictions1)^2) #changed predictions to predictions1
      
      
      #For 60-40
      #splitting into training and test data 
      index_test40 <- sample(index_start, trunc(length(index_start)*0.40))
      test_data40 <- scaled_movie_data[index_test40,]
      
      index_train60 <- sample(index_start, trunc(length(index_start)*0.60))
      
      train_data60 <- scaled_movie_data[index_train60,]
      
      
      #create model using linear regression
      
      linear_model <-glm(imdb_score ~., data = train_data60)
      
      #applying the model created on test data to obtain predictions
      linear_predictions2 <- predict(linear_model, test_data40)
      
      #plot(linear_predictions,test_data40$imdb_score,col=c("red","green"), xlab="Predicted",ylab="Actual")
      
      #root mean square error
      mean((test_data40$imdb_score - linear_predictions2)^2) 
      
      #For 75-25
      #splitting into training and test data 
      index_test25 <- sample(index_start, trunc(length(index_start)*0.25))
      test_data25 <- scaled_movie_data[index_test25,]
      
      index_train75 <- sample(index_start, trunc(length(index_start)*0.75))
      
      train_data75 <- scaled_movie_data[index_train75,]
      
      
      #create model using linear regression
      
      linear_model <-glm(imdb_score ~., data = train_data75)
      
      #applying the model created on test data to obtain predictions
      linear_predictions3 <- predict(linear_model, test_data25)
      
      #plot(linear_predictions,test_data25$imdb_score,col=c("red","green"), xlab="Predicted",ylab="Actual")
      
      #root mean square error
      mean((test_data25$imdb_score - linear_predictions3)^2) 
      
      
      #For 80-20
      #splitting into training and test data 
      index_test20 <- sample(index_start, trunc(length(index_start)*0.20))
      test_data20 <- scaled_movie_data[index_test20,]
      
      index_train80 <- sample(index_start, trunc(length(index_start)*0.80))
      
      train_data80 <- scaled_movie_data[index_train80,]
      
      
      #create model using linear regression
      
      linear_model <-glm(imdb_score ~., data = train_data80)
      
      #applying the model created on test data to obtain predictions
      linear_predictions4 <- predict(linear_model, test_data20)
      
      #plot(linear_predictions,test_data20$imdb_score,col=c("red","green"), xlab="Predicted",ylab="Actual")
      
      #root mean square error
      mean((test_data20$imdb_score - linear_predictions4)^2) 
      
      par(mfrow=c(2,2))
      plot(linear_predictions1,test_data50$imdb_score,col=rainbow(2), xlab="Predicted",ylab="Actual", main="Test data 50")
      plot(linear_predictions2,test_data40$imdb_score,col=rainbow(2), xlab="Predicted",ylab="Actual", main= "Test data 40")
      plot(linear_predictions3,test_data25$imdb_score,col=rainbow(2), xlab="Predicted",ylab="Actual", main="Test data 25")
      plot(linear_predictions4,test_data20$imdb_score,col=rainbow(2), xlab="Predicted",ylab="Actual",main="Test data 20")
  
    }
  )
  
}