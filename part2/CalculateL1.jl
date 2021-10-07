# This function calculates the value of L1 penalized function

function CalculateL1(MM,ak,bk,ck,X1,U1,barX0,nu,mu)
    Obj1, Pen1 = 0, 0;
    for k = 1:MM
        Obj1 += ak[k]*X1[k]^2 + bk[k]*U1[k]^2 + ck[k]*sin(X1[k])^2;
        Pen1 += abs(X1[k+1] - (X1[k] + U1[k] + sin(X1[k])) );
    end
    Obj1 += (ak[end] + mu/2)*X1[end]^2 + ck[end]*sin(X1[end])^2;
    Pen1 += abs(X1[1] - barX0);

    return Obj1 + nu*Pen1
end
