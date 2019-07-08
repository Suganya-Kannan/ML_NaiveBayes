##--------Naive Bayes------------

smsDataRaw <- read.csv("D:/Way to go as DS/ML/Data/sms_spam.csv", stringsAsFactors = F)
str(smsDataRaw)
smsDataRaw$type <- factor(smsDataRaw$type)
table(smsDataRaw$type)
prop.table(table(smsDataRaw$type))
install.packages("tm") ## for text mining tools
library(tm)
print(vignette("tm"))
## Corpus() - creates the object to store the text doc

sms_Corpus <- Corpus(VectorSource(smsDataRaw$text)) 
print(sms_Corpus)
inspect(sms_Corpus[1:4])

## converting all of the SMS messages to lowercase and remove any numbers
## Data Cleaning

corpus_clean <- tm_map(sms_Corpus, tolower)
corpus_clean <- tm_map(corpus_clean, removeNumbers)
corpus_clean <- tm_map(corpus_clean, removeWords, stopwords())
corpus_clean <- tm_map(corpus_clean, removePunctuation)
corpus_clean <- tm_map(corpus_clean, stripWhitespace)

inspect(sms_Corpus[1:3])
inspect(corpus_clean[1:3])

## converting into sparse data matrix. ROWS - Sms Msgs, COL - Words

sms_dtm <- DocumentTermMatrix(corpus_clean)


## creating training AND testing dataset

## Splitting raw data
sms_raw_train <- smsDataRaw[1:4169,]
sms_raw_test  <- smsDataRaw[4170:5559,]

## splitting doc-term-matrix

sms_dtm_train <- sms_dtm[1:4169,]
sms_dtm_test  <- sms_dtm[4170:5559,]

## splitting the corpus

sms_corpus_train <- corpus_clean[1:4169]
sms_corpus_test  <- corpus_clean[4170:5559]

## To confirm that the subsets are representative 
## ..of the complete set of SMS data.

prop.table(table(sms_raw_train$type))
prop.table(table(sms_raw_test$type))
save.image()

## visualizing text data

install.packages("wordcloud")
library(wordcloud)
wordcloud(sms_corpus_train, min.freq = 40, random.order = F)
wordcloud(sms_corpus_train, min.freq = 40, random.order = T)

spam <- subset(sms_raw_train, type == "spam")
ham <- subset(sms_raw_train, type == "ham")

wordcloud(spam$text, max.words = 40, scale = c(3, 0.5), random.order = F)
wordcloud(ham$text, max.words = 40, scale = c(3, 0.5), random.order = F)


library(tm)
findFreqTerms(sms_dtm_train, 5)  ## should contain at least 0.1 percent
## of training data [ 0.1/100*4169 = 4.16 ]

sms_dict <- findFreqTerms(sms_dtm_train, 5)
sms_train <- DocumentTermMatrix(sms_corpus_train, list(dictionary = sms_dict))
sms_test <- DocumentTermMatrix(sms_corpus_test, list(dictionary = sms_dict))

## 

convert_counts <- function(x){
  x <- ifelse(x>0,1,0)
  x <- factor(x, levels = c(0,1), labels = c("No","Yes"))
  return(x)
}
sms_train <- apply(sms_train, MARGIN = 2, FUN = convert_counts)
sms_test <- apply(sms_test, MARGIN = 2, FUN = convert_counts)

sms_train                  

## Naive bayes algorithm
## 1) Training the model
library("e1071")
sms_clasifier <- naiveBayes(sms_train, sms_raw_train$type)

## 2) Evaluating model performance
sms_test_predict <- predict(sms_clasifier, sms_test)
library(gmodels)
CrossTable(sms_test_predict, sms_raw_test$type, 
           prop.chisq = F, prop.t = F, prop.r = F,
           dnn = c("Predicted", "Actual"))

## 3) Improving model performance

sms_clasifier2 <- naiveBayes(sms_train, sms_raw_train$type, laplace = 1)
sms_test_predict2 <- predict(sms_clasifier2, sms_test)
CrossTable(sms_test_predict2, sms_raw_test$type, 
           prop.chisq = F, prop.t = F, prop.r = F,
           dnn = c("predicted", "actual"))
