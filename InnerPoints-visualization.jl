## Plota o contorno
function plotNOSELEM(NOS,nos)
    p=scatter(nos[:,2],nos[:,3],aspect_ratio=:equal,color=:black,ms=5,leg=false,axis=false)
    p=scatter!(NOS[:,2],NOS[:,3],aspect_ratio=:equal,color=:black,ms=3,leg=false,axis=false)
    for i in 1:size(ELEM,1)
        i1 = Int(ELEM[i,2])
        i2 = Int(ELEM[i,3])
        x1 = NOS[i1,2]; y1 = NOS[i1,3];
        x2 = NOS[i2,2]; y2 = NOS[i2,3];
        # @show [x1;x2],[y1;y2]
        plot!([x1;x2],[y1;y2],color=:black)
    end
    display(p)
end

## Plota os pontos internos
function plotPi(P_int)
    X = P_int[:,1]
    Y = P_int[:,2]
    scatter!(X,Y,m = (3.0, 1.0, :Purple, stroke(0, :blue)),color=:purple,aspect_ratio=:equal)
end

## Plota triangularization
function plotΔ(Dx,Dy,Vx,Vy,vor=false,del=true)
    if vor==true
        Vtrue = zeros(length(Vx))
        for i in 1:length(Vx)-1
            Vmx = .5*(Vx[i]+Vx[i+1])
            Vmy = .5*(Vy[i]+Vy[i+1])
            if isnan(Vmx)
            else
                inner = IsItInner(Vmx,Vmy,NOS,Int.(ELEM))
                if inner == 1
                    Vtrue[i] = 1
                    Vtrue[i+1] = 1
                else
                    Vtrue[i] = NaN
                    Vtrue[i+1] = NaN
                end
            end
        end
        Vx = Vx.*Vtrue
        Vy = Vy.*Vtrue
        p = plot!(Vx, Vy, label = "Voronoi diagram",aspect_ratio=:equal,color=:gray,ls=:dash)
    end
    if del==true
        Dtrue = zeros(length(Dx))
        for i in 1:length(Dx)-1
            Dmx = .5*(Dx[i]+Dx[i+1])
            Dmy = .5*(Dy[i]+Dy[i+1])
            if isnan(Dmx)
            else
                inner = IsItInner(Dmx,Dmy,NOS,Int.(ELEM))
                if inner == 1
                    Dtrue[i] = 1
                    Dtrue[i+1] = 1
                else
                    Dtrue[i] = NaN
                    Dtrue[i+1] = NaN
                end
            end
        end
        Dx = Dx.*Dtrue
        Dy = Dy.*Dtrue
        p = plot!(Dx, Dy,m = (3.0, 1.0, :Purple, stroke(0, :blue)), label = "Delaunay triangulation",aspect_ratio=:equal,color=:black)
    end
    display(p)
end
