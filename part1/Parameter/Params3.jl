

Params = Parameters(true,
                    250,                   # N
                    [5,10,15],             # M
                    [k^2 for k = 1:250],     # Ak
                    [k^2 for k = 1:250],     # Bk
                    [k^2 for k = 1:250],     # Ck
                    20,                     # mu
                    100,                    # eta1
                    1,                     # eta2
                    0.4,                   # beta
                    1,                     # nu
                    1.5,                   # rho
                    1e-8,                  # eps
                    10,                    # barX0
                    1000)                     # replication
