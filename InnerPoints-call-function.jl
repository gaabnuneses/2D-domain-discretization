include("InnerPoints-functions.jl")
include("InnerPoints-visualization.jl")

function dados()
    np = 25
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

np,nos,elem,radii=dados()
NOS,ELEM = createBoundary(np,nos,elem,radii)
P_int = CreateInnerMinDist(NOS,ELEM,.75)

plotNOSELEM(NOS,nos)
plotPi(P_int)
