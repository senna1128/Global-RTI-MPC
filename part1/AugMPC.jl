include("AugMPCNLP.jl")
# This function implements the Algorithm 1 in the paper
# Input:
  # N: horizon length
  # M: prediction horizon length
  # Ak, Bk, Ck: coefficient of the problem
  # mu, eta1, eta2, beta, rho: algorithm parameters
  # eps: error threshold
  # rep: replicate
# Output:
  # AugRes: residual sequence
  # AugTime: consuming time
  # AugFinalIndex: total iterations required

function AugMPC(N, M, Ak, Bk, Ck, mu, eta1, eta2, beta, rho, eps, barX0, rep)
    IdM = length(M);
    # result vector
    AugRes, AugTime, AugFinalIndex = Array{Array}(undef, IdM), zeros(IdM, rep), zeros(IdM, rep);

    # iterative over prediction horizon length
    for Idm = 1:IdM
        MM = M[Idm];
        Res, Time, FinalIndex = AugMPCNLP(N, MM, Ak, Bk, Ck, mu, eta1, eta2, beta, rho, eps, barX0, rep)
        # save results
        AugRes[Idm], AugTime[Idm,:], AugFinalIndex[Idm,:] = Res, Time, FinalIndex
    end

    # return results
    return AugRes, AugTime, AugFinalIndex
end
