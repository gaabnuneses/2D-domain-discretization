using Deldir


function removerDuplicação(Par)
    Par_new = Par[1,:]'
    for i in 2:size(Par,1)
        status = 0
        for j in 1:size(Par_new,1)
            if Par[i,1]==Par_new[j,1] && Par[i,2]==Par_new[j,2]
                status = 1
                break
            end
        end
        if status == 0
            Par_new = [Par_new;Par[i,1] Par[i,2]]
        end
    end
    return Par_new
end

function triangularize(P_int,NOS)
    x = [P_int[:,1];NOS[:,2]]
    y = [P_int[:,2];NOS[:,3]]

    Q = removerDuplicação([x y])
    x = Q[:,1];     y = Q[:,2]
    minx = minimum(x); miny = minimum(y);
    maxx = maximum(x); maxy = maximum(y);
    x = (x .-minx)/(maxx-minx)
    y = (y .-miny)/(maxy-miny)

    del,vor,summ = deldir(x,y)
    Dx, Dy = edges(del)
    Vx, Vy = edges(vor)

    Dx = Dx * (maxx-minx) .+ minx
    Vx = Vx * (maxx-minx) .+ minx
    Dy = Dy * (maxy-miny) .+ miny
    Vy = Vy * (maxy-miny) .+ miny
    return Dx,Dy,Vx,Vy
end
