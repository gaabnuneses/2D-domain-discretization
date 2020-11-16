# 2D-domain-discretization (2D)
## Create boundary
We're gonna create a geometry discretization procedure based on given boundary points.

![alt text](https://github.com/gaabnuneses/2D-domain-discretization/blob/main/Boundary.png?raw=true)

Access ``InnerPoints-call-function`` and set your boundary geometry with function ``dados()``

```julia
function dados()
    np = 10 # Integer number of points between nodes
    # Main nodes
    nos = [index x_position y_position]
    # Connection between nodes
    elem = [index node1 node2]
    # Specify if connection is straight or circular (with a non-zero value)
    radii = [R] # Same length of elem.
    # radii[i] = 0 → straight elements 
    # radii[i] != 0 → circular elements 

    return np,nos,elem,radii
end
```

And then you can discretize the boundary with

```julia
NOS,ELEM = createBoundary(np,nos,elem,radii)
```

## Create Inner Points
At ``InnerPoints-functions`` there are two functions to create inner points, use ``CreateInnerUniform`` to create a uniform distribution of domain points or ``CreateInnerMinDist`` to reduce distance between points when located near the boundary.

![alt text](https://github.com/gaabnuneses/2D-domain-discretization/blob/main/Inner.png?raw=true)

Load the following function:

```julia
P_int = CreateInnerMinDist(NOS,ELEM,5)
```

## Delaunay Triangulation and Voronoi Diagram

![alt text](https://github.com/gaabnuneses/2D-domain-discretization/blob/main/Triangle.png?raw=true)

Include ``Triangularization.jl`` and run the following command:

```julia
Dx,Dy,Vx,Vy = triangularize(P_int,NOS)
```


## Visualization
Include ``InnerPoints-visualization.jl`` and run:

```julia

# Boundary
plotNOSELEM(NOS,nos)

# Domain
plotPi(P_int)

# Delaunay Triangulation and Voronoi Diagram
plotΔ(Dx,Dy,Vx,Vy)
```

