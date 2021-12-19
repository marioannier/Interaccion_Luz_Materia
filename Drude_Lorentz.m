function [epsilon,epsilon_L,epsilon_D] = Drude_Lorentz(lambda , model, material)
%Esta función se encarga de aplicar el modelo de interacción de
%Drude-Lorentz a un material para una longitud de onda específica.
%Recibe como parámetros de entrada: lambda (longitud de onda en [nm]),
%modelo ("D" Drude o "DL" Drude-Lorentz), y el material
%("Air","Al","N-BK7"). Devuelve los valores de Epsilon correspondiente a al 
%Efectos intrabanda en metales, Efectos interbanda y la suma total. 



%convierto lambda a [m]
lambda=lambda.*(10^(-6));


switch model
    case 'D' %Modelo de Drude(D)
        %Datos del Material ('material')y Constantes Físicas
        [omegap,f,Gamma,omega,order,twopic,omegalight,invsqrt2,ehbar] = Obtener_Datos_Material(material,lambda);
        %*********************************************************************
        % Modelo de Drude (Efectos intrabanda en metales)
        %*********************************************************************

        epsilon_D = ones(size(lambda))-((f(1)*omegap^2)*(omegalight.^2 + 1i*Gamma(1)*omegalight).^(-1));
        %epsilon = epsilon_D;
        epsilon_L = 0;

    case 'DL' %Modelo de Drude-Lorentz(DL)
        %Datos del Material ('material')y Constantes Físicas
        [omegap,f,Gamma,omega,order,twopic,omegalight,invsqrt2,ehbar] = Obtener_Datos_Material(material,lambda);

        %*********************************************************************
        % Modelo de Drude (Efectos intrabanda en metales)
        %*********************************************************************

        epsilon_D = ones(size(lambda))-((f(1)*omegap^2)*(omegalight.^2 + 1i*Gamma(1)*omegalight).^(-1));
        
        %*********************************************************************
        % Modelo de Drude(D) o de Drude-Lorentz(DL)  (Efectos interbanda)
        %*********************************************************************

        epsilon_L = zeros(size(lambda));
        for k = 2:order % Contribuciones Lorentzianas
            epsilon_L = epsilon_L + (f(k)*omegap^2)*(((omega(k)^2)*ones(size(lambda)) - omegalight.^2)-1i*Gamma(k)*omegalight).^(-1);
        end

    case 'Diele'

        %Datos del Material ('material')y Constantes Físicas
        [epsilon_inf, epsilon_s, omega_t, gamma_cero, omegalight] = Obtener_Datos_Material_Diele(lambda);
        epsilon = epsilon_inf + ((epsilon_s - epsilon_inf).*(omega_t.^2))./((omega_t.^2) -  omegalight.^2 + 1i*gamma_cero * omegalight);
    otherwise
        error('ERROR! Operacion Invalida, Entre ''DL'' or ''D'' or ''Diele''');

end
% Contrubuciones Combinadas de Drude y Lorentz
if ~strcmpi(model,'Diele')
    epsilon = epsilon_D + epsilon_L;

end

end


