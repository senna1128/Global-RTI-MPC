include("L1MPCNLP.jl")
# This function implements the L1 penalized MPC in the paper
# Input:
  # N: horizon length
  # M: prediction horizon length
  # Ak, Bk, Ck: coefficient of the problem
  # mu, beta, nu, rho: algorithm parameters
  # eps: error threshold
  # barX0: initial state
  # rep: replicate
# Output:
  # L1Res: residual sequence
  # L1Time: consuming time
  # L1FinalIndex: total iterations required

function L1MPC(N, M, Ak, Bk, Ck, mu, beta, nu, rho, eps, barX0, rep)
    IdM = length(M);
    Idmu = length(mu);
    # result vector
    L1Res, L1Time, L1FinalIndex = Array{Array}(undef, IdM, Idmu), zeros(IdM, Idmu, rep), zeros(IdM, Idmu, rep);

    # iterative over prediction horizon length
    for Idm = 1:IdM
        for idmu = 1:Idmu
            MM = M[Idm];
            mmu = mu[idmu];
            Res, Time, FinalIndex = L1MPCNLP(N, MM, Ak, Bk, Ck, mmu, beta, nu, rho, eps, barX0, rep);
            # save results
            L1Res[Idm, idmu], L1Time[Idm,idmu,:], L1FinalIndex[Idm,idmu,:] = Res, Time, FinalIndex;
        end
    end

    # return results
    return L1Res, L1Time, L1FinalIndex
end
