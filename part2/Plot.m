%% This fucntion draws plot for simulation
clear all; close all
d = dir('./Solution/*.mat');
A = dir(fullfile('./Figure/*'));
if ~isempty(A)
    for k = 1:length(A)
        delete(strcat('./Figure/', A(k).name))
    end
    fprintf('remove result file. Done!\n')
else
    fprintf('No result file.\n')
end


for iii = 1:length(d)
    load(fullfile('./Solution', d(iii).name)); 
    
    % Draw Residual Decay Plot
    for mm = 1:length(M)
        figure(iii*100 + mm*10 + 1);
        rep = size(AugRes,2);
        cmap = jet(rep);
        for rrep = 1:rep 
            plot(0:length(AugRes{mm,rrep}{1})-1,AugRes{mm,rrep}{1}, '-*', 'color',cmap(rrep, :),'LineWidth',1.5);
            hold on 
        end
        set(gca, 'YScale', 'log')
        set(gca,'FontSize',15)
        ylim([10^(-10) 10^(4.5)])        
        ylabel('$\|\nabla L^{t, 0}\|$','Interpreter', 'latex','Fontsize',30)
        xlabel('$t$','Interpreter', 'latex','Fontsize',35)
        lgd = legend(strcat('\mu = ', num2str(mu(1))),strcat('\mu = ', num2str(mu(2))),...
        strcat('\mu = ',num2str(mu(3))),strcat('\mu = ', num2str(mu(4))), strcat('\mu = ', num2str(mu(5))),...
        strcat('\mu = ',num2str(mu(6))),'Interpreter','latex');
        lgd.FontSize = 20;
%        title('Aug, Case 2, M = 10','Fontsize',20)
        hold off
        filename = ['./Figure/Case' d(iii).name(7) 'M' num2str(M(mm)) 'MUAug.png'];
        print('-dpng', filename) 

        figure(iii*100 + mm*10 + 2);
        for rrep = 1:rep 
            plot(0:length(L1Res{mm,rrep}{1})-1,L1Res{mm,rrep}{1}, '-*', 'color',cmap(rrep, :),'LineWidth',1.5);
            hold on 
        end
        set(gca, 'YScale', 'log')
        set(gca,'FontSize',15)
        ylim([10^(-10) 10^(4.5)])        
        ylabel('$\|\nabla L^{t, 0}\|$','Interpreter', 'latex','Fontsize',30)
        xlabel('$t$','Interpreter', 'latex','Fontsize',35)
        lgd = legend(strcat('\mu = ', num2str(mu(1))),strcat('\mu = ', num2str(mu(2))),...
        strcat('\mu = ',num2str(mu(3))),strcat('\mu = ', num2str(mu(4))), strcat('\mu = ', num2str(mu(5))),...
        strcat('\mu = ',num2str(mu(6))),'Interpreter','latex');
        lgd.FontSize = 20;
%        title('L1')
        hold off
        filename = ['./Figure/Case' d(iii).name(7) 'M' num2str(M(mm)) 'MUL1.png'];
        print('-dpng', filename)
    end
end
        

    
    
    
    
    
    
