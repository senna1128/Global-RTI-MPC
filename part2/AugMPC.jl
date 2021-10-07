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
    Idmu = length(mu);
    # result vector
    AugRes, AugTime, AugFinalIndex = Array{Array}(undef, IdM, Idmu), zeros(IdM, Idmu, rep), zeros(IdM, Idmu, rep);

    # iterative over prediction horizon length
    for Idm = 1:IdM
        for idmu = 1:Idmu
            MM = M[Idm];
            mmu = mu[idmu]
            Res, Time, FinalIndex = AugMPCNLP(N, MM, Ak, Bk, Ck, mmu, eta1, eta2, beta, rho, eps, barX0, rep)
            # save results
            AugRes[Idm, idmu], AugTime[Idm,idmu,:], AugFinalIndex[Idm,idmu,:] = Res, Time, FinalIndex
        end
    end

    # return results
    return AugRes, AugTime, AugFinalIndex
end
