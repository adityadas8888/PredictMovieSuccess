# PredictMovieSuccess
<i>This project is an ongoing prototype to predict a movie's success based on various factors.
 The dependant factors/attributes for the Machine Learning model are currently Production House Investmen for the Movie,
IMDb Score, and Movie Gross.
Sentiment Analysis using twitter is also being tested as a factor.
 <b>Phase 1:(Completed)</b><br>
We are using basic factors like Production House investment, IMDb Score to predict the release month. Such a model and bare bone attributes were used, because a new actor or a new director gave us outlier values and threw exceptions.
Current Accuracy Range:- 71-98%
<br>
 <b>Phase 2:(Ongoing)</b>
In this phase we are trying to incorporate current population sentiments using Facebook and Twitter. 
Using the TwitteR API to pull sentiments for a particular keyword.

</i>


<b>Initial Literature Survey<b>

<b>ABSTRACT</b>

<br>
With India being the churner of the largest number of motion pictures and third in the world in terms of revenue, movies are a part and parcel of every Indian’s life.  The budget of these movies is usually in the order of crores of Rupees, making their box ofﬁce success utterly imperative for the survival of the industry. Having the knowledge that which movies are likely to make headway and which are likely to fail before the release could support the production houses greatly as it will enable them to focus their advertising campaigns which itself costs crores. 
This analysis will also empower the producers as to what would be the most apt time to release a movie according to the state of the overall market.
 Release time being wholly essential to the success of the movie, studios decide and pre-announce the envisaged release date long before the actual reveal of their upcoming movies. This choice of dates and then the following changes are tactical in nature taking into deliberation various factors like release of competing movies, holidays, sports event, natural disaster etc. Machine learning mixed with predictive analytics using previously archived data and their box office performance can help us identify the most apt release date for maximizing the revenue.
Forecasting a movie’s opening success is a laborious task, as it does not always depend on its quality. External factors such as competing movies, time of the year and even weather inﬂuence the success as these factors impact the Box-office sales for the moving opening. Nevertheless, predicting a movie’s opening success in terms of Box-office ticket sales is essential for a movie studio, to plan its cost and make the work proﬁtable
 Machine learning algorithms are widely used to make predictions such as growth in the stock market, demand for products, nature of tumors, etc. This project presents a brief study on the viability of our project and the types of reinforced Machine Learning models we might use to predict movie success rates and time of release.



<b>INTRODUCTION</b>
<br>
With the advent of AI and widespread use of machine learning, we are at the epoch of a new era in computing. The field of machine learning has matured by leaps and bounds. We are able to guess diseases in human beings long before they become fatal, predict and avert natural disasters. We cannot even start contemplating the endless areas machine learning could help humanity to solve their umpteen problems.
Predictive TTM Optimization plans to tap into one of the largest sectors of entertainment available today. Though the box office looks innocuous enough to seem like just an industry that deals with the fun and entertainment, it is far from the truth. The film industry employs lakhs of people in our country itself. They are usually at the forefront of cutting edge technology, funding expensive, next-gen techniques. Techniques that other sectors cannot invest in due to the unavailability of funds. And because the film industry is cash strapped, they end up indirectly funding a lot of technologies that go onto become next big thing. Things like 3D movies, high pressure cameras are one of few wonders kick-started by the film industry. 
Thus, keeping the interests of the film industry is a very crucial thing. We have therefore decided upon a Machine learning project that predicts the success of films, taking into consideration a lot of factors like the track history of the film production house, actors, directors, release time, competing films etc.
We are taking the following non-exhaustive dataset for our ML model: -
•	Trending data about the said movie from Social media like Twitter.
•	Archive data analysis of the components (actor, director and more) of the movie from IMDb and Rotten Tomatoes. 
•	Demographic aspects where the movie is planning to release.
•	Clashing events or movies and their previous track records.



<b>BLOCK DIAGRAM</b>

<br>
<b>PROCESS MODEL</b>
<br>
<p align="center">
  <img src="https://github.com/adityadas8888/PredictMovieSuccess/blob/master/model.png" width="350"/>
</p>
<b>MODEL COMPONENTS</b>: -
<br>
DATA  ACQUISITION
<br>
 <p align="center">
  <img src="https://github.com/adityadas8888/PredictMovieSuccess/blob/master/data%20acqu.jpg" width="350"/>
</p>
This is the data acquisition part of the ML model. The initial dataset to be used will be collected from sources as mentioned above. It will consist of movies that were released from 2000 to 2017. For making more precise predictions, we will reﬁne the movie list by removing regional movies. Only movies with the English or Hindi medium of language and which have reviews in English will be selected, in the expectation that it will form a dataset for precise forecast. We will be removing movies which don’t have any information about box ofﬁce details. 
<p align="left">
  <img src="https://github.com/adityadas8888/PredictMovieSuccess/blob/master/cleaning.png" width="350"/>
</p>
<p align="right">
  <img src="https://github.com/adityadas8888/PredictMovieSuccess/blob/master/cleaning2.png" width="350"/>
</p>
<b>DATA CLEANING</b>
The data  obtained is highly susceptible to noise, missing and inconsistent data due to the huge size and their likely origin from multiple/heterogeneous sources. The main problem with datasets will be missing ﬁelds. To overcome this missing ﬁeld problem we can adopt a method which uses a measure of central tendency for the attribute. We can use both mean and median as central tendency.
<br>
<b>DATA DIVISION</b>
<br>
The data after cleaning and processing will be divided into three parts. Training data, testing data and holdout data. The training data, as the name suggests is the data used to train the classification models. The testing data is used on the model after it has been trained to give a rough idea of the efficiency of our model. Finally, after re-iterating both the test and training data, we will use the holdout data. This data has never been exposed to the model, so it will give an unbiased solution. The ratio of training:testing:holdout data can vary according to the models we use.
<br>
<b>CLASSIFICATION/TRAINING MODELS</b><br>
We are using a multitude of classification models to measure results against each other.
The algorithms and their variants that might be implemented using TensorFlow are described below - 
• Decision trees: Deep tree, medium tree, and shallow tree 
• Support vector machines: Linear SVM
• Nearest neighbor classiﬁers: Fine KNN, medium KNN, coarse KNN, cosine KNN, and cubic KNN

