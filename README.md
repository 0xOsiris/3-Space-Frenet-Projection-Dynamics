```rs
       _..._                           .-'''-.                                                       .-'''-.                          
    .-'_..._''.                       '   _    \                                                    '   _    \                        
  .' .'      '.\  .                 /   /` '.   \                   .              __.....__      /   /` '.   \                       
 / .'           .'|                .   |     \  '                 .'|          .-''         '.   .   |     \  '       .-.          .- 
. '            <  |                |   '      |  '            .| <  |         /     .-''"'-.  `. |   '      |  '.-,.--.\ \        / / 
| |             | |             __ \    \     / /           .' |_ | |        /     /________\   \\    \     / / |  .-. |\ \      / /  
| |             | | .'''-.   .:--.'.`.   ` ..' / _        .'     || | .'''-. |                  | `.   ` ..' /  | |  | | \ \    / /   
. '             | |/.'''. \ / |   \ |  '-...-'`.' |       '--.  .-'| |/.'''. \\    .-------------'    '-...-'`   | |  | |  \ \  / /    
 \ '.          .|  /    | | `" __ | |         .   | /       |  |  |  /    | | \    '-.____...---.               | |  '-    \ `  /     
  '. `._____.-'/| |     | |  .'.''| |       .'.'| |//       |  |  | |     | |  `.             .'                | |         \  /      
    `-.______ / | |     | | / /   | |_    .'.'.-'  /        |  '.'| |     | |    `''-...... -'                  | |         / /       
             `  | '.    | '.\ \._,\ '/    .'   \_.'         |   / | '.    | '.                                  |_|     |`-' /        
                '---'   '---'`--'  `"                       `'-'  '---'   '---'                                          '..'    
                   
```

In Progress: Dynamical System created from mapping of curvature and torsion of image of parametric planar curve when 
stereographically projected to the unit sphere. 

The curvature $\kappa(t)$ and torsion $\tau(t)$ represent the curvature and torsion of the image of the projection of some smooth 
planar curve at some time stamp $t$. $\kappa(t)$ and $\tau(t)$ create a new smooth continuous planar curve that can then be projected. Each iterate of the orbit calculates the new planar curve $\phi(t)$ on the plane $z=-1$ such that $\phi(t)=[\kappa(t),\tau(t), -1]$ of the parametric curve passed. 

The goal is to analyze the behavior of this system for families of smooth planar curves i.e. 

Let $f: \mathbb{R}^2->\mathbb{R}^2$ is defined as $f^1(\phi(t)) = \phi^1(t)=[\kappa^1(t),\tau^1(t)]$ where $\kappa(t)$ and $\tau(t)$ represent the curvature and torsion of the image of $\phi(t)$ on the unit
sphere. Then $f^n(\phi(t)) = \phi^n(t)=[\kappa^n(t),\tau^n(t)]$ would be the $n_{th}$ iterate of $f$ which would be the result of stereographically projecting $[\kappa(t),\tau(t)]$ and recalculating the projected curvature and torsion over $n$ iterates.

The behavior we are hoping to analyze is as follows:

1) Try to find fixed points in the system --> if $\phi(t) =[x(t),y(t)]$ then $f(\phi(t))=\phi^1(t)==> [\kappa(f(\phi(t)),\kappa(f(\phi(t))]=\phi(t)$ where $\kappa(t)$ and $\tau(t)$ represent
the curvature and torsion of the image of $\phi(t)$ on the unit sphere for all $t$. The above result would be the case when $\phi(t)$ represents a planar parametric circle, but is there other cases where this could be true?

2) Does convergence happen for some curves, when passed to $f$ over an orbit of high order. Further what is the curve that the orbit of 
$f^n(\phi(t))$ is converging to. Is it always the same cure? Is it a circle? 

3.) Categorizing behavior of families of curves in the dynamical system based on the results.

Any contributions are welcome, this system is quite complex to build and get fully working for analysis. I am all for collaboration, and feel free to reach out with any inquiries. 



