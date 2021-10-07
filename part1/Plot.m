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
    
    filename = ['./Figure/TimeRes.txt'];
    if exist(filename, 'file') == 0
        f = fopen(filename, 'w+');
        fprintf(f, '*** Case %3d *******\n', iii);
        fprintf(f, '      M      logTime    logStd         MaxIter     \n');
        for mm = 1:length(M)
            fprintf(f, 'Aug:  [%3d, %6.4f, %9.4f, %12d]\n', [M(mm), log(mean(AugTime(mm,:))), log(std(AugTime(mm,:))),  max(AugFinalIndex(mm,:))  ]);
            fprintf(f, 'L1:  [%3d, %6.4f, %9.4f, %12d]\n', [M(mm), log(mean(L1Time(mm,:))), log(std(L1Time(mm,:))),  max(L1FinalIndex(mm,:))  ]);
        end 
    else
        f = fopen(filename, 'a+');
        fprintf(f, '*** Case %3d *******\n', iii);
        fprintf(f, '      M      logTime    logStd         MaxIter     \n');
        for mm = 1:length(M)
            fprintf(f, 'Aug:  [%3d, %6.4f, %9.4f, %12d]\n', [M(mm), log(mean(AugTime(mm,:))), log(std(AugTime(mm,:))),  max(AugFinalIndex(mm,:))  ]);
            fprintf(f, 'L1:  [%3d, %6.4f, %9.4f, %12d]\n', [M(mm), log(mean(L1Time(mm,:))), log(std(L1Time(mm,:))),  max(L1FinalIndex(mm,:))  ]);
        end 
    end
    
    % Draw Residual Decay Plot
    for mm = 1:length(M)
        figure(iii*100 + mm*10 + 1);
        Res = AugRes{mm};
        rep = 5;     % plot 5 initialization
        cmap = jet(rep);
        for rrep = 1:rep 
            plot(0:length(Res{rrep})-1,Res{rrep}, '-*', 'color',cmap(rrep, :),'LineWidth',1.5);
            hold on 
        end
        set(gca, 'YScale', 'log')
        ylim([10^(-10) 10^(4.5)])        
        set(gca,'FontSize',15)
        ylabel('$\|\nabla L^{t, 0}\|$','Interpreter', 'latex','Fontsize',30)
        xlabel('$t$','Interpreter', 'latex','Fontsize',35)
        hold off
        filename = ['./Figure/Case' num2str(iii) 'M' num2str(M(mm)) 'Aug.png'];
        print('-dpng', filename) 

        figure(iii*100 + mm*10 + 2);
        Res = L1Res{mm};
        for rrep = 1:rep 
            plot(0:length(Res{rrep})-1,Res{rrep}, '-*', 'color',cmap(rrep, :),'LineWidth',1.5);
            hold on 
        end
        set(gca, 'YScale', 'log')
        ylim([10^(-10) 10^(4.5)])        
        set(gca,'FontSize',15)
        ylabel('$\|\nabla L^{t, 0}\|$','Interpreter', 'latex','Fontsize',30)
        xlabel('$t$','Interpreter', 'latex','Fontsize',35)
        hold off
        filename = ['./Figure/Case' num2str(iii) 'M' num2str(M(mm)) 'L1.png'];
        print('-dpng', filename)
        
    end

    
        
    % Draw Residual Decay Bar Plot
    for mm = 1:length(M)        
        figure(iii*100 + mm*10 + 3);
        Res = AugRes{mm};
        rep = length(Res); 
        max_len = 0;
        for rrep = 1:rep
            max_len = max(max_len, length(Res{rrep}));
        end
        dat_matrix = zeros(max_len,rep);
        for rrep = 1:rep
            dat_matrix(1:length(Res{rrep}),rrep) = Res{rrep};
        end
        errorbar(0:max_len-1,mean(dat_matrix,2),std(dat_matrix,0,2),'-o')
        set(gca, 'YScale', 'log')
        ylim([10^(-12) 10^5])        
        xlim([0 max_len+3])        
        set(gca,'FontSize',15)
        ylabel('$\|\nabla L^{t, 0}\|$','Interpreter', 'latex','Fontsize',30)
        xlabel('$t$','Interpreter', 'latex','Fontsize',35)
        filename = ['./Figure/Case' num2str(iii) 'M' num2str(M(mm)) 'AugB.png'];
        print('-dpng', filename)
        
        figure(iii*100 + mm*10 + 4);
        Res = L1Res{mm};
        rep = length(Res); 
        max_len = 0;
        for rrep = 1:rep
            max_len = max(max_len, length(Res{rrep}));
        end
        dat_matrix = zeros(max_len,rep);
        for rrep = 1:rep
            dat_matrix(1:length(Res{rrep}),rrep) = Res{rrep};
        end
        errorbar(0:max_len-1,mean(dat_matrix,2),std(dat_matrix,0,2),'-o')
        set(gca, 'YScale', 'log')
        ylim([10^(-12) 10^5])        
        xlim([0 max_len+3])
        set(gca,'FontSize',15)
        ylabel('$\|\nabla L^{t, 0}\|$','Interpreter', 'latex','Fontsize',30)
        xlabel('$t$','Interpreter', 'latex','Fontsize',35)
        filename = ['./Figure/Case' num2str(iii) 'M' num2str(M(mm)) 'L1B.png'];
        print('-dpng', filename)         
    end
    
    
end
    
    
    
    
