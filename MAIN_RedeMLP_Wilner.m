clc;

%% WILNER LUCAS F. DE FRANÇA - 405023
%% CLASSIFICAÇÃO COM REDE MLP

%% INICIALIZANDO OS DADOS DE "COLUNA VERTEBRAL"
dados = load('Coluna_vertebral.dat');
dados = normalizar(dados);
qtdClasses = 3; 
qtdAtributos = 6;
qtdEpocas = 100;
realizacoes = 10;

%% DEFININDO CONJUNTOS DE TREINAMENTO E TESTE
dados = dados(randperm(size(dados, 1)), :); %Embaralhando os dados
conjTreinamento = dados(1:size(dados, 1)-90, :); % 220 (70%) amostras para treinamento
conjTestes = dados (size(dados, 1)-89:end, :); % 90 amostras para testes

%% TREINANDO A REDE
taxaDeAcerto = zeros(realizacoes, 1);
for i=1:realizacoes %Realizacoes
    
    fprintf ('Execução %d\n', i);

    [qtdCamOcultas, taxaAprend] = validacaoEmGrade(conjTreinamento, qtdClasses, qtdAtributos, qtdEpocas);
    [W, M] = MLP(conjTreinamento, qtdClasses, qtdAtributos, qtdCamOcultas, taxaAprend, qtdEpocas);
    
    % Calculando acuracia
    x = conjTestes(:, 1:size(conjTestes, 2)-qtdClasses);
    x = [-ones(size(x, 1), 1) x];
    d = conjTestes (:,qtdAtributos+1:end);
    
    count = 0;
    for j=1:size(conjTestes, 1) %Quantidade de dados do conjunto de testes
        h = [-1;logsig(W*x(j,:)')];
        y = calculaSaidaLogistica(M*h)';
        if ( isequal(y,d(j,:)))
            count = count+1;
        end
    end
    taxaDeAcerto(i) = (count/j);
end

%% RESULTADOS
acuracia = mean(taxaDeAcerto);
fprintf ('Acuracia Média %d\n', acuracia);
figure(1)
plot(taxa_de_acerto, '--');
hold on
for i=1:10
   scatter(i, taxa_de_acerto(i), 'o', 'black');
   hold on;
end
title('Taxa de Acertos para "Coluna"');
xlabel('Execuções');
ylabel('Taxa de acerto');
hold off;
