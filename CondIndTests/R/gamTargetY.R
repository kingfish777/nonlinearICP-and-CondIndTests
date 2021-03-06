gamTargetY <- function(X,
                       Y,
                       E,
                       trainInd,
                       testInd,
                       verbose,
                       colNameNoSmooth,
                       returnModel){

  if(!is.null(colNameNoSmooth)){
    idxNoSmooth <- which(is.element(colnames(X), colNameNoSmooth))

    if(length(idxNoSmooth) == 0){
      idxNoSmooth <- NULL
    }

  }else{
    idxNoSmooth <- NULL
  }

  # train model with X only and predict out-of-sample with X-model
  gamOnlyX <- getgamPredictions(as.data.frame(as.matrix(X)[trainInd,]),
                                Y[trainInd],
                                as.data.frame(as.matrix(X)[testInd,]),
                                idxNoSmooth = idxNoSmooth,
                                returnModel = returnModel)

  predictedOnlyX <- gamOnlyX$predictions

  # train model with X and E and predict out-of-sample with XE-model
  if(is.factor(E)){
    idxNoSmoothE <- c(idxNoSmooth, ncol(as.matrix(X))+1)
  }else{
    idxNoSmoothE <- idxNoSmooth
  }
  gamXE <- getgamPredictions(as.data.frame(cbind(as.matrix(X)[trainInd,], E[trainInd])),
                  Y[trainInd],
                  as.data.frame(cbind(as.matrix(X)[testInd,], E[testInd])),
                  idxNoSmooth = idxNoSmoothE,
                  returnModel = returnModel)

  predictedXE <- gamXE$predictions


  if(!returnModel){
    list(predictedOnlyX = predictedOnlyX,
         predictedXE = predictedXE)
  }else{
    list(predictedOnlyX = predictedOnlyX,
         predictedXE = predictedXE,
         model = list(gamOnlyX = gamOnlyX$model, gamXE = gamXE$model))
  }

}
