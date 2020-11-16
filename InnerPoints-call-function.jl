## GEOMETRIA DO CONTORNO
# Altere para modificar a geometria
function dados()
    np = 10
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

## GERAÇÃO DE PONTOS INTERNOS ####
include("InnerPoints-functions.jl")

# Obtem dados
np,nos,elem,radii=dados()

# Cria contorno discretizado
NOS,ELEM = createBoundary(np,nos,elem,radii)

# Gera pontos internos com distribuição de densidade proporcional
# à distância do contorno
P_int = CreateInnerMinDist(NOS,ELEM,5)

## VISUALIZAÇÃO ###
include("InnerPoints-visualization.jl")

# Plota o contorno
plotNOSELEM(NOS,nos)

# Plota os pontos internos
plotPi(P_int)

## GERAÇÃO DE MALHA TRIANGULAR ####
include("Triangularization.jl")
plot()
Dx,Dy,Vx,Vy = triangularize(P_int,NOS)
plotΔ(Dx,Dy,Vx,Vy,false,true)
