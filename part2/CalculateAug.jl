# This function computes the augmented Lagrangian value

function CalculateAug(MM,ak,bk,ck,X,U,Lambda,barX0,eta1,eta2,mu)
    # result vector
    Gradxu,Gradf = zeros(2*MM+1),zeros(MM+1);
    Lag = 0;

    # Go over 1:MM
    for k = 1:MM
        Lag += ak[k]*X[k]^2 + bk[k]*U[k]^2 + ck[k]*sin(X[k])^2 + Lambda[k]*X[k] - (X[k] + U[k] + sin(X[k]))*Lambda[k+1];

        Gradxu[2*k-1] = 2*ak[k]*X[k] + ck[k]*sin(2*X[k]) + Lambda[k] - (1+cos(X[k]))*Lambda[k+1];
        Gradxu[2*k] = 2*bk[k]*U[k] - Lambda[k+1];

        Gradf[k+1] = X[k+1] - (X[k]+U[k]+sin(X[k]));
    end
    Lag += (ak[end]+mu/2)*X[end]^2 + ck[end]*sin(X[end])^2 + Lambda[end]*X[end] - Lambda[1]*barX0;
    Gradxu[end] = 2*ak[end]*X[end] + ck[end]*sin(2*X[end]) + Lambda[end] + mu*X[end];
    Gradf[1] = X[1] - barX0;

    AugLag1 = Lag + eta2/2*norm(Gradxu)^2 + eta1/2*norm(Gradf)^2;
    return AugLag1
end
