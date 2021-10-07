# This function select parameter eta for augmented Lagrangian


function SelectEta(MM, NewDir, Grad, H, G, MagGrad, eta1, eta2, rho)
    LeftInner,RightInner = 0,0;

    while true
        # construct transfer matrix
        Trans = hcat(vcat(Diagonal(ones(2*MM+1))+eta2*H, eta2*G), vcat(eta1*transpose(G), Diagonal(ones(MM+1))));
        LeftInner = (Trans*Grad)'*NewDir;
        RightInner = - eta2/4*MagGrad^2;
        if LeftInner <= RightInner
            break
        end
        eta1 = eta1 * rho^2;
        eta2 = eta2 / rho;
    end

    return eta1, eta2, LeftInner
end
