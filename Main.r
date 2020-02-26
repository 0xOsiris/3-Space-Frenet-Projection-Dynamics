#Author: Leyton Taylor

##alphaN(t) = planar curve s.t. alphaN(t)=[x(t),y(t)]
##Notation: calcIterate(alphaN(t))=[curvatureIAlphaN(t), torsionIAlphaN(t)] where IAlpha(t) = Image of alpha(t) when stereographically projected to
##the unit sphere
##betaMap(alpha(t))=projection map of alpha to unit sphere i.e. alphaI(t)
##gammaMap(alpha(t))=osculating circle of alphaI(t)

##dataSet=matrix(alphaN(t)=(x(t),y(t)), nrow=N, ncol=2)
main <- function(dataSet){
    tRange <- data.frame(t=seq(0,2*pi,.1))
    nIterates=10
    for(i in 0:nrow(dataSet)){
        ##Output matrix of nIterate rows and 2 columns = corresponding to [curvature(Ialpha(t)),torsion(Ialpha(t))]
        output=calcOrbit(c(dataSet[i,1],dataSet[i,2]),nIterates)
        print(output)
    }
}
##Output matrix of corresponding iterates of alphaN
calcOrbit <- function(alphaN,nIterates){
    orbitMatrix <- matrix(,nrow = nIterates, ncol=2,dimnames = list(, c("x(t)","y(t)"))
    rbind(orbitMatrix, calcIterate(alphaN))
    
    #k=order of orbit
    for (k in 1:nIterates){
        #Binds each consecutive iterate to orbitMartix
        rbind(orbitMatrix,calcIterate(orbitMatrix[c(k-1)]))
    }
}

#parameter t and returns a parametric function that corresponds
#to the projection of Curvature and Torsion for each t
calcIterate <- function(alphaN){
  return(projectionKT(alphaN))
}

#Returns corresponding curvature(t) and torsion(t)
#of the projected Parametric function passed to it
projectionKT <- function(alphaN){
  #First deriveative of curve [k(t),T(t)]
  alphaNP= c(D(alphaN[1],'t'), D(alphaN[2],'t'))
  #Second derivative of curve [k(t),T(t)]
  alphaNDP = c(D(alphaN[1],'t'), D(alphaN[2],'t'))
  
  #vector containing ktVec,ktVecP, ktVecDP
  alphaNPrimeVec = c(alphaN, alphaNP,alphaNDP)
  
  return(c(curvatureI(alphaNPrimeVec,t), torsionI(alphaNPrimeVec,t)))
  
}


#parameter ktVecDeriv=[alpha(t),alpha'(t),alpha''(t)]
#Returns curvature of projected image of alpha on the unit sphere
#at point t
curvatureI <- function(alphaNPrimeVec, t){
  kAlpha=curvaturePlaneCurve(alphaNPrimeVec,t)
  
  
}

##Parametric function defining osculating circle of a curve alpha(t)
##at some t. ==> radius of osculatingAlpha= (1/kAlpha)
##further we know [x_0,y_0]=[x(t),y(t)]+[T'_alpha(t)/kAlpha)]
##0<=u<=2pi with will be the parameter of the osculating circle
##uRange=data.frame(u=seq(0,2*pi,.1))
osculatingAlpha <- function(alphaNPrimeVec,kAlpha,t){
    oscX=c(alphaNPrimeVec[1](t)+
}

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
gammaAlpha <-function(x,y){
    gX <- function(x,y){
        return(4*(x)/(x)^2+(y)^2+4))
    }
    
    gY <- function(x,y){
        return(4*(y)/(x)^2+(y)^2+4))
    }
    gZ <-function(x,y){
        return(1-(8/(x)^2+(y)^2+4))
    }
    
    gammaAlphaVec=c(gX(x,y),gY(x,y),gZ(x,y))
    
    return(gammAlphaVec)
  
}



#parameter ktVecDeriv=[alpha(t),alpha'(t),alpha''(t)]
#returns ||alpha'(t) x alpha''(t) ||/ ||(alpha'(t))^3||==K_alpha(t)
curvaturePlaneCurve <- function(ktVecDeriv,t){
  alphaP = c(ktVecDeriv[2][1](t),ktVecDeriv[2][2](t))
  alphaDP= c(ktVecDeriv[3][1](t),ktVecDeriv[3][1](t))
  
  kAlpha = norm(cross(alphaP,alphaDP),"2")/norm(alphaP)^3
  
  return(kAlpha)
}
