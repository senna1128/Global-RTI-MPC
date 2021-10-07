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
    # result vector
    L1Res, L1Time, L1FinalIndex = Array{Array}(undef, IdM), zeros(IdM, rep), zeros(IdM, rep);

    # iterative over prediction horizon length
    for Idm = 1:IdM
        MM = M[Idm];
        Res, Time, FinalIndex = L1MPCNLP(N, MM, Ak, Bk, Ck, mu, beta, nu, rho, eps, barX0, rep);
        # save results
        L1Res[Idm], L1Time[Idm,:], L1FinalIndex[Idm,:] = Res, Time, FinalIndex;
    end

    # return results
    return L1Res, L1Time, L1FinalIndex
end
