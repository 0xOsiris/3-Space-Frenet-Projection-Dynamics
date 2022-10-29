#Author: Leyton Taylor

##alphaN(t) = planar curve s.t. alphaN(t)=[x(t),y(t),-1]
##Notation: calcIterate(alphaN(t))=[curvatureIAlphaN(t), torsionIAlphaN(t)] where IAlpha(t) = Image of alpha(t) when stereographically projected to
##the unit sphere
##betaMap(alpha(t))=projection map of alpha to unit sphere i.e. alphaI(t)
##gammaMap(alpha(t))=osculating circle of alphaI(t)
##dataSet=matrix(alphaN(t)=(x(t),y(t),z=-1), nrow=N, ncol=3)
#dataSet= matrix(c(expression(1+.5*cos(t)),expression(1+.1*sin(t)),expression(-1)), nrow=1,ncol=3,byrow=TRUE)
#dataSet= matrix(c(expression(-.5 + sin(t)*cos(t)),expression(-1 + sin(t)),expression(-1)), nrow=1,ncol=3,byrow=TRUE)
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


# main <- function(dataSet){
#     tRange <- data.frame(t=seq(0,2*pi,.1))
#     nIterates=10
#     for(i in 0:nrow(dataSet)){
#         ##Output matrix of nIterate rows and 2 columns = corresponding to [curvature(Ialpha(t)),torsion(Ialpha(t))]
#         output=calcOrbit(c(dataSet[i,1],dataSet[i,2],dataSet[i,3]),nIterates,tRange)
#         print(output)
#     }
# }


##Output matrix of corresponding iterates of alphaN
# calcOrbit <- function(alphaN,nIterates,tRange){
#     tRange<-seq_along(tRange)
#     orbitMatrix = matrix(c(),nrow = nIterates, ncol=3,dimnames = list(, c("x(t)","y(t)","z=-1")))
#     outputOrbit = matrix(c(),nrow = length(tRange), ncol=3,dimnames = list(, c("x(t)","y(t)","z=-1")))
#     rbind(orbitMatrix, calcIterate(alphaN))
#     orbitPlot <- matrix(c(),nrow=nI)
#     #k=order of orbit
#     for (k in 1:nIterates){
#         ktVectorFunction=calcIterate(orbitMatrix[c(k-1)])
#         #Binds each consecutive iterate to orbitMartix
#         rbind(orbitMatrix,ktVectorFunction)
#         for(t in tRange){
#           rbind(outputOrbit,c(ktVectorFunction[1](t),ktVectorFunction[2](t),-1))
#         }
#         
#     }
# }

options(digits = 15)

#parameter t and returns a parametric function that corresponds
#to the projection of Curvature and Torsion for each t
calcIterate <- function(alphaN){
  return(projectionKT(alphaN, pi/8))
}


#Returns corresponding curvature(t) and torsion(t)
#of the projected Parametric function passed to it
projectionKT <- function(alphaN,t){
  t=t
  #First deriveative of curve [k(t),T(t)]
  alphaNP <- c(D(alphaN[1],'t'), D(alphaN[2],'t'),0)
  #Second derivative of curve [k(t),T(t)]
  alphaNDP <- c(D(D(alphaN[1],'t'),'t'),D(D(alphaN[2],'t'),'t'),0)
  alphaNTP <- c(D(D(D(alphaN[1],'t'),'t'),'t'),D(D(D(alphaN[2],'t'),'t'),'t'),0)
  
  #vector containing ktVec,ktVecP, ktVecDP
  alphaNPrimeVec <-matrix(
    c(alphaN,alphaNP,alphaNDP,alphaNTP),
    nrow=4,
    ncol=3,
    byrow=TRUE
    )
  
  
  dimnames(alphaNPrimeVec)=list(c("alphaN","alphaNP","alphaNDP","alphaNTP"),c("X","Y","Z"))
  print("alphaN")
  print(alphaNPrimeVec["alphaN",])
  print("AlphaNp")
  print(alphaNPrimeVec["alphaNP",])
  print("alphaNDP")
  print(alphaNPrimeVec["alphaNDP",])
  print("alphaNTP")
  print(alphaNPrimeVec["alphaNTP",])
  print("done")
  return(c(ktCalculation(alphaNPrimeVec,t)))
  
}

ktCalculation <- function(alphaNPrimeVec, t){
  
  A <- curvatureI(alphaNPrimeVec,t)
  curvature <- A$curvature
  torsion <- A$torsion
  
  return(c(curvature,torsion))
  
}

arcLengthGamma <- function(gammaMatrix, Xo, Yo, kAlpha, t){
  gammaEnv <- new.env(hash=TRUE,size=4)
  assign("Xo",value=Xo,envir=gammaEnv)
  assign("Yo",value=Yo,envir=gammaEnv)
  assign("kAlpha",value=kAlpha,envir=gammaEnv)
  t <- t
  Xo <- Xo
  Yo <- Yo
  kAlpha <- kAlpha
  xfunc <- function(u){eval(gammaMatrix[1,1], gammaEnv)}
  yfunc <- function(u){eval(gammaMatrix[1,2], gammaEnv)}
  zfunc <- function(u){eval(gammaMatrix[1,3], gammaEnv)}
  f <- function(u) c(xfunc(u),yfunc(u),zfunc(u))
  
  return(arclength(f, t, (t)+2*pi))
  
  
}

arcLengthBeta <- function(betaMatrix, a, alphaNPrimeVec){
  betaEnv <- new.env(hash=TRUE,size=2)
  assign("X",value<-deparse(alphaNPrimeVec[1,1]),envir=betaEnv)
  assign("Y",value<-deparse(alphaNPrimeVec[1,2]),envir=betaEnv)
  b <- deparse(betaMatrix[1])
  print("tt")
  print(alphaNPrimeVec)
  b1 <- substitute(b, list(X = deparse(alphaNPrimeVec[1,1])))
  print(eval(b1))
  t<-t
  xfunc <- function(t){substitute(betaMatrix[1], betaEnv)}
  yfunc <- function(t){substitute(betaMatrix[2], betaEnv)}
  zfunc <- function(t){substitute(betaMatrix[3], betaEnv)}
  f <- function(t) c(xfunc(t),yfunc(t),zfunc(t))

  return(arclength(f, 0, a))
  
  
}

#parameter ktVecDeriv=[alpha(t),alpha'(t),alpha''(t)]
#Returns curvature of projected image of alpha on the unit sphere
#at point t
curvatureI <- function(alphaNPrimeVec, t){
  print(alphaNPrimeVec)
  print(alphaNPrimeVec[1,1])
  print(alphaNPrimeVec[1,2])
  print(alphaNPrimeVec[2,1])
  print(alphaNPrimeVec[2,2])
  print(alphaNPrimeVec[3,1])
  print(alphaNPrimeVec[3,2])
  print(alphaNPrimeVec)
  betaEnv <- new.env(hash=TRUE,size=2)
  print("blah")
  print(deparse(alphaNPrimeVec[1,1]))
  assign("X",value<-deparse(alphaNPrimeVec[1,1]),envir=betaEnv)
  assign("Y",value<-deparse(alphaNPrimeVec[1,2]),envir=betaEnv)
  
  alpha <-c(eval(alphaNPrimeVec[1,1]),eval(alphaNPrimeVec[1,2],-1))
  alphaP <- c(eval(alphaNPrimeVec[2,1]),eval(alphaNPrimeVec[2,2]),0)
  alphaDP <- c(eval(alphaNPrimeVec[3,1]),eval(alphaNPrimeVec[3,2]),0)
  betaMatrix <- betaAlpha()
  print(substitute(deparse(betaMatrix[2,1]), list(X=10)))
  print("beta")
  
  substitute_q <- function(x, env) {
    call <- substitute(substitute(y, env), list(y = x))
    eval(call)
  }
  
  print(substitute_q(betaMatrix[2,1], betaEnv))
  arcLengthBet <- arcLengthBeta(betaMatrix[2,], 2*pi, alphaNPrimeVec)
  print("Arc Length Beta")
  print(arcLengthBet)
  #X value corresponding to alpha(t)
  xAlpha= alpha[1]
  #Y value corresponding to alpha(t)
  yAlpha= alpha[2]

  #X value corresponding to alpha(t)
  xpAlpha= alphaP[1]
  #Y value corresponding to alpha(t)
  ypAlpha= alphaP[2]
  
  normX<-norm(as.matrix(alphaDP[1]),"F")
  normY<-norm(as.matrix(alphaDP[2]),"F")
  #Curvature of planar curve alpha(t)
  kAlpha<-curvaturePlaneCurve(alphaP,alphaDP,t)
  #Tprime x direction
  Tprime = c(-alphaP[2], alphaP[1])
  magTprime <- norm(as.matrix(Tprime),"F")
  TprimeUnit <- c(Tprime / magTprime)
  xyNot = c(TprimeUnit / kAlpha)
  Xo = xyNot[1]+xAlpha
  Yo = xyNot[2]+yAlpha

  #Returns matrix containing the projected osculating circle of alpha
  #at some t

  gammaMatrix <-gammaAlphaF()
  betaAlphaTP <- betaAlpha()
  print("Gamma Matrix")
  print(gammaMatrix)

  
  print(kAlpha)
  
  print("XoYo")
  print(alphaP[1])
  print(alphaP[2])
  print(Tprime)
  print(TprimeUnit)
  print(Xo)
  print(Yo)
  print(magTprime)

  
  print("t")
  print(t)
  print("Arc Length")
  arcLengthA = arcLengthGamma(gammaMatrix, Xo, Yo, kAlpha, t)
  arcLength = arcLengthA$length
  print(arcLength)
  
  #Environment
  gammaEnv1 <- new.env(hash=TRUE,size=4)
  assign("Xo",value=Xo,envir=gammaEnv1)
  assign("Yo",value=Yo,envir=gammaEnv1)
  assign("kAlpha",value=kAlpha,envir=gammaEnv1)
  assign("u",value=t,envir=gammaEnv1)

  gammaEnv2 <- new.env(hash=TRUE,size=4)
  assign("Xo",value=Xo,envir=gammaEnv2)
  assign("Yo",value=Yo,envir=gammaEnv2)
  assign("kAlpha",value=kAlpha,envir=gammaEnv2)
  assign("u",value=t+.01,envir=gammaEnv2)

  gammaEnv3 <- new.env(hash=TRUE,size=4)
  assign("Xo",value=Xo,envir=gammaEnv3)
  assign("Yo",value=Yo,envir=gammaEnv3)
  assign("kAlpha",value=kAlpha,envir=gammaEnv3)
  assign("u",value=t+.02,envir=gammaEnv3)

  #Environment
  betaEnv <- new.env(hash=TRUE,size=4)
  assign("X",value=xAlpha,envir=betaEnv)
  assign("Y",value=yAlpha,envir=betaEnv)
  assign("Xp",value=xpAlpha,envir=betaEnv)
  assign("Yp",value=ypAlpha,envir=betaEnv)

  #Projection point P on Alpha
  Pprime<- c(eval(gammaMatrix[1,1],gammaEnv1),eval(gammaMatrix[1,2],gammaEnv1),eval(gammaMatrix[1,3],gammaEnv1))
  #Arbitrary point on Gamma curve
  Aprime<- c(eval(gammaMatrix[1,1],gammaEnv2),eval(gammaMatrix[1,2],gammaEnv2),eval(gammaMatrix[1,3],gammaEnv2))
  #Arbitrary point on Gamma curve
  Bprime<- c(eval(gammaMatrix[1,1],gammaEnv3),eval(gammaMatrix[1,2],gammaEnv3),eval(gammaMatrix[1,3],gammaEnv3))

  betaPrimeN <-c(eval(betaAlphaTP[1,1],betaEnv),eval(betaAlphaTP[1,2],betaEnv),eval(betaAlphaTP[1,3],betaEnv))
  GammaPrimeA <-c(eval(gammaMatrix[2,1],gammaEnv2),eval(gammaMatrix[2,2],gammaEnv2),eval(gammaMatrix[2,3],gammaEnv2))
  GammaPrimeB <-c(eval(gammaMatrix[2,1],gammaEnv3),eval(gammaMatrix[2,2],gammaEnv1),eval(gammaMatrix[2,3],gammaEnv3))

  gammaPAlphaA <- c(GammaPrimeA * alphaP)
  gammaPAlphaB <- c(GammaPrimeB * alphaP)

  print(betaPrimeN)

  betaPrimeAlpha <- c(betaPrimeN * alphaP)


  ##P'-A'
  v1 <-c(Aprime-Pprime)
  ##P'-B'
  v2 <-c(Bprime-Pprime)

  v1Prime <-c(betaPrimeAlpha - gammaPAlphaA)
  v2Prime <- c(betaPrimeAlpha - gammaPAlphaB)

  normVec <- xprod(v1, v2)
  magNorm <- norm(as.matrix(normVec),"F")

  v1PCrossv2 <- xprod(v1Prime,v2)
  v2PCrossv1 <- xprod(v2Prime,v1)

  Nprime <- c(v1PCrossv2 + v2PCrossv1)

  pPrimeDn <- c(-Pprime * Nprime)
  #-P'*N'
  pPrimedotDn <- sum(pPrimeDn)

  nbetaPrime <- c(normVec * betaPrimeAlpha)
  #N*-P''
  ndotbetaPrime <- sum(nbetaPrime)
  #N*-P''+ -P'*N'
  const1 <- -pPrimedotDn + ndotbetaPrime
  #mag(N)*(N*-P''+ -P'*N')
  magNdotConst<- magNorm * const1
  #mag(N)*(N*-P''+ -P'*N')/mag(N)^2
  finalCons <- magNdotConst / (magNorm^2)

  #-P'*N/(magNorm)= p == signed distance from center of sphere to c
  p4 <- c(-Pprime*normVec)
  p4dotn <- sum(p4)
  p <- p4dotn / magNorm

  #sqrt(R^2-p^2)
  p7 <- p^2
  r1 = 1 - p7

  #r== 1/k(BetaAlpha(t))


  #Curvature of Image of Alpha at t
  kIAlpha= (2*pi)/arcLength
  r = 1/kIAlpha

  cI <- c(p * normVec)
  c <- c(cI/ magNorm)

  N <- c(c-Pprime)
  
  nNorm <- norm(as.matrix(N),"F")
  #.5/(sqrt(1-p^2))
  Rprimecons1 <- .5 / sqrt(1-p7)
  rPrime <- Rprimecons1 *(-2*p*(finalCons))
  

  #1-r(t)
  torsionI1 = 1-r
  torsionI2 =torsionI1/(rPrime^2)
  torsion <- -1*(1 / sqrt(torsionI2))

  print("R")
  print(r)
 
  uN <- c(N / nNorm)
  B<- normVec / magNorm

  Tv <- xprod(uN,B)
  uT <- Tv
  print("BTN")
  print(B)
  print(uT)
  print(uN)

  Tv<- Tv*-kIAlpha
  Ntp <- c(Nprime-Tv)

  return(list("curvature"=kIAlpha,"normVec"=normVec,"center"= c,"torsion"=torsion))
}

# curvatureI <- function(alphaNPrimeVec, t){
#   print(alphaNPrimeVec)
#   print(alphaNPrimeVec[1,1])
#   print(alphaNPrimeVec[1,2])
#   print(alphaNPrimeVec[2,1])
#   print(alphaNPrimeVec[2,2])
#   print(alphaNPrimeVec[3,1])
#   print(alphaNPrimeVec[3,2])
#   print(alphaNPrimeVec)
#   alpha <-c(eval(alphaNPrimeVec[1,1]),eval(alphaNPrimeVec[1,2],-1))
#   alphaP <- c(eval(alphaNPrimeVec[2,1]),eval(alphaNPrimeVec[2,2]),0)
#   alphaDP <- c(eval(alphaNPrimeVec[3,1]),eval(alphaNPrimeVec[3,2]),0)
# 
#   #X value corresponding to alpha(t)
#   xAlpha= alpha[1]
#   #Y value corresponding to alpha(t)
#   yAlpha= alpha[2]
# 
#   #X value corresponding to alpha(t)
#   xpAlpha= alphaP[1]
#   #Y value corresponding to alpha(t)
#   ypAlpha= alphaP[2]
#   normX<-norm(as.matrix(alphaDP[1]),"F")
#   normY<-norm(as.matrix(alphaDP[2]),"F")
#   #Tprime x direction
#   Tprimex=alphaDP[1]
#   #Tprime y direction
#   Tprimey=alphaDP[2]/normY
# 
#   print(Tprimex)
#   print(Tprimey)
#   #Returns matrix containing the projected osculating circle of alpha
#   #at some t
# 
# 
#   gammaMatrix <-gammaAlphaF()
#   betaAlphaTP <- betaAlpha()
# 
#   print(gammaMatrix)
# 
#   #Curvature of planar curve alpha(t)
#   kAlpha<-curvaturePlaneCurve(alphaP,alphaDP,t)
#   print(kAlpha)
#   #(Xo,Yo)= center of osculating circle of alpha(t) at t
#   Xo<-xAlpha+(Tprimex/kAlpha)
#   Yo<-yAlpha+(Tprimey/kAlpha)
#   print(Xo)
#   print(Yo)
# 
#   arcLengthGamma <- function(gammaMatrix){
#     Xo <- Xo
#     Yo <- Yo
#     kAlpha <- kAlpha
#     xfunc <- function(u){eval(gammaMatrix[1,1])}
#     yfunc <- function(u){eval(gammaMatrix[1,2])}
#     zfunc <- function(u){eval(gammaMatrix[1,3])}
#     f <- function(u) c(xfunc(u),yfunc(u),zfunc(u))
#     
#     return(arclength(f, t, (t)+2*pi))
#     
#     
#   }
#   print("Arc Length")
#   arcLengthA = arcLengthGamma(gammaMatrix)
#   arcLength = arcLengthA$length
# 
#   #Environment
#   gammaEnv1 <- new.env(hash=TRUE,size=4)
#   assign("Xo",value=Xo,envir=gammaEnv1)
#   assign("Yo",value=Yo,envir=gammaEnv1)
#   assign("kAlpha",value=kAlpha,envir=gammaEnv1)
#   assign("u",value=t,envir=gammaEnv1)
# 
#   gammaEnv2 <- new.env(hash=TRUE,size=4)
#   assign("Xo",value=Xo,envir=gammaEnv2)
#   assign("Yo",value=Yo,envir=gammaEnv2)
#   assign("kAlpha",value=kAlpha,envir=gammaEnv2)
#   assign("u",value=t+.01,envir=gammaEnv2)
# 
#   gammaEnv3 <- new.env(hash=TRUE,size=4)
#   assign("Xo",value=Xo,envir=gammaEnv3)
#   assign("Yo",value=Yo,envir=gammaEnv3)
#   assign("kAlpha",value=kAlpha,envir=gammaEnv3)
#   assign("u",value=t+.02,envir=gammaEnv3)
# 
#   #Environment
#   betaEnv <- new.env(hash=TRUE,size=4)
#   assign("X",value=xAlpha,envir=betaEnv)
#   assign("Y",value=yAlpha,envir=betaEnv)
#   assign("Xp",value=xpAlpha,envir=betaEnv)
#   assign("Yp",value=ypAlpha,envir=betaEnv)
# 
# 
#   Pprime<- c(eval(gammaMatrix[1,1],gammaEnv1),eval(gammaMatrix[1,2],gammaEnv1),eval(gammaMatrix[1,3],gammaEnv1))
#   Aprime<- c(eval(gammaMatrix[1,1],gammaEnv2),eval(gammaMatrix[1,2],gammaEnv2),eval(gammaMatrix[1,3],gammaEnv2))
#   Bprime<- c(eval(gammaMatrix[1,1],gammaEnv3),eval(gammaMatrix[1,2],gammaEnv3),eval(gammaMatrix[1,3],gammaEnv3))
# 
# 
#   betaPrimeN <-c(eval(betaAlphaTP[1,1],betaEnv),eval(betaAlphaTP[1,2],betaEnv),eval(betaAlphaTP[1,3],betaEnv))
#   GammaPrimeA <-c(eval(gammaMatrix[2,1],gammaEnv2),eval(gammaMatrix[2,2],gammaEnv2),eval(gammaMatrix[2,3],gammaEnv2))
#   GammaPrimeB <-c(eval(gammaMatrix[2,1],gammaEnv3),eval(gammaMatrix[2,2],gammaEnv1),eval(gammaMatrix[2,3],gammaEnv3))
# 
# 
# 
#   gammaPAlphaA <- c(GammaPrimeA * alphaP)
#   gammaPAlphaB <- c(GammaPrimeB * alphaP)
# 
# 
# 
#   print(betaPrimeN)
#   betaPrimeAlpha <- c(betaPrimeN * alphaP)
# 
#   ##n
# 
# 
# 
#   ##P'-A'
#   v1 <-c(Aprime-Pprime)
#   ##P'-B'
#   v2 <-c(Bprime-Pprime)
# 
#   v1Prime <-c(betaPrimeAlpha - gammaPAlphaA)
#   v2Prime <- c(betaPrimeAlpha - gammaPAlphaB)
# 
#   normVec <- xprod(v1,v2)
# 
#   magNorm <- norm(as.matrix(normVec),"F")
# 
#   v1PCrossv2 <- xprod(v1Prime,v2)
#   v2PCrossv1 <- xprod(v2Prime,v1)
# 
#   Nprime <- c(v1PCrossv2 + v2PCrossv1)
# 
#   pPrimeDn <- c(-Pprime * Nprime)
#   pPrimedotDn <- sum(pPrimeDn)
# 
#   nbetaPrime <- c(normVec * betaPrimeAlpha)
#   ndotbetaPrime <- sum(nbetaPrime)
# 
#   const1 <- -pPrimedotDn + ndotbetaPrime
#   magNdotConst<- magNorm * const1
#   finalCons <- magNdotConst / (magNorm^2)
# 
# 
#   p4 <- c(-Pprime*normVec)
#   p4dotn <- sum(p4)
#   p <- p4dotn / magNorm
# 
#   cI <- c(p * normVec)
#   c <- c(cI/ magNorm)
# 
#   p7 <- p^2
# 
#   Rprimecons1 <- .5 * sqrt(1-p7)
#   Rprimecons2 <- Rprimecons1 *(-2*p*(finalCons))
# 
#   rPrime = Rprimecons1*Rprimecons2
#   #Curvature of Image of Alpha at t
#   kIAlpha= (2*pi)/arcLength
#   r = 1/kIAlpha
#   print("R")
#   print(r)
#   print(kIAlpha)
#   N <- c(-Pprime-c)
#   uN <- c(N / r)
#   B<- normVec / magNorm
# 
#   Tv <- xprod(uN,B)
#   uT <- Tv
#   print("BTN")
#   print(B)
#   print(uT)
#   print(uN)
# 
# 
# 
# 
#   Tv<- Tv*-kIAlpha
#   Ntp <- c(Nprime-Tv)
# 
#   torsionI1 = 1-r
#   torsionI2 =torsionI1/(rPrime^2)
#   torsion <- -1*(1 / sqrt(torsionI2))
# 
#   return(list("curvature"=kIAlpha,"normVec"=normVec,"center"= c,"torsion"=torsion))
# }

funins <- function(f, expr = expression(x<-2*x), after=1) {
  body(f)<-as.call(append(as.list(body(f)), expr, after=after))
  f
}

##Beta mapping represents the stereographic projection of alpha onto the
##Unit sphere
betaAlpha <- function(){
  betaAlpha <- c(expression((4*X)/(X^2+Y^2+4)),
                 expression((4*Y)/(X^2+Y^2+4)),
                 expression((X^2+Y^2-4)/(X^2+Y^2+4)))
  
  betaAlphaP<- c(expression((((X^2+Y^2+4)*(Xp))-((4*X)*((2*X)*Xp+(2*Y)*Yp)))/(X^2+Y^2+4)^2),
                 expression((((X^2+Y^2+4)*(Yp))-((4*Y)*((2*X)*Xp+(2*Y)*Yp)))/(X^2+Y^2+4)^2),
                 expression(((X^2+Y^2+4)*((2*X)*Xp +(2*Y)*Yp)-((X^2+Y^2+4)*((2*X)*Xp +(2*Y)*Yp)))/(X^2+Y^2+4)^2))
  
  betaAlphMat = matrix(
    c(betaAlphaP,betaAlpha),
    nrow=2,
    ncol=3,
    byrow = TRUE
  )
  
  
  print("sup")
  print(betaAlphMat)
  return(betaAlphMat)
  
} 


##Parametric function defining osculating circle of a curve alpha(t)
##at some t. ==> radius of osculatingAlpha= (1/kAlpha)
##further we know [x_0,y_0]=[x(t),y(t)]+[T'_alpha(t)/kAlpha)]
##0<=u<=2pi with will be the parameter of the osculating circle
##uRange=data.frame(u=seq(0,2*pi,.1))

#(x,y) represent values of osculating circle of some curve alphaN(t) at
#some value t. gammaAlpha(t) gives the corresponding (x,y,z)
#values of the osculating circle of the image of alphaN(t) or alphaNI(t)
#at the same value t. Note x,y are depent on alphaN(t)
#that is
# if alphaN(t) = x(t),y(t)==> x=x(t)+((T'alpha(t)_x)/k(t))+(1/k(t))cos(u))
## essentially x and y are functions of 0<=u<=2pi at each t on the curve ##alphaN

##For simplicity sake know that ##(x,y)=gamma(u,v=1)=[(1)*(x_0+rcos(u)),(1)*(y_0+rsin(u)),1-2*(1)]
##This mapping creates a surface of a cone. The projection mapping
##gammAlpha gives us the intersection of the cone and the unit sphere.
##this intersection happens at v=4/(x)^2+(y)^2+4

gammaAlphaF <- function(){
  
  #Vector of expressions corresponding to the gamma mapping applied to alpha
  gammaAlpha <- c(expression((4*(Xo+(1/kAlpha)*cos(u)))/((Xo+(1/kAlpha)*cos(u))^2+(Yo+(1/kAlpha)*sin(u))^2+4)),
                expression((4*(Yo+(1/kAlpha)*sin(u)))/((Xo+(1/kAlpha)*cos(u))^2+(Yo+(1/kAlpha)*sin(u))^2+4)),
                expression(1+(-8/((Xo+(1/kAlpha)*cos(u))^2+(Yo+(1/kAlpha)*sin(u))^2+4))))
  
  
  gammaAlphaP <- c(DD(gammaAlpha[1], 'u',1),DD(gammaAlpha[2], 'u',1),DD(gammaAlpha[3], 'u',1))
  
  #gammaMatrix of expressions by row
  gammaMatrix = matrix(
    c(gammaAlpha,gammaAlphaP),
    nrow=2,
    ncol=3,
    byrow=TRUE,
    )
  
  dimnames(gammaMatrix)=list(c("GammaAlpha: ","GammaAlphaDP"),c("X_gamma","Y_gamma","Z_gamma"))
  
  
  return(gammaMatrix)
  
}


#parameter ktVecDeriv=[alpha(t),alpha'(t),alpha''(t)]
#returns ||alpha'(t) x alpha''(t) ||/ ||(alpha'(t))^3||==K_alpha(t)
curvaturePlaneCurve <- function(alphaP,alphaDP,t){
  normCross <-xprod(alphaP,alphaDP)
  normAD <-norm(as.matrix(normCross),"F")
  normAP <-norm(as.matrix(alphaP),"F")
  kAlpha = normAD /(normAP^3)
  print(kAlpha)
  return(kAlpha)
  
}

# torsionI <- function(alphaNPrimeVec,t,normVec){
#   
#   alpha <-c(eval(alphaNPrimeVec[1,1]),eval(alphaNPrimeVec[1,2],-1))
#   alphaP <- c(eval(alphaNPrimeVec[2,1]),eval(alphaNPrimeVec[2,2]),0)
#   alphaDP <- c(eval(alphaNPrimeVec[3,1]),eval(alphaNPrimeVec[3,2]),0)
#   betaAlphMat = betaAlpha(alphaNPrimeVec,t)
#   
#   print(betaAlphaTP)
# 
#   print(normVec)
#   print("norm")
#   num <-c(normVec)
#   
#   dotNum <- sum(num)
#   denom <- norm(as.matrix(normVec),"F")
#   torsionI <- dotNum/(denom^2)
#   print(denom^2)
#   print(dotNum)
#   
# 
#   return(torsionI)
# 
# }

##DD for calculation of high order derivatives
DD <- function(expr, name, order=1) {
  if(order < 1) stop("'order' must be >= 1")
  if(order == 1) 
    return(D(expr, name))
  else DD(D(expr, name), name, order - 1)}

xprod <- function(...) {
  args <- list(...)
  
  # Check for valid arguments
  
  if (length(args) == 0) {
    stop("No data supplied")
  }
  len <- unique(sapply(args, FUN=length))
  if (length(len) > 1) {
    stop("All vectors must be the same length")
  }
  if (len != length(args) + 1) {
    stop("Must supply N-1 vectors of length N")
  }
  
  # Compute generalized cross product by taking the determinant of sub-matricies
  
  m <- do.call(rbind, args)
  sapply(seq(len),
         FUN=function(i) {
           det(m[,-i,drop=FALSE]) * (-1)^(i+1)
         })
}



