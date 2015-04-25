Random Forest Prediction of Forest Cover Types
========================================================
author: C. Brown
date: April 25, 2015

Background
========================================================

In this app six environmental variables are used to predict the type of forest cover in the environment.  Such predictions can be useful in land management issues, e.g. prediction of fire hazard in a particular location.

The app allows the user to

- specify and change values for 6 environmental predictors

- specify and change the sample size for building a random forest model from the original data set

- view and update the likelihoods predicted by the model that the environment described by the specified variables has any of 7 forest cover types.



```r
set.seed(1234)
thesplit <- createDataPartition(data$CoverType,p=1000/dim(data)[1],list=FALSE)
tr <- data[thesplit,]
te <- data[-thesplit,]
bigmodel <- train(form=formula("CoverType~."),data=tr,method="rf",
                  trControl=trainControl(classProbs=TRUE))
outcomes <- predict(bigmodel,te)
cm <- confusionMatrix(outcomes,te$CoverType)
accuracymeasurement <- length(which(outcomes==te$CoverType))/length(outcomes)
```

The Random Forest Predictive Model
========================================================

A random forest model was created by sampling $N$ records from the original data set and then using the **caret** package to train the model.  Using 500-1000 of the 581012 records produced decent accuracy, around 68%, while maintaining a good speed of prediction for the app to be deployed.

Errors in the Model
========================================================

The confusion matrix for the prediction on the remaining data indicates why a much higher accuracy may not be possible:

```
               Reference
Prediction      LodgepolePine SpruceAndFir
  LodgepolePine        213522        57994
  SpruceAndFir          63157       150450
```

The model significantly confuses the lodgepole pine cover with the spruce and fir cover type.  There were 63157 misclassifications of lodgepole pine cover as spruce and fir, of the total 69291 misclassifications of lodgepole pine as *anything* else.  That is, about 91.1474795% of misclassifications of lodgepole pine are made as spruce and fir.  These species are more difficult to distinguish than others and possibly should be lumped as one class in the data set.

Links
========================================================

- Data: [http://archive.ics.uci.edu/ml/datasets/Covertype](http://archive.ics.uci.edu/ml/datasets/Covertype)

- Description: [http://archive.ics.uci.edu/ml/machine-learning-databases/covtype/covtype.info](http://archive.ics.uci.edu/ml/machine-learning-databases/covtype/covtype.info).

- App: [https://robotgames.shinyapps.io/DataProductsProject](https://robotgames.shinyapps.io/DataProductsProject)

- Source (server.R and ui.R): [https://github.com/robotgames/DataProductsSources](https://github.com/robotgames/DataProductsSources)
