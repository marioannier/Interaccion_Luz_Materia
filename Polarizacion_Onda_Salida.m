function [Polarizacion_R,Polarizacion_T] = Polarizacion_Onda_Salida (Dif_Fase_ER,Dif_Fase_ET,E_Amplitud_RP, E_Amplitud_RS, E_Amplitud_TP, E_Amplitud_TS, material)
  
    
    Circular=Dif_Fase_ER/(pi/2);
    Lineal=rem(Dif_Fase_ER,pi);
    Resto=rem(Circular,2);
    Polarizacion_T = 'No existe';
    
    % Analisis para el campo resultante reflejado
    
    if E_Amplitud_RP == E_Amplitud_RS && Resto~=0 && Circular<0
        Polarizacion_R = 'Circular levógira';
    elseif E_Amplitud_RP == E_Amplitud_RS && Resto~=0 && Circular>0
        Polarizacion_R = 'Circular dextrógira';
    elseif Lineal==0
        Polarizacion_R = 'Polarización es lineal';
    elseif Dif_Fase_ER < 0
        Polarizacion_R = 'Elíptica levógira';
    elseif  Dif_Fase_ER > 0
        Polarizacion_R = 'Elíptica dextrógira';
    else
        disp('Ha habido un error')
    end
    
    %Analisis para el campo resultante transmitido en caso de PMMA
    
    if strcmp(material,'PMMA')
    
        Circular=Dif_Fase_ET/(pi/2);
        Lineal=rem(Dif_Fase_ET,pi);
        Resto=rem(Circular,2);
    
        if E_Amplitud_TP == E_Amplitud_TS && Resto~=0 && Circular<0
            Polarizacion_T = 'Circular levógira';
        elseif E_Amplitud_RP == E_Amplitud_RS && Resto~=0 && Circular>0
            Polarizacion_T = 'Circular dextrógira';
        elseif Lineal==0
            Polarizacion_T = 'Polarización es lineal';
        elseif Dif_Fase_ET < 0
            Polarizacion_T = 'Elíptica levógira';
        elseif  Dif_Fase_ET > 0
            Polarizacion_T = 'Elíptica dextrógira';
        else
            disp('Ha habido un error')
        end
    
    end
end
