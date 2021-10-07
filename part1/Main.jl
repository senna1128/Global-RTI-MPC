## Main File
# Change working directory
cd("$(homedir())/.../part1")


# Using packages
using JuMP
using Ipopt
using DataFrames
using PyPlot
using MATLAB
using Glob
using Random
using Distributions
using LinearAlgebra



# Pamareter class
struct Parameters
    verbose         # Do we create dump dir?
    ## Temporal horizon parameters
    N::Int          # horizon length
    M::Array          # short horizon length
    ## Problem parameters
    Ak::Array       # coefficient 1
    Bk::Array       # coefficient 2
    Ck::Array       # coefficient 3
    ## Algorithmic parameters
    mu::Float64     # scale Parameter
    eta1::Float64   # augmented Lagrange penalty parameter
    eta2::Float64   # augmented Lagrange penalty parameter
    beta::Float64   # armijo parameter between 0 and 1
    nu::Float64     # l1 penalized merit function
    rho::Float64    # scalar greater than 1
    eps::Float64    # error threshold
    barX0::Float64  # initial state
    ## Replications
    rep::Int        # replication times
end

struct Parameters
    verbose         # Do we create dump dir?
    ## Temporal horizon parameters
    N::Int          # horizon length
    M::Array          # short horizon length
    ## Problem parameters
    Ak::Array       # coefficient 1
    Bk::Array       # coefficient 2
    Ck::Array       # coefficient 3
    ## Algorithmic parameters
    mu::Float64     # scale Parameter
    eta1::Float64   # augmented Lagrange penalty parameter
    eta2::Float64   # augmented Lagrange penalty parameter
    beta::Float64   # armijo parameter between 0 and 1
    nu::Float64     # l1 penalized merit function
    rho::Float64    # scalar greater than 1
    eps::Float64    # error threshold
    barX0::Float64  # initial state
    ## Replications
    rep::Int        # replication times
end

# load file
include("AugMPC.jl")
include("L1MPC.jl")


# main function
function main()
    AllParam = glob("./Parameter/Param*")
    for CaseId = 1:length(AllParam)
        include(AllParam[CaseId])
        _main(params, AllParam[CaseId])
    end
end




function _main(params, f)
    # Temporal horizon parameter
    N, M, = Params.N, Params.M;
    # Problem parameter
    Ak, Bk, Ck = Params.Ak, Params.Bk, Params.Ck;
    # Algorithmic parameter
    mu, eta1, eta2, beta, nu, rho = Params.mu, Params.eta1, Params.eta2, Params.beta, Params.nu, Params.rho;
    # other parameter
    IdDir, eps, barX0, rep = Params.verbose, Params.eps, Params.barX0, Params.rep;

    prof = true;

    # Apply Augmented Lagrangian MPC
    AugRes, AugTime, AugFinalIndex = AugMPC(N, M, Ak, Bk, Ck, mu, eta1, eta2, beta, rho, eps, barX0, rep)

    # Apply L1 Lagrangian MPC
    L1Res, L1Time, L1FinalIndex = L1MPC(N, M, Ak, Bk, Ck, mu, beta, nu, rho, eps, barX0, rep)

    if prof
        println("---------------------")
        println("|  Julia Profiling  |")
        println("---------------------")
        println("Finished")
    end

    # save result
    if IdDir
        filename = "./Solution/" * f[end-9:end-3] * ".mat"
        write_matfile(filename; AugRes, AugTime, AugFinalIndex, L1Res, L1Time, L1FinalIndex, M)
    end

end

main()
