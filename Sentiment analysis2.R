#Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre-10')
library(twitteR)
library(rJava)
library(stringr)
library(twitteR)
library(xlsx)
library(plyr)
api_key<- "EamQYfRQy3SPDRDZObIZ0vWzO"
api_secret <- "Dag68LESJhelSgDWCxpIeAMzSeoXO3hKWtBUhcbBuVaBG0OpA9"
access_token <- "981530225803608064-pViHPn9pvtJTZlX8WXkRXk5mzW4zL8p"
access_token_secret <-"gZ7ajWGt3vFJVVTbKolmEgyDIEEvL7nErzB5gJH0qtSAZ"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
options(max.print=6000)
#neg = c(neg, 'fat')
score.sentiment = function(tweets, pos.words, neg.words)
  
{
  
  require(plyr)
  require(stringr)
  
  scores = laply(tweets, function(tweet, pos.words, neg.words) {
    
    
    
    tweet = gsub('https://','',tweet) # removes https://
    tweet = gsub('http://','',tweet) # removes http://
    tweet=gsub('[^[:graph:]]', ' ',tweet) ## removes graphic characters 
    #like emoticons 
    tweet = gsub('[[:punct:]]', '', tweet) # removes punctuation 
    tweet = gsub('[[:cntrl:]]', '', tweet) # removes control characters
    tweet = gsub('\\d+', '', tweet) # removes numbers
    tweet=str_replace_all(tweet,"[^[:graph:]]", " ") 
    
    tweet = tolower(tweet) # makes all letters lowercase
    
    word.list = str_split(tweet, '\\s+') # splits the tweets by word in a list
    
    words = unlist(word.list) # turns the list into vector
    
    pos.matches = match(words, pos.words) ## returns matching 
    #values for words from list 
    neg.matches = match(words, neg.words)
    
    pos.matches = !is.na(pos.matches) ## converts matching values to true of false
    neg.matches = !is.na(neg.matches)
    
    score = sum(pos.matches) - sum(neg.matches) # true and false are 
    #treated as 1 and 0 so they can be added
    
    return(score)
    
  }, pos.words, neg.words )
  
  scores.df = data.frame(score=scores, text=tweets)
  
  return(scores.df)
  
}

neg = scan("negative-words.txt", what="character", comment.char=";")
pos = scan("positive-words.txt", what="character", comment.char=";")

tweets = searchTwitter('Volvo trucks',n=5000,lang = 'en')
tweets
Tweets.text = laply(tweets,function(t)t$getText()) # gets text from Tweets
analysis = score.sentiment(Tweets.text, pos, neg) # calls sentiment function
hist(analysis$score)
