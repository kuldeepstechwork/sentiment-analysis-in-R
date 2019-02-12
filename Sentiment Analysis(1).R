######-- Sentiment Analysis --######

# Use the ConsumerKey, ConsumerSecret, AccessToken and 
#AccessTokenSecret according to your application.
##https://dev.twitter.com/

library(twitteR)

consumerKey <- "ES6sebmcdWIP1S70gEirYbZri"
consumerSecret <- "ZtUqF5dYaMs5riHZCNzZOn3VL1IQQxrzSJ0HfQzNlByylOCzlg"
accessToken <- "2853768842-t25cpC4Ve9KcDgVTqwZqVIwdXRSeLD0xdkGloy1"
accessTokenSecret <- "ErITskWUTUAvZsHW7IzLueGqeEcDMlkHymdhFAFRRotMs"

setup_twitter_oauth(consumerKey, consumerSecret, accessToken, accessTokenSecret)
tweets_geolocated <- searchTwitter("#Demonitization", n=1000, lang="en",
                                   geocode = "28.459497,77.026638,500mi", 
                                   since = "2016-12-01")
tweets_geolocated.df <- twListToDF(tweets_geolocated)
tweets_geolocated.df[1:5,1:4]

#setup_twitter_oauth (consumerKey, consumerSecret, accessToken, accessTokenSecret)

tweets <- searchTwitter("#Demonetization", n=2000, lang="en",
                        #geocode = "28.459497,77.026638,500mi", 
                        since = "2016-11-08") 
# top 300 tweets that contain search term

tweet_txt = lapply(tweets, function(x) x$getText())
tweet_txt1= twListToDF(tweets)
tweet_txt2 = tweet_txt1[,"text"]

head(tweet_txt)

clean.text <- function(some_txt)
{
  some_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", some_txt)
  some_txt = gsub("@\\w+", "", some_txt)
  some_txt = gsub("[[:punct:]]", "", some_txt)
  some_txt = gsub("[[:digit:]]", "", some_txt)
  some_txt = gsub("http\\w+", "", some_txt)
  some_txt = gsub("[ \t]{2,}", "", some_txt)
  some_txt = gsub("^\\s+|\\s+$", "", some_txt)
  some_txt = gsub("amp", "", some_txt)
  # define "tolower error handling" function
  try.tolower = function(x)
  {
    y = NA
    try_error = tryCatch(tolower(x), error=function(e) e)
    if (!inherits(try_error, "error"))
      y = tolower(x)
    return(y)
  }
  
  some_txt = sapply(some_txt, try.tolower)
  some_txt = some_txt[some_txt != ""]
  names(some_txt) = NULL
  some_txt <- strsplit(some_txt," ")
  return(some_txt)
}

tweet_clean = clean.text(tweet_txt)

head(tweet_clean,5)

setwd("C:/Users/Kuldeep/Desktop/DEXLAB/sentiment analysis")
positive=scan('positive-words.txt',what='character',comment.char=';')
negative=scan('negative-words.txt',what='character',comment.char=';')
positive[30:40]

negative[500:510]

#Additional words can be added or removed from the dictionaries.
positive=c(positive,"cloud")
negative=negative[negative!="cloud"]

#for counting the positive matching words.
returnpscore=function(t) {
  pos.match=match(t,positive)
  pos.match=!is.na(pos.match)
  pos.score=sum(pos.match)
  return(pos.score)
}
positive.score=lapply(tweet_clean,function(x) returnpscore(x))

head(positive.score)
pcount=0
for (i in 1:length(positive.score)) {
  pcount=pcount+positive.score[[i]]
}
pcount

#for counting the negative matching words.
returnnscore=function(twet) {
  neg.match=match(twet,negative)
  neg.match=!is.na(neg.match)
  neg.score=sum(neg.match)
  return(neg.score)
}
negative.score=lapply(tweet_clean,function(x) returnnscore(x))

ncount=0
for (i in 1:length(negative.score)) {
  ncount=ncount+negative.score[[i]]
}
ncount

poswords=function(t){
  pmatch=match(t,positive)
  posw=positive[pmatch]
  posw=posw[!is.na(posw)]
  return(posw)
}

negwords=function(t){
  nmatch=match(t,negative)
  negw=negative[nmatch]
  negw=negw[!is.na(negw)]
  return(negw)
}

words=NULL
pdatamart=data.frame(words)

for (t in tweet_clean) {
  pdatamart=c(poswords(t),pdatamart)
}
head(pdatamart,10)

words=NULL
ndatamart=data.frame(words)

for (t in tweet_clean) {
  ndatamart=c(negwords(t),ndatamart)
}
head(ndatamart,10)

pwords <- unlist(pdatamart)
nwords <- unlist(ndatamart)

dpwords=data.frame(table(pwords))
dnwords=data.frame(table(nwords))

library(dplyr)
dpwords = dpwords%>%
  mutate(pwords=as.character(pwords))%>%
  filter(Freq>10)

## negative 
dnwords = dnwords%>%
  mutate(nwords=as.character(nwords))%>%
  filter(Freq>10)


library(ggplot2)
ggplot(dpwords,aes(pwords,Freq))+
  geom_bar(stat="identity",fill="lightblue")+
  theme_bw()+
  geom_text(aes(pwords,Freq,label=Freq),size=4)+
  labs(x="Major Positive Words", y="Frequency of Occurence",
       title=paste("Major Positive Words and Occurence in \n '","Demonetization","' twitter feeds, n =",2000))+
  geom_text(aes(1,5,label=paste("Total Positive Words :",pcount)),size=4,hjust=0)+
  theme(axis.text.x=element_text(angle=45))

## negative plot

ggplot(dnwords,aes(nwords,Freq))+
  geom_bar(stat="identity",fill="lightblue")+
  theme_bw()+
  geom_text(aes(nwords,Freq,label=Freq),size=4)+
  labs(x="Major Negative Words", y="Frequency of Occurence",
       title=paste("Major Negative Words and Occurence in \n '","Demonetization","' twitter feeds, n =",2000))+
  geom_text(aes(1,5,label=paste("Total Negative Words :",ncount)),size=4,hjust=0)+
  theme(axis.text.x=element_text(angle=45))
