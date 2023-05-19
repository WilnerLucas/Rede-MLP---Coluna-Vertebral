
function [ y ] = calculaSaidaLogistica( u )

    
    %sigmoid 
    y = zeros(length(u), 1);
    max_valor = max(logsig(u));
    for i=1:length(u)
        if (logsig(u(i))<max_valor)
            y(i) = 0;
        else
            y(i) = 1;
        end
    end
    
end
