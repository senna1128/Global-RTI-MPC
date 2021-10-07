include("NewTonDir.jl")
include("SelectNu.jl")
include("BackL1.jl")
# This function is the main body of L1 penalized MPC

function L1MPCNLP(N, MM, Ak, Bk, Ck, mu, beta, nu, rho, eps, barX0, rep)
    # set random seed
    rng = MersenneTwister(2020);
    # Define result vector
    Res, Time, FinalIndex = Array{Array}(undef, rep), zeros(rep), zeros(rep);
    # Go over replicate
    for rr = 1:rep
        # define residual vector and final index
        res, t = Array{Float64}(undef, 0), 1;
        # Random initialization
        X, U, Lambda = 5*randn!(rng, zeros(MM+1,1)), 5*randn!(rng, zeros(MM,1)), 5*randn!(rng, zeros(MM+1,1));
        # start the iteration
        curtime = time();
        while t <= N - MM
            # run one-step Newton for t-th subproblem
            # problem coefficient
            ak,bk,ck = Ak[t:t+MM],Bk[t:t+MM-1],Ck[t:t+MM];

            # calculate Newton Direction
            NewDir, H, G, Grad, Lag = NewTonDir(MM,ak,bk,ck,X,U,Lambda,mu,barX0);
            # save current residual
            push!(res, norm(Grad))
            # if small, we stop
            if res[end] <= eps
                break
            end
            # select nu
            nu, InnerProd = SelectNu(MM, ak, bk, ck, X, U, NewDir, Grad, rho, nu, mu);
            # backtracking line search to find stepsize and update
            X1, U1, Lambda1 = BackL1(MM,ak,bk,ck,X,U,Lambda,barX0,NewDir,Grad,mu,nu,beta,InnerProd);

            # transit
            barX0 = X1[1] + U1[1] + sin(X1[1]);
            X, U, Lambda = push!(X1[2:end],0), push!(U1[2:end],0), push!(Lambda1[2:end],0);
            t += 1
        end
        Time[rr], FinalIndex[rr], Res[rr] = time() - curtime, t, res;
    end
    return Res, Time, FinalIndex
end
