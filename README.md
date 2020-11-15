# Inner-Points
Generate inner points with higher densisty near boundaries

### Load packages
```julia
using Plots, Statistics, LinearAlgebra
```
### Create boundary
 
1. Specify boundary - the set of points refers to the boundary of the example.
```julia
function dados()
    np = 20
    # Main nodes
    nos = [1 -1 -1
           2 1 -1
           3 1 1
           4 -1 1
           5 0 -.5
           6 -.5 0
           7 0 .5
           8 .5 0]
    # Connection between nodes
    elem = [1 1 2
            2 2 3
            3 3 4
            4 4 1
            5 5 6
            6 6 7
            7 7 8
            8 8 5]
    # Specify if connection is straight or circular (with a non-zero value)
    radii = [0.0
             0.0
             0.0
             0.0
             -0.5
             -0.5
             -0.5
             -0.5]

    return np,nos,elem,radii
end
```
2. The previous function return required values to discretize a continuous path between given main nodes using the following:

```julia
function createBoundary(np,nos,elem,radii)

    NOS = zeros(0,3)
    ELEM = zeros(0,3)
    k = 0

    for i in 1:size(elem,1) #Laço nos elementos de ligação
        c = k
        x1 = nos[elem[i,2],2]
        x2 = nos[elem[i,3],2]
        y1 = nos[elem[i,2],3]
        y2 = nos[elem[i,3],3]
        if radii[i]==0           # Elementos retilineos
            x_aux,y_aux=elemReto(np,x1,x2,y1,y2)
            for j in 1:length(x_aux)
                NOS = [NOS;c+j x_aux[j] y_aux[j]]
            end
            for j in 1:(length(x_aux)-1)
                ELEM = [ELEM;c+j c+j c+j+1]
            end
        else  # Elementos circulares
            X = [x1 y1;x2 y2]
            x_aux,y_aux = arcircle(radii[i],X,np)
            for j in 1:length(x_aux)
                NOS = [NOS;c+j x_aux[j] y_aux[j]]
            end
            for j in 1:(length(x_aux)-1)
                ELEM = [ELEM;c+j c+j c+j+1]
            end
        end
        k += np+1
    end

    return NOS,ELEM
end
```
 
