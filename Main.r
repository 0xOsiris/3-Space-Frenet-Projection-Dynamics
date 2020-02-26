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
  
  #vector containing ktVec,ktVecP, ktVecDP
  ktVecDeriv = c(ktVec, ktVecP,ktVecDP)
  
  return(c(curvatureI(ktVecDeriv,t), torsionI(ktVecDeriv,t)))
  
}


#parameter ktVecDeriv=[alpha(t),alpha'(t),alpha''(t)]
#Returns curvature of projected image of alpha on the unit sphere
#at point t
curvatureI <- function(ktVecDeriv, t){
  kAlpha=curvaturePlaneCurve(ktVecDeriv,t)
  
 
}


gammaAlpha <-function(x,y){
  
  ##Returns vec [gammaX(x,y),gammaY(x,y),gammaZ(x,y)]
  
  
}

#parameter ktVecDeriv=[alpha(t),alpha'(t),alpha''(t)]
#returns ||alpha'(t) x alpha''(t) ||/ ||(alpha'(t))^3||==K_alpha(t)
curvaturePlaneCurve <- function(ktVecDeriv,t){
  alphaP = c(ktVecDeriv[2][1](t),ktVecDeriv[2][2](t))
  alphaDP= c(ktVecDeriv[3][1](t),ktVecDeriv[3][1](t))
  
  kAlpha = norm(cross(alphaP,alphaDP),"2")/norm(alphaP)^3
  
  return(kAlpha)
}
