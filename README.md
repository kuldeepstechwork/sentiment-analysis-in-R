#Sentiment Analysis on Twitter Data

This project involves performing sentiment analysis on Twitter data related to the #Demonetization hashtag. The analysis aims to determine the sentiment (positive, negative or neutral) of tweets related to the topic.

The project involves using the twitteR package in R to extract 2000 tweets related to #Demonetization from Twitter. The extracted tweets are then preprocessed by removing URLs, mentions, punctuations, and numbers.

The sentiment of each tweet is then determined by matching the words in the tweet with a pre-defined list of positive and negative words. The final output is a visualization of the sentiment of tweets in the form of a pie chart and a bar graph.

Project Files:-
sentiment_analysis.R - R script that performs the sentiment analysis on the Twitter data.
positive-words.txt - List of positive words used in the sentiment analysis.
negative-words.txt - List of negative words used in the sentiment analysis.

Requirements:-
R programming language
twitteR package
dplyr package

Setup:-
Install R programming language (https://www.r-project.org/)
Install the twitteR and dplyr packages using the following commands in the R console:
R
Copy code
install.packages("twitteR")
install.packages("dplyr")
Create a Twitter account and create an app to obtain the ConsumerKey, ConsumerSecret, AccessToken and AccessTokenSecret.
Replace the placeholders with your own ConsumerKey, ConsumerSecret, AccessToken and AccessTokenSecret in the sentiment_analysis.R file.
Run the sentiment_analysis.R file to perform the sentiment analysis on the Twitter data.

Output:-
The script generates a pie chart and a bar graph to visualize the sentiment of the tweets. The pie chart shows the percentage of tweets with positive, negative and neutral sentiment. The bar graph shows the number of positive, negative and neutral tweets.







