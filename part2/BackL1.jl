include("CalculateL1.jl")
# This function implements backtracking line search to find
# the stepsize for L1 merit function

function BackL1(MM,ak,bk,ck,X,U,Lambda,barX0,NewDir,Grad,mu,nu,beta,InnerProd,srate = 0.9,thres = 0.0001)
    # Compute Augmented Lagrangian at the current iterates
    X1, U1, Lambda1, stepsize = zeros(MM+1,1), zeros(MM,1), zeros(MM+1,1), 1;
    Obj0 = 0;
    for k = 1:MM
        Obj0 += ak[k]*X[k]^2 + bk[k]*U[k]^2 + ck[k]*sin(X[k])^2;
    end
    Obj0 += (ak[end]+mu/2)*X[end]^2 + ck[end]*sin(X[end])^2;

    L1Lag0 = Obj0 + nu*norm(Grad[2*MM+2:end],1);

    while true
        X1 = X + stepsize*[NewDir[2*k-1] for k = 1:MM+1];
        U1 = U + stepsize*[NewDir[2*k] for k = 1:MM];
        Lambda1 = Lambda + stepsize*NewDir[2*MM+2:end];

        L1Lag1 = CalculateL1(MM,ak,bk,ck,X1,U1,barX0,nu,mu);

        if L1Lag1 <= L1Lag0 + stepsize*beta*InnerProd || stepsize <= thres
            break
        end
        stepsize *= srate;
    end
    return X1, U1, Lambda1
end
