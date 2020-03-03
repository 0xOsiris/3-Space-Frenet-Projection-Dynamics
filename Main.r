#Author: Leyton Taylor
#February 2020

#######################################
##Still very much a work in progress###
#######################################

##General description of system behavior:

##alphaN(t) = planar curve s.t. alphaN(t)=[x(t),y(t),-1]
##Notation: calcIterate(alphaN(t))=[curvatureIAlphaN(t), torsionIAlphaN(t)] where IAlpha(t) = Image of alpha(t) when stereographically projected to
##the unit sphere
##betaAlpha(alpha(t))=projection map of alpha to unit sphere i.e. alphaI(t)
##gammaAlpha(alpha(t))=osculating circle of alphaI(t)


##Test data
##dataSet=matrix(alphaN(t)=(x(t),y(t),z=-1), nrow=N, ncol=3)
#dataSet= matrix(c(expression(.2*cos(t)),expression(.5*sin(t)),expression(-1)), ncol=3)
#alphaN=dataSet[1,]
#alphaNP= c(expression(D(alphaN[1],'t')), expression(D(alphaN[2],'t')),expression(0))
#alphaNDP = c(expression(D(alphaNP[1],'t')), expression(D(alphaNP[2],'t')),expression(0))
#alphaNPrimeVec = matrix(
#+     c(),
#+     nrow=3,
#+     ncol=3
#+ )

# alphaNPrimeVec = matrix(
#   +     c(alphaN,alphaNP,alphaNDP),
#   +     nrow=3,
#   +     ncol=3
#   + )

#Ideally will take in a dataset of a family of curves 
#Each row of the dataSet matrix will represent a parametric equation of a planar curve
#the 3 collumns [x(t),y(t),z(t)=-1]
main <- function(dataSet){
    tRange <- data.frame(t=seq(0,2*pi,.1))
    nIterates=10
    for(i in 0:nrow(dataSet)){
        ##Output matrix of nIterate rows and 2 columns = corresponding to [curvature(Ialpha(t)),torsion(Ialpha(t))]
        output=calcOrbit(c(dataSet[i,1],dataSet[i,2],dataSet[i,3]),nIterates,tRange)
        print(output)
    }
}

##Not working, eventually should take in a curve alphaN from the dataSet matrix and 
##run the system over nIterates. The paremetric equation representing the planar curve of each successive iterate
##will be stored in a matrix outputOrbit, the corresponding points over a range of t for each successive iterate
##will be stored in orbitMatrix for plotting purposes.
calcOrbit <- function(alphaN,nIterates,tRange){
    tRange<-seq_along(tRange)
    orbitMatrix = matrix(c(),nrow = nIterates, ncol=3,dimnames = list(, c("x(t)","y(t)","z=-1")))
    outputOrbit = matrix(c(),nrow = length(tRange), ncol=3,dimnames = list(, c("x(t)","y(t)","z=-1")))
    rbind(orbitMatrix, calcIterate(alphaN))
    orbitPlot <- matrix(c(),nrow=nI)
    #k=order of orbit
    for (k in 1:nIterates){
        ktVectorFunction=calcIterate(orbitMatrix[c(k-1)])
        #Binds each consecutive iterate to orbitMartix
        rbind(orbitMatrix,ktVectorFunction)
        for(t in tRange){
          rbind(outputOrbit,c(ktVectorFunction[1](t),ktVectorFunction[2](t),-1))
        }
        
    }
}

#parameter alphaN: returns projectionKT
calcIterate <- function(alphaN){
  return(projectionKT(alphaN))
}


#Returns corresponding curvature(t) and torsion(t)
#of the projected Parametric function passed to it
projectionKT <- function(alphaN){
  #First deriveative of curve [k(t),T(t)]
  alphaNP= c(D(alphaN[1],'t'), D(alphaN[2],'t'),0)
  #Second derivative of curve [k(t),T(t)]
  alphaNDP = c(D(D(alphaN[1],'t'),'t'),D(D(alphaN[2],'t'),'t'),0)
  #Third derivative
  alphaNTP = c(D(D(D(alphaN[1],'t'),'t'),'t'),D(D(D(alphaN[2],'t'),'t'),'t'),0)
  
  #matrix containing alphaN,alphaNP,alphaNDP,alphaNTP
  alphaNPrimeVec = matrix(
    c(alphaN,alphaNP,alphaNDP,alphaNTP),
    nrow=4,
    ncol=3,
    byrow=FALSE
    )
  print(alphaNPrimeVec)
  dimnames(alphaNPrimeVec)=list(c("alphaN","alphaNP","alphaNDP","alphaNTP"),c("X","Y","Z"))
  #return vector of two expressions corresponding to the projected calculation of curvature and torsion
  #will be passed back into the system
  return(c(curvatureI(alphaNPrimeVec,t),torsionI(alphaNPrimeVec,t)))
  
}

##Projected torsion calculation: in progress
torsionI <- function(alphaNPrimeVec,t){
  
  alpha =c(round(eval(alphaNPrimeVec[1,1]),10),round(eval(alphaNPrimeVec[1,2]),10),0)
  alphaP = c(round(eval(alphaNPrimeVec[2,1]),10),round(eval(alphaNPrimeVec[2,2]),10),0)
  alphaDP= c(round(eval(alphaNPrimeVec[3,1]),10),round(eval(alphaNPrimeVec[3,3]),10),0)
  alphaTP= c(round(eval(alphaNPrimeVec[4,1]),10),round(eval(alphaNPrimeVec[4,2]),10),0)
  
  betaAlphMat = betaAlpha(alpha,alphaP,alphaDP,alphaTP,t)
  
  alphaPX<-alphaP[1]
  alphaPY <- alphaP[2]
  alphaDPX= alphaDP[1]
  alphaDPY= alphaDP[2]
  
  
  alphaTPX <-alphaTP[1]
  alphaTPY<-alphaTP[2]
  
  X<-alpha[1]
  Y<-alpha[2]
  Z<-0
  
  betaAlphTP=c(eval(betaAlphMat[4,1]),eval(betaAlphMat[4,2]),0)
  
  betaAlphaTPV=c(eval(betaAlphTP[1])*alphaTP[1],eval(betaAlphTP[2])*alphaTP[2],0)
  
  
  torsionI = dot(tcrossprod(alphaP,alphaDP),betaAlphaTPV)/norm(tcrossprod(alphaP,alphaDP))^2
  
  return(torsionI)
  
}


##Beta mapping represents the stereographic projection of alpha onto the 
##Unit sphere
betaAlpha <- function(alpha,alphaP,alphaDP,alphaNTP,t){

  betaAlpha = c(expression((4*X)/X^2+Y^2+4),expression((4*Y)/X^2+Y^2+4),expression((X^2+Y^2-4)/(X^2+Y^2+4)))
  
  betaAlphaP = c(DD(expression((4*X)/X^2+Y^2+4),'X',1),
                 DD(expression((4*Y)/X^2+Y^2+4),'Y',1),
                 DD(expression((X^2+Y^2-4)/(X^2+Y^2+4)),'Z',1))
  
  betaAlphaDP = c(DD(expression((4*X)/X^2+Y^2+4),'X',2),
                  DD(expression((4*Y)/X^2+Y^2+4),'Y',2),
                  DD(expression(X^2+Y^2-4/(X^2+Y^2+4)),'Z',2))
  
  
  betaAlphaTP = c(DD(expression((4*X)/X^2+Y^2+4),'X',3),
                  DD(expression((4*Y)/X^2+Y^2+4),'Y',3),
                  DD(expression(X^2+Y^2-4/(X^2+Y^2+4)),'Z',3))
  
  
  betaMatrix=matrix(
    c(betaAlpha,betaAlphaP,betaAlphaDP,betaAlphaTP),
    nrow=4,
    ncol=3,
    byrow=FALSE
    
  )
  
  print(betaMatrix)
  
  return(betaMatrix)
  
  
}

##DD for calculation of high order derivatives
DD <- function(expr, name, order=1) {
  if(order < 1) stop("'order' must be >= 1")
  if(order == 1) 
    return(D(expr, name))
  else DD(D(expr, name), name, order - 1)}




#parameter ktVecDeriv=[alpha(t),alpha'(t),alpha''(t)]
#Returns curvature of projected image of alpha on the unit sphere
#at point t
curvatureI <- function(alphaNPrimeVec, t){
  #print(alphaNPrimeVec)
  u=2*pi
  alpha =c(round(eval(alphaNPrimeVec[1,1]),10),round(eval(alphaNPrimeVec[1,2]),10),0)
  alphaP = c(round(eval(alphaNPrimeVec[2,1]),10),round(eval(alphaNPrimeVec[2,2]),10),0)
  alphaDP= c(round(eval(alphaNPrimeVec[3,1]),10),round(eval(alphaNPrimeVec[3,2]),10),0)
  
  kAlpha=curvaturePlaneCurve(alphaP,alphaDP,t)
  print(kAlpha)
  gammaAlpha = osculatingIAlpha(alpha,alphaP,alphaDP,kAlpha)
  print(gammaAlpha)
  X<-(alpha[1]+(alphaDP[1]/kAlpha)+(1/kAlpha))
  Y<-(alpha[2]+(alphaDP[2]/kAlpha)+(1/kAlpha))
  
  gammaAlphaDP=c(eval(gammaAlpha[3,1]),eval(gammaAlpha[3,2]),eval(gammaAlpha[3,3]))
  gammaAlphaDPNorm=c(eval(gammaAlphaDP[1]),eval(gammaAlphaDP[2]),eval(gammaAlphaDP[3]))
  
  
  
  
  curvatureIAlpha=norm(as.matrix(gammaAlphaDPNorm))
  
  #print(curvatureIAlpha)
  #print(kAlpha)
  return(curvatureIAlpha)
}




#(x,y) represent values of osculating circle of some curve alphaN(t) at
#some value t. gammaAlpha(x,y) gives the corresponding (x,y,z)
#values of the osculating circle of the image of alphaN(t) or alphaNI(t)
#at the same value t. Note x,y are depent on alphaN(t)
#that is
# if alphaN(t) = x(t),y(t)==> x=x(t)+((T'alpha(t)_x)/k(t))+(1/k(t))cos(u)) simalarly for y
#described in depth in research paper
## essentially x and y are functions of 0<=u<=2pi at each t on the curve ##alphaN

##For simplicity sake know that ##(x,y)=gamma(u,v=1)=[(1)*(x_0+rcos(u)),(1)*(y_0+rsin(u)),1-2*(1)]
##This mapping creates a surface of a cone. The projection mapping
##gammAlpha gives us the intersection of the cone and the unit sphere.
##this intersection happens at v=4/(x)^2+(y)^2+4
osculatingIAlpha <- function(alpha,alphaP,alphaDP,kAlpha){
    
    gammaAlpha=c(expression(4*(X*cos(u))/((X*cos(u))^2+(Y*sin(u))^2+4)),
                            expression(4*(Y*sin(u))/((X*cos(u))^2+(Y*sin(u))^2+4)),
                            expression(1-(8/((X*cos(u))^2+(Y*sin(u))^2+4))))
                 
    gammaAlphaP=c(D(gammaAlpha[1],'u'), D(gammaAlpha[2],'u'),D(gammaAlpha[3],'u'))
    gammaAlphaDP=c(D(D(gammaAlpha[1],'u'),'u'), D(D(gammaAlpha[2],'u'),'u'),D(D(gammaAlpha[3],'u'),'u'))
    
    #vector containing ktVec,ktVecP, ktVecDP
    gammaMatrix=matrix(
      c(gammaAlpha,gammaAlphaP,gammaAlphaDP),
      nrow=3,
      ncol=3,
      byrow=FALSE
    )
    
    
    return(gammaMatrix)
    
}

#parameter alphaP,alphaDP,t returns curvature of planar curve
curvaturePlaneCurve <- function(alphaP,alphaDP,t){
  
  #print(alphaDP)  
  #print(tcrossprod(alphaP,alphaDP))
  #print(norm(tcrossprod(alphaP,alphaDP)))
  kAlpha = norm(tcrossprod(alphaP,alphaDP))/norm(as.matrix(alphaP))^3
  
  return(kAlpha)
  
}

#dotproduct of two matrices or functions
dot <-function(x,y){
  return(sum(x*y))
}

