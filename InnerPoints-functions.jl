using Plots, Statistics, LinearAlgebra

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

## CRIAÇÃO DE MALHAS
# ESSA FUNÇÃO FAZ A MESMA COISA QUE O MESHGRID DO MATLAB ~
# FAZ MATRIZES DE COORDENADAS REPLICADAS PARA ESPAÇAMENTO PREDEFINIDO DE X E Y
println("Carregando funções para gerar elementos")
function meshgrid(x,y)
    X = zeros(length(x),length(y))
    Y = zeros(length(x),length(y))

    for i in 1:length(x)
        for j in 1:length(y)
            X[i,j]=x[i]
            Y[i,j]=y[j]
        end
    end
    return X,Y
end

# ESSAS FUNÇÕES GERAM CONTORNOS EM FORMA DE ARCO DE CIRCUNFERÊNCIA
function arcircle(ρ,X,np)
    x1=X[1,1]; x2=X[2,1]
    y1=X[1,2]; y2=X[2,2]

    d = sqrt((x2-x1)^2+(y2-y1)^2)

    if (d/2)>ρ
        println("Erro: A distância entre os pontos é maior do que o diâmetro desejado")
    end

    s = sqrt(ρ^2 - (d/2)^2)
    n = [-(y1-y2);x1-x2]
    N = sqrt(n[1]^2+n[2]^2)
    xo = (x1+x2)/2 - sign(ρ)*n[1]/N*s
    yo = (y1+y2)/2 - sign(ρ)*n[2]/N*s

    xC,yC = discretizeArcCircle(np,x1,x2,y1,y2,xo,yo,ρ)

    return xC,yC
end

function discretizeArcCircle(np,x1,x2,y1,y2,xo,yo,ρ)
    t = 0:(1/np):1
    PontoReta_x = (x2-x1)*t .+x1
    PontoReta_y = (y2-y1)*t .+y1

    XC = [PontoReta_x.-xo PontoReta_y.-yo]
    xC=[]
    yC=[]
    for i in 1:length(PontoReta_y)
        xC =[xC;sign(ρ)*ρ*XC[i,1]/sqrt(XC[i,1]^2+XC[i,2]^2) + xo];
        yC =[yC;sign(ρ)*ρ*XC[i,2]/sqrt(XC[i,1]^2+XC[i,2]^2) + yo];
    end
    # display(xC)
    return xC,yC
end

# ESSA FUNÇÃO VERIFICA SE UM PONTO É INTERNO A UMA CURVA FECHADA
function IsItInner(x,y,NOS,ELEM)
    cc = 0
    for i in 1:size(ELEM,1)
        x1 = NOS[ELEM[i,2],2]
        x2 = NOS[ELEM[i,3],2]
        if x<maximum([x1;x2])
            y1 = NOS[ELEM[i,2],3]
            y2 = NOS[ELEM[i,3],3]
            ymn = minimum([y1;y2])
            ymx = maximum([y1;y2])
            if y<ymx && y>ymn

                xi = (y-y1)*(x2-x1)/(y2-y1)+x1
                if xi>=x
                    cc +=1
                end
            end
        end
    end
    nos = removeDuplicate(NOS)
    cc+=sum((x.<nos[:,2]).&(y.==nos[:,3]))

    if cc==0
        return false
    elseif rem(cc,2)==0
        return false
    else
        return true
    end
end

# ESSA FUNÇÃO CRIA UM ELEMENTO RETILÍNEO
function elemReto(np,x1,x2,y1,y2)
    x = []
    y = []
    dt = 1/np
    for i in 0:np
        x = [x;((x2-x1)*i/np + x1)]
        y = [y;((y2-y1)*i/np + y1)]
    end
    return x,y
end

# ESSA FUNÇÃO É MODIFICÁVEL - PARA CRIAR OS ELEMENTOS NO CONTORNO
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

    # # Plota bonitinho na tela
    # p=scatter(nos[:,2],nos[:,3],aspect_ratio=:equal,color=:black,ms=5,leg=false,axis=false)
    # p=scatter!(NOS[:,2],NOS[:,3],aspect_ratio=:equal,color=:black,ms=3,leg=false,axis=false)
    # display(p)

    return NOS,ELEM
end

# ESSA FUNÇÃO CRIA PONTOS INTERNOS COM DISTANCIAMENTO UNIFORME
function CreateInnerUniform(NOS,ELEM,rm=.1)
    x = NOS[:,2]
    y = NOS[:,3]

    PDP = zeros(0,2)
    for i in 1:length(x)
        repeat = 0
        for j in 1:i
            if j!=i && x[i]==x[j] && y[i]==y[j]
                repeat = 1
                break
            end
        end
        if repeat==0
            PDP = [PDP; x[i] y[i]]
        end
    end

    k=size(PDP,1)
    pdp_min=findmin(PDP[:,2])[2]
    pdp_max=findmax(PDP[:,2])[2]
    Pint = zeros(0,2)
    nite = 0
    cont = 0
    while PDP[pdp_min,2]<PDP[pdp_max,2] || size(PDP,1)>2 || cont<4
        cont += 1
        nite+=1
        # println("Iteração: $nite; altura: $(PDP[pdp_min,2])")
        Pint = [Pint;PDP[pdp_min,1] PDP[pdp_min,2]]
        PDP = removePDP(PDP,pdp_min,rm)
        pdp_min=findmin(PDP[:,2])[2]
        pdp_max=findmax(PDP[:,2])[2]
        crnt = PDP[pdp_min,:]

        if size(PDP,1)<2
            break
        end

        nghb = PDP[closest2(PDP,pdp_min),:]

        u1 = [nghb[1,1]-crnt[1];nghb[1,2]-crnt[2]]
        θ1 = acos((nghb[1,1]-crnt[1])/norm(u1))

        u2 = [nghb[2,1]-crnt[1];nghb[2,2]-crnt[2]]
        θ2 = acos((nghb[2,1]-crnt[1])/norm(u2))
        # print([θ1 θ2])
        if θ2<θ1
            aux = θ1
            θ1 = θ2
            θ2 = θ1
        end
        dθ = (θ2-θ1)/6
        if dθ!=0
            θ = (θ1+dθ):dθ:(θ2-dθ)
            nx = rm*cos.(θ) .+crnt[1]
            ny = rm*sin.(θ) .+crnt[2]
            PDP = [PDP;nx ny]
        end
        if pdp_min!=1
            PDP = PDP[[1:(pdp_min-1);(pdp_min+1):end],:]
        else
            PDP = PDP[2:end,:]
        end

        pdp_min=findmin(PDP[:,2])[2]
        pdp_max=findmax(PDP[:,2])[2]
        # p=scatter(PDP[:,1],PDP[:,2],aspect_ratio=:equal)
        # println([θ1 θ2])
        # display(p)
        # print()
    end
    aux=zeros(0,2)
    for i in 1:size(Pint,1)
        if IsItInner(Pint[i,1],Pint[i,2],NOS,Int.(ELEM))
            aux = [aux;Pint[i,1] Pint[i,2]]
            # Pint = Pint[1:end .!= i,1:end]
        end
    end
    Pint = aux[:,:]
    return Pint
end

# ESSA FUNÇÃO CRIA PONTOS INTERNOS COM MAIOR CONCENTRAÇÃO NOS CONTORNOS
function CreateInnerMinDist(NOS,ELEM,fac)
    x = NOS[:,2]
    y = NOS[:,3]

    PDP = zeros(0,2)
    for i in 1:length(x)
        repeat = 0
        for j in 1:i
            if j!=i && x[i]==x[j] && y[i]==y[j]
                repeat = 1
                break
            end
        end
        if repeat==0
            PDP = [PDP; x[i] y[i]]
        end
    end

    k=size(PDP,1)
    pdp_min=findmin(PDP[:,2])[2]
    pdp_max=findmax(PDP[:,2])[2]
    Pint = zeros(0,2)
    nite = 0
    cont = 0
    while PDP[pdp_min,2]<PDP[pdp_max,2] || size(PDP,1)>2 || cont<4
        cont += 1
        nite+=1
        # println("Iteração: $nite; altura: $(PDP[pdp_min,2])")
        Pint = [Pint;PDP[pdp_min,1] PDP[pdp_min,2]]
        d = distMinBoundary(Pint[end,1],Pint[end,2],NOS)
        rm = fac*(.01 + .1*sqrt(d))
        PDP = removePDP(PDP,pdp_min,rm)
        pdp_min=findmin(PDP[:,2])[2]
        pdp_max=findmax(PDP[:,2])[2]
        crnt = PDP[pdp_min,:]

        if size(PDP,1)<2
            break
        end

        nghb = PDP[closest2(PDP,pdp_min),:]

        u1 = [nghb[1,1]-crnt[1];nghb[1,2]-crnt[2]]
        θ1 = acos((nghb[1,1]-crnt[1])/norm(u1))

        u2 = [nghb[2,1]-crnt[1];nghb[2,2]-crnt[2]]
        θ2 = acos((nghb[2,1]-crnt[1])/norm(u2))
        # print([θ1 θ2])
        if θ2<θ1
            aux = θ1
            θ1 = θ2
            θ2 = θ1
        end
        dθ = (θ2-θ1)/6
        if dθ!=0
            θ = (θ1+dθ):dθ:(θ2-dθ)
            nx = rm*cos.(θ) .+crnt[1]
            ny = rm*sin.(θ) .+crnt[2]
            PDP = [PDP;nx ny]
        end
        if pdp_min!=1
            PDP = PDP[[1:(pdp_min-1);(pdp_min+1):end],:]
        else
            PDP = PDP[2:end,:]
        end

        pdp_min=findmin(PDP[:,2])[2]
        pdp_max=findmax(PDP[:,2])[2]
        # p=scatter(PDP[:,1],PDP[:,2],aspect_ratio=:equal)
        # println([θ1 θ2])
        # display(p)
        # print()
        # p=scatter(PDP[:,1],PDP[:,2],m=4,color=:black)
        # p=scatter!([PDP[pdp_min,1]],[PDP[pdp_min,2]],m=4,color=:red)
        # display(p)
    end
    aux=zeros(0,2)
    for i in 1:size(Pint,1)
        if IsItInner(Pint[i,1],Pint[i,2],NOS,Int.(ELEM))
            aux = [aux;Pint[i,1] Pint[i,2]]
            # Pint = Pint[1:end .!= i,1:end]
        end
    end
    Pint = aux[:,:]
    return Pint
end

# ESSA FUNÇÃO REMOVE UM POTENCIAL PONTO DE UM CONJUNTO
function removePDP(PDP,i,r)
    d = sqrt.((PDP[:,1].-PDP[i,1]).^2+(PDP[:,2].-PDP[i,2]).^2)
    PDP_aux=zeros(0,2)
    for j in 1:size(PDP,1)
        if d[j]>=r && i!=j
            PDP_aux=[PDP_aux;PDP[j,1] PDP[j,2]]
        elseif i==j
            PDP_aux=[PDP_aux;PDP[j,1] PDP[j,2]]
        end
    end
    return PDP_aux
end

# ESSA FUNÇÃO IDENTIFICA OS PONTOS MAIS PRÓXIMOS DE UM PONTO
function closest2(PDP,i)
    d = sqrt.((PDP[:,1].-PDP[i,1]).^2+(PDP[:,2].-PDP[i,2]).^2)
    menorE = [maximum(d), findmax(d)[2]]
    for j in 1:length(d)
        if d[j]!=0 && d[j]<menorE[1] && PDP[j,1]>PDP[i,1]
            menorE = [d[j]; j]
        end
    end
    # print(menorE)

    menorW = [maximum(d), findmax(d)[2]]
    for j in 1:length(d)
        if d[j]!=0 && d[j]<menorW[1] && PDP[j,1]<=PDP[i,1]
            menorW = [d[j]; j]
        end
    end
    ind = Int.([menorE[2];menorW[2]])

    return ind
end

# ESSA FUNÇÃO REMOVE TERMOS DUPLICADOS
function removeDuplicate(NOS)
    NOS_new = NOS[1,:]'
    for i in 2:size(NOS,1)
        status = 0
        for j in 1:size(NOS_new,1)
            if NOS[i,2]==NOS_new[j,2] && NOS[i,3]==NOS_new[j,3]
                status = 1
                break
            end
        end
        if status == 0
            NOS_new = [NOS_new;NOS[i,1] NOS[i,2] NOS[i,3]]
        end
    end
    return NOS_new
end

# ESSA FUNÇÃO IDENTIFICA A MENOR DISTÂNCIA DE UM PONTO A UM PONTO NO CONTORNO
function distMinBoundary(x,y,NOS)
    d = sqrt.((x.- NOS[:,2]).^2+(y.- NOS[:,3]).^2)
    dmin = findmin(d)[1]
    return dmin
end

# ESSA FUNÇÃO DÁ CENTRO E RAIO DO CÍRCULO PARA 3 PONTOS DADOS
function circle3Points(X,Y)
    x1 = X[1];  x2 = X[2];  x3 = X[3];
    y1 = Y[1];  y2 = Y[2];  y3 = Y[3];
    xo =((y2-y3)*y1^2+(-x2^2+x3^2-y2^2+y3^2)*y1+y2^2*y3+(x1^2-x3^2-y3^2)*y2+(-x1^2+x2^2)*y3)
    xo = xo/((-2*x2+2*x3)*y1+(2*x1-2*x3)*y2-2*y3*(x1-x2))
    yo = ((-x2+x3)*x1^2+(x2^2-x3^2+y2^2-y3^2)*x1-x2^2*x3+(x3^2-y1^2+y3^2)*x2+x3*(y1^2-y2^2))
    yo = yo/((2*y2-2*y3)*x1+(-2*y1+2*y3)*x2+2*x3*(y1-y2))
    R = (x1^2-2*x1*x3+x3^2+(y1-y3)^2)*(x2^2-2*x3*x2+x3^2+(y2-y3)^2)*(x1^2-2*x1*x2+x2^2+(y1-y2)^2)
    R = sqrt(R/(4*((y2-y3)*x1+(-y1+y3)*x2+x3*(y1-y2))^2))

    return xo,yo,R
end
