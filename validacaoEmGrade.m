function [ qtdCamadasOcultas, taxaAprend ] = validacaoEmGrade( dados, qtdClasses, qtdAtributos, qtdEpocas )
    
    
    %% SETUP INICIAL
    grade = zeros(5);
    
    %% TREINANDO A REDE
    for i=1:size(grade)
        for j=1:size(grade)
            
            acuracia = zeros(5, 1);        
            dados = dados(randperm(size(dados, 1)), :); %Embaralhando os dados
            
            % Separando os folds
            fold1 = dados((size(dados, 1)/5)*0+1:size(dados, 1)-(size(dados, 1)-1*(size(dados, 1)/5)),:);
            fold2 = dados((size(dados, 1)/5)*1+1:size(dados, 1)-(size(dados, 1)-2*(size(dados, 1)/5)),:);
            fold3 = dados((size(dados, 1)/5)*2+1:size(dados, 1)-(size(dados, 1)-3*(size(dados, 1)/5)),:);
            fold4 = dados((size(dados, 1)/5)*3+1:size(dados, 1)-(size(dados, 1)-4*(size(dados, 1)/5)),:);
            fold5 = dados((size(dados, 1)/5)*4+1:size(dados, 1)-(size(dados, 1)-5*(size(dados, 1)/5)),:);
            
            for k=1:5 %quantidade de folds de folds
                if (k==1)
                    foldTeste = fold1;
                    foldTrain = vertcat(fold2, fold3, fold4, fold5);
                elseif(k==2)
                    foldTeste = fold2;
                    foldTrain = vertcat(fold1, fold3, fold4, fold5);
                elseif(k==3)
                    foldTeste = fold3;
                    foldTrain = vertcat(fold2, fold1, fold4, fold5);
                elseif(k==4)
                    foldTeste = fold4;
                    foldTrain = vertcat(fold2, fold3, fold1, fold5);
                else
                    foldTeste = fold5;
                    foldTrain = vertcat(fold2, fold3, fold4, fold1);
                end
                
                [W, M] = MLP(foldTrain, qtdClasses, qtdAtributos, 2*j, i/10, qtdEpocas);
                x = foldTeste(:, 1:size(foldTeste, 2)-qtdClasses);
                x = [-ones(size(x, 1), 1) x];
                d = foldTeste (:,qtdAtributos+1:end);
                
                % Calculando acuracia
                count = 0;
                for m=1:size(foldTeste, 1)
                    h = [-1;logsig(W*x(m,:)')];
                    y = calculaSaidaLogistica(M*h)';
                    if ( isequal(y,d(m,:)))
                        count = count+1;
                    end
                end
                acuracia(k) = (count/m);
            end
            grade(i, j) = mean(acuracia);
        end
    end
    [qtdCamadasOcultas, taxaAprend] = getMaxIndex(grade);
    qtdCamadasOcultas = qtdCamadasOcultas*2;
    taxaAprend = taxaAprend/10;
end
