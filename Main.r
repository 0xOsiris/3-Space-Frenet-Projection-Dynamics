#Author: Leyton Taylor
main <-function(){
  dat <- data.frame(t=seq(0,2*pi,.1))
  xVal <- function(t) .5*cos(t)
  yVal <- function(t) .1*sin(t)
  points<-array( c(), dim=c(2,lenth(dat)))
  
  ktVec <- c(xVal,yVal)
  
  for(i in seq_along(dat)){
    projKTVec <- calcOrbits(ktVec)
    append(points,projKTVec[1:2](dat[i]))
  }
  
}
#Takes two paramaters that define a parametric function of 
#parameter t and returns a parametric function that corresponds
#to the projection of Curvature and Torsion for each t
calcOrbits <- function(ktVec){
  return(projectionKT(ktVec))
}

#Returns corresponding curvature(t) and torsion(t)
#of the projected Parametric function passed to it
projectionKT <- function(ktVec){
  #First deriveative of curve [k(t),T(t)]
  ktVecP= c(D(ktVec[1],'t'), D(ktVec[2],'t'))
  #Second derivative of curve [k(t),T(t)]
  ktVecDP = c(D(ktVecP[1],'t'), D(ktVecP[2],'t'))
  #Vector [gamma(x(t),y(t))]=[Xo(t),Yo(t),Zo(t)] defining a parametric function of the osculating circle of the image of
  #the planar curve defined by x(t),y(t) at some point t on the unit sphere
  return(c(curvatureI(ktVec,ktVecP, ktVecDP), torsionI(ktVec,ktVecP,ktVecDP)))
  
}

curvatureI(ktVec,ktVecP,ktVecDP)

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

