

Params = Parameters(true,
                    250,                   # N
                    [5,10,15],             # M
                    [k for k = 1:250],     # Ak
                    [k for k = 1:250],     # Bk
                    [k for k = 1:250],     # Ck
                    [1,5,10,100,500,1000],         # mu
                    1,                    # eta1
                    1,                     # eta2
                    0.4,                   # beta
                    1,                     # nu
                    1.5,                   # rho
                    1e-8,                  # eps
                    10,                    # barX0
                    1)                     # replication
