function [ vetorDeDerivadas ] = calculaDerivada( vetor )
   
    vetorDeDerivadas = zeros(1, length(vetor));
    for i=1:length(vetor)
       vetorDeDerivadas(i) = vetor(i)*(1-vetor(i)); 
    end
    
end