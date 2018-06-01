# Using polynomial Regression for Movies dataset

# Importing the dataset
dataset = read.csv('step1.csv')

dataset =read.csv('movie_metadata.csv')

#Taking care of missing data in our  Dataset

dataset$budget = ifelse(is.na(dataset$budget),
                        ave(dataset$budget, FUN =function(x) mean(x, na.rm = TRUE)),
                        dataset$budget)

dataset$duration = ifelse(is.na(dataset$duration),
                       ave(dataset$duration, FUN =function(x) mean(x, na.rm = TRUE)),
                       dataset$duration)


#-----step 2------
dataset$gross = ifelse(is.na(dataset$gross),
                       ave(dataset$gross, FUN =function(x) mean(x, na.rm = TRUE)),
                       dataset$gross)


# Fitting Linear Regression to the Dataset
lin_reg = lm(formula = imdb_score ~ .,
             data = dataset)




#graph
library(ggplot2)
qplot(imdb_score, gross , data = dataset)


#STEP 1 ---->>>   this is for imdb without gross and month 
lin_reg = lm(formula = imdb_score ~ .,
             data = dataset)



# #iron man 2
# y_pred = predict(lin_reg, data.frame(duration = 124,budget = 200000000 )) #95.8
# 
# 
# 
# #I love you man 
# y_pred = predict(lin_reg, data.frame(duration = 105,budget = 40000000)) #90
# 
# 
# #40 year old virgin
# y_pred = predict(lin_reg, data.frame(duration = 116,budget = 26000000)) #91.6
# 
# #shawshank redemption
# y_pred = predict(lin_reg, data.frame(duration = 128,budget = 30000000)) #72.04
# 
# 
# #ANON
# y_pred = predict(lin_reg, data.frame(duration = 100,budget = 20000000)) #98.4
# 
# 
# 
# #EARLY MAN
# y_pred = predict(lin_reg, data.frame(duration = 88,budget = 50000000))





#Maleficent
y_pred = predict(lin_reg, data.frame(duration = 97,budget = 180000000)) #6.2


#Die hard
y_pred = predict(lin_reg, data.frame(duration = 128,budget = 110000000)) #6.7

#Deadpool 2
y_pred = predict(lin_reg, data.frame(duration = 119,budget = 110000000)) #6.7





# # Predicting the gross with predicted imdb
# lin_reg = lm(formula = gross ~ .,
#              data = dataset)
# 
# y_pred = predict(lin_reg, data.frame(duration = 109,budget = 42000000 ,imdb_score = 7.2 , release_month = 3 ))
# 






#  predicting release month after predicting imdb and gross


lin_reg = lm(formula = release_month ~ .,
             data = dataset)

#Maleficent
y_pred = predict(lin_reg, data.frame(duration = 97,budget = 180000000 ,imdb_score = 6.2 , gross = 147809121)) #6.2      #The actual month is 5 that is may 

y_pred
# live free or Die hard
y_pred = predict(lin_reg, data.frame(duration = 128,budget = 110000000 ,imdb_score = 6.7 , gross = 123863211 )) #6.7    #the actual month is 6 that is june
y_pred










#40 YEAR OLD VIRGIN
y_pred = predict(lin_reg, data.frame(duration = 116,budget = 26000000 ,imdb_score = 7.1 , gross = 109449237)) .

# INFINITY WAR
y_pred = predict(lin_reg, data.frame(duration = 159,budget = 400000000 ,imdb_score = 8.9 , gross = 1275312103))

#BACK TO THE FUTURE
y_pred = predict(lin_reg, data.frame(duration = 156,budget = 19000000 ,imdb_score = 8.5 , gross = 381109762))

#TERMINATOR 2
y_pred = predict(lin_reg, data.frame(duration = 137,budget = 102000000 ,imdb_score = 8.5 , gross = 315000000))


#John carter (flop)
y_pred = predict(lin_reg, data.frame(duration = 132,budget = 250000000 ,imdb_score = 6.6 , gross = 73078100))

#47 ronin (flop)
y_pred = predict(lin_reg, data.frame(duration = 128,budget = 175000000 ,imdb_score = 6.3 , gross = 38362475))





















lm(formula = log(gross) ~ log(budget) + log(imdb_score) + log(duration) +
     log(release_month), data = dataset)
























# #TIGER ZINDA HAI
# y_pred = predict(lin_reg, data.frame(duration = 161,budget = 20000000 ,imdb_score = 6.3, gross = 87320000))
# 
# #3 IDIOTS 
# y_pred = predict(lin_reg, data.frame(duration = 170,budget = 8162000 ,imdb_score = 8.4 , gross = 80000000))


# # Fitting Polynomial Regression to the Dataset
# dataset$imdb_score2 = dataset$imdb_score^2
# dataset$budget2 = dataset $budget^2
# dataset$imdb_score3 = dataset$imdb_score^3
# dataset$budget3 = dataset $budget^3
# dataset$imdb_score4 = dataset$imdb_score^4
# dataset$budget4 = dataset $budget^4
# poly_reg = lm(formula = gross ~ .,
#               data = dataset)

# Visualising the Linear Regression results
# library(ggplot2)
# ggplot() +
#   geom_point(aes(x = dataset$budget, y = dataset$gross),
#              colour = 'red') +
#   geom_line(aes(x = dataset$budget, y =predict(lin_reg, newdata = dataset)),
#             colour = 'blue') +
#   ggtitle('Graphs for  vs profits (Linear Regression)') +
#   xlab('Budget') +
#   ylab('Gross/Profits')

