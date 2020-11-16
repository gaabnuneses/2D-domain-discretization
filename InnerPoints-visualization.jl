# Plotar bonitinho
function plotNOSELEM(NOS,nos)
    p=scatter(nos[:,2],nos[:,3],aspect_ratio=:equal,color=:black,ms=5,leg=false,axis=false)
    p=scatter!(NOS[:,2],NOS[:,3],aspect_ratio=:equal,color=:black,ms=3,leg=false,axis=false)
    display(p)
end

function plotPi(P_int)
    X = Pi[:,1]
    Y = Pi[:,2]
    scatter!(X,Y,m = (3.0, 1.0, :Purple, stroke(0, :blue)),color=:purple,aspect_ratio=:equal)
end
