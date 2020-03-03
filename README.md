# DynamicalSystem of curvature and torsion of stereographically projected smooth planar curves. 

In Progress: Dynamical System created from mapping of curvature and torsion of image of parametric planar curve when 
stereographically projected to the unit sphere. 

The curvature k(t) and torsion t(t) represent the curvature and torsion of the image of the projection of some smooth 
planar curve at some time stamp t. k(t) and t(t) create a new smooth continuous planar curve that can then be projected. Each iterate
of the orbit calculates the new k(t),t(t) of the parametric curve passed. 

The goal is to analyze the behavior of this system for families of smooth planar curves i.e. 

If f: R^2->R^2 is defined as f(N(t)) = [k(t),t(t)] where k(t) and t(t) represent the curvature and torsion of the image of N(t) on the unit
sphere. Then f^n(N(t))=[k^n(t),t^n(t)] would be the nth iterate of f which would be the result of stereographically projecting [k(t),t(t)] and recalculating the projected curvature and torsion over n iterates.

The behavior we are hoping to analyze is as follows:

1) Try to find fixed points in the system --> if N(t) =[x(t),y(t)] then f(N(t))=N(t)==> [k(t),t(t)]=N(t) where k(t) and t(t) represent
the curvature and torsion of the image of N(t) on the unit sphere for all t.

2) Does convergence happen for some curves, when passed to f over an orbit of high order. Further what is the curve that the orbit of 
f^n(N(t)) is converging to.

3.) Categorizing behavior of families of curves in the dynamical system based on the results.




