function [t1, t2, t3, t4, t5, t6] = pseudoinversa(arg1, arg2, arg3)
    iteracoes = 0; distancia = 1e+2;    
    x1 = arg1(1); y1 = arg1(2); z1 = arg1(3); 
    x  = arg2(1); y  = arg2(2); z  = arg2(3); 
    t1 = arg3(1); t2 = arg3(2); t3 = arg3(3);
    t4 = arg3(4); t5 = arg3(5); t6 = arg3(6);
    
    while(distancia > 0.1)  
        if(iteracoes > 1000)
            break;
        end

        Jm = jacobianHP3L([t1 t2 t3 t4 t5 t6]);
        % cálculo do erro.
        e(1,1) = x - x1; e(2,1) = y - y1; e(3,1) = z - z1;

        alpha = 0.5;
        dq = alpha*Jm*e;

        % atualização dos ângulos.
        t1 = round(t1 + 180*(dq(1,1))/pi);
        t2 = round(t2 + 180*(dq(2,1))/pi);
        t3 = round(t3 + 180*(dq(3,1))/pi);
        t4 = round(t4 + 180*(dq(4,1))/pi);
        t5 = round(t5 + 180*(dq(5,1))/pi);
        % t6 = 0;

        [x2, y2, z2] = cinematicadiretaHP3L([t1 t2 t3 t4 t5 t6]);

        distancia = pdist([x2, y2, z2; x1, y1, z1], 'euclidean');
        iteracoes = iteracoes + 1;

        x1 = x2; y1 = y2; z1 = z2;
    end    
end