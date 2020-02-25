#Author: Leyton Taylor


#Takes two paramaters that define a parametric function of 
#parameter t and returns a parametric function that corresponds
#to the projection of Curvature and Torsion for each t
calcOrbits <- function(x,y){
  
  funVec <- c(expression(x),expression(y),-1)
  k <- calcProjectionVal(funVec)
  print(k)
}

#Returns corresponding curvature(t) and torsion(t)
#of the projected Parametric function passed to it
calcProjectionVal <- function(funVec){
  k_alpha <- calculateCurvature(funVec)
  return(k_alpha)
}

#Returns the curvature of the parametric curve 
#Passed to it
calculateCurvature <- function(funVec){
  
  #First derivative of parametric curve
  funVecP <- calculateDerivative(funVec[1],funVec[2])
  #Second derivative of parametric curve
  funVecDP <- calculateDerivative(funVecDP[1],funVecDP[2])
  for(i in 1:3){
    print(str(funVec[i]))
  }
  #funVecP x funVecDP
  crossProd <- calculateCross(funVecP,funVecDP)
  
  normCross <- calculateNorm(crossProd)
  
  #Curvature of parametric curve
  return(normCross)
  
}
#Returns the euclidian norm of a vector v
calculateNorm <-function(v){
  v <- sqrt(sum(v)^2)
  return(v)
}
#Returns norm of cross product of two vectors
calculateCross <- function(funVecP, funVecDP){
  iVal <- funVecP[2]*funVecDP[3]-funVecP[3]*funVecDP[2]
  jVal <- funVecP[1]*funVecDP[3]-funVecP[3]*funVecDP[1]
  kVal <- funVecP[1]*funVecDP[2]-funVecP[2]*funVecDP[1]
  return(c(iVal,jVal,kVal))
}

#Calculates the derivative of the vector passed to it
calculateDerivative <- function(x_t,y_t){
  
  dX = D(expression(x_t),'t')
  dY = D(expression(y_t),'t')
  return(c(dX,dY,0))
}


calcOrbits(cos(t),sin(t))

