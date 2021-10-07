# This function select parameter eta for augmented Lagrangian

function SelectNu(MM, ak, bk, ck, X, U, NewDir, Grad, rho, nu, mu)
    D1, D2 = 0, norm(Grad[2*MM+2:end],1);
    for k = 1:MM
        D1 += (2*ak[k]*X[k]+ck[k]*sin(2*X[k]))* NewDir[2*k-1];
        D1 += 2*bk[k]*U[k]*NewDir[2*k];
    end
    D1 += ((2*ak[end] + mu)*X[end]+ck[end]*sin(2*X[end]))*NewDir[2*MM+1];

    nu = max(D1/(rho-1)/D2, nu);
    InnerProd = D1 - nu*D2;

    return nu, InnerProd
end
