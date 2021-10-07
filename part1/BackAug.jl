include("CalculateAug.jl")
# This function implements backtracking line search to find
# the stepsize for augmented Lagrangian

function BackAug(MM,ak,bk,ck,X,U,Lambda,barX0,NewDir,Grad,Lag,mu,eta1,eta2,beta,InnerProd,srate = 0.9,thres = 0.0001)
    # Compute Augmented Lagrangian at the current iterates
    X1, U1, Lambda1, stepsize = zeros(MM+1,1), zeros(MM,1), zeros(MM+1,1), 1;
    AugLag0 = Lag + eta2/2*norm(Grad[1:2*MM+1])^2 + eta1/2*norm(Grad[2*MM+2:end])^2;

    while true
        X1 = X + stepsize*[NewDir[2*k-1] for k = 1:MM+1];
        U1 = U + stepsize*[NewDir[2*k] for k = 1:MM];
        Lambda1 = Lambda + stepsize*NewDir[2*MM+2:end];
        AugLag1 = CalculateAug(MM,ak,bk,ck,X1,U1,Lambda1,barX0,eta1,eta2,mu);

        if AugLag1 <= AugLag0 + stepsize*beta*InnerProd || stepsize <= thres
            break
        end
        stepsize *= srate;
    end
    return X1, U1, Lambda1
end
