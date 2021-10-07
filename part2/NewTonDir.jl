# This function solves Newton direction

function NewTonDir(MM,ak,bk,ck,X,U,Lambda,mu,barX0)
    # result vector
    Gradxu,Gradf,Diag,G = zeros(2*MM+1),zeros(MM+1),zeros(2*MM+1),zeros(MM+1,2*MM+1);
    Lag = 0;

    # construct B
    B = mu*Diagonal(ones(2*MM+1));

    # Go over 1:MM
    for k = 1:MM
        Lag += ak[k]*X[k]^2 + bk[k]*U[k]^2 + ck[k]*sin(X[k])^2 + Lambda[k]*X[k] - (X[k] + U[k] + sin(X[k]))*Lambda[k+1]

        Gradxu[2*k-1] = 2*ak[k]*X[k] + ck[k]*sin(2*X[k]) + Lambda[k] - (1+cos(X[k]))*Lambda[k+1]
        Gradxu[2*k] = 2*bk[k]*U[k] - Lambda[k+1]
        Diag[2*k-1] = 2*ak[k] + 2*ck[k]*cos(2*X[k]) + sin(X[k])*Lambda[k+1]
        Diag[2*k] = 2*bk[k]

        Gradf[k+1] = X[k+1] - (X[k]+U[k]+sin(X[k]))
        G[k+1,2*k-1], G[k+1,2*k], G[k+1,2*k+1] = -1-cos(X[k]), -1, 1
    end
    Lag += (ak[end]+mu/2)*X[end]^2 + ck[end]*sin(X[end])^2 + Lambda[end]*X[end] - Lambda[1]*barX0
    Gradxu[end] = 2*ak[end]*X[end] + ck[end]*sin(2*X[end]) + Lambda[end] + mu*X[end]
    Diag[end] = 2*ak[end] + 2*ck[end]*cos(2*X[end]) + mu
    Gradf[1] = X[1] - barX0
    G[1,1] = 1
    H = Diagonal(Diag)

    # Construct KKT
    KKT = hcat(vcat(B, G), vcat(transpose(G), zeros(MM+1, MM+1)) );
    Grad = vcat(Gradxu, Gradf);

    # solve Newton's direction
    NewDir = lu(KKT)\-Grad;

    return NewDir, H, G, Grad, Lag
end
