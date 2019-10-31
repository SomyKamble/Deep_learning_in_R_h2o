library(h2o)

h2o.init()
#to see the h2o flow in your localhost type : http://127.0.0.1:54321
library(MASS)

Datafram<-Boston

scale.dat<-scale(Datafram)

colMeans(scale.dat)


apply(scale.dat,2,sd)
scale.dat<-as.data.frame(scale.dat)

y<-"medv"

x<-setdiff(colnames(scale.dat),y)

ind<-sample(1:nrow(Datafram),400)

trainDF<-Datafram[ind,]
testDF<-Datafram[-ind,]


?h2o.deeplearning

model<-h2o.deeplearning(x=x,y=y,seed = 1234,training_frame = as.h2o(trainDF),nfolds = 3,stopping_rounds = 7,epochs = 500,overwrite_with_best_model = T
                        ,activation = 'Tanh',input_dropout_ratio = 0.1,hidden = c(10,10,10),l1 = 6e-4,loss = 'Automatic',distribution = "AUTO",
                        stopping_metric = 'MSE')

plot(model)


pred<-as.data.frame(predict(model,as.h2o(testDF)))
str(pred)

plot(testDF$medv,pred$predict)
abline(0,1,col='black')