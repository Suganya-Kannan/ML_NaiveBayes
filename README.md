# ML_NaiveBayes
Filtering mobile phone spam with the naive Bayes algorithm

Bayes has been used successfully for email spam filtering, it seems likely that it could also be applied to SMS spam. However, 
relative to email spam, SMS spam poses additional challenges for automated filters. SMS messages are often limited to 160 
characters, reducing the amount of text that can be used to identify whether a message is junk. The limit, combined with small 
mobile phone keyboards, has led many to adopt a form of SMS shorthand lingo, which further blurs the line between legitimate 
messages and spam. Let's see how well a simple naive Bayes classifier handles these challenges.

The naive Bayes classifier is often used for text classification. To illustrate its effectiveness, we employed naive Bayes on a 
classification task involving filtering spam SMS messages. Preparing the text data for analysis required the use of specialized R 
packages for text processing and visualization. Ultimately, the model was able to classify nearly 98 percent of all SMS messages 
correctly as spam or ham.
