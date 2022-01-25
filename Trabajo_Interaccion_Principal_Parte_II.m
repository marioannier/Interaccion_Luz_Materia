
lambda_inic = 0.4;
lambda_final = 0.7;

theta = 0;

%lambda = 0.8; %para una lambda de incidencia en um
material_Uno = 'Air';
material_Dos = 'PMMA';


%anadiendo la extension 
extension = '.csv';
material_ext = strcat(material_Dos,extension); %concatenando los valores para onbetenr el nombre del archivo en correspondencia con material

%funcion que recibe el nombre del material y el rango de frecuencia inicial
%y frecuencia final que se quiere visualizar
[lambdas,n_experim,k_experim,Nt_complejo] = leer_valores_exp(material_ext,lambda_inic,lambda_final); 

%Obtengo cuantas lambdas se van a usar en el barrido
n_lambdas = numel(lambdas);

%Creo los vectores con la cantidad de valores de barrido
r_per= zeros(1,n_lambdas);
t_per =zeros(1,n_lambdas);
r_par =zeros(1,n_lambdas);
t_par =zeros(1,n_lambdas);
R_per= zeros(1,n_lambdas);
T_per =zeros(1,n_lambdas);
R_par =zeros(1,n_lambdas);
T_par =zeros(1,n_lambdas);


ni=zeros(1,n_lambdas);
nt=zeros(1,n_lambdas);

%theta_t = zeros(1,n_lambdas);

for i=1:1:n_lambdas
    %Medio donde viaja la luz antes de incidir en el material
    if strcmpi(material_Uno,'PMMA')
        [epsilon] = Drude_Lorentz(lambdas(i) , 'Diele', material_Uno);
    else
        [epsilon] = Drude_Lorentz(lambdas(i) , 'DL', material_Uno);
    end
    [n, k, ni(i)] = Val_N_Complejo (epsilon);

    %Medio donde se trasmite la luz
    if strcmpi(material_Dos,'PMMA')
        [epsilon] = Drude_Lorentz(lambdas(i), 'Diele', material_Dos);
    else
        [epsilon] = Drude_Lorentz(lambdas(i) , 'DL', material_Dos);
    end
    [n, k, nt(i)] = Val_N_Complejo (epsilon);


    theta_t = asind(ni(i).*sind(theta)./nt(i));
    theta_t=real(theta_t);

    %calculo de los coeficientes de Fresnel
    [r_per(i),t_per(i),r_par(i),t_par(i)] = Coef_Fresnel(theta,theta_t,ni(i),nt(i));
    %Calculo de los Factores de Tx y Rf de Energía
    [R_per(i),T_per(i),R_par(i),T_par(i)] = Factores_de_R_y_T(ni(i),nt(i),theta,theta_t,r_per(i),t_per(i),r_par(i),t_par(i));

end

if strcmpi(material_Dos,'PMMA')
    %POLARIZACION
    [Ref_T,Tras_T,Dif_Fase_ER,Dif_Fase_ET] = Polarizacion(R_par,R_per,T_par,T_per,'PL');

    figure(),
    hold on
    plot (lambdas,Ref_T,'r',lambdas,Tras_T,'b',LineWidth=1.8)
    title('Factor de Reflexión y Trasmisión de Energía polarización lineal')
    grid on
    xlabel('Longitud de onda \mum')
    ylabel('Factor de Energía')
    legend('Reflejado', 'Trasmitido')
    ylim([-0.05 1.05])

    [Ref_T,Tras_T,Dif_Fase_ER,Dif_Fase_ET] = Polarizacion(r_par,r_per,t_par,t_per,'PC');
    %plot Campo E Polarizacion circular
    figure(),
    hold on
    plot (lambdas,Ref_T,'r',lambdas,Tras_T,'b',LineWidth=1.8)
    title('Factor de Reflexión y Trasmisión de Energía polarización circular')
    grid on
    xlabel('Ángulos de Incidencia (grados)')
    ylabel('Factor de Energía')
    legend('Reflejado', 'Trasmitido')

    [Ref_T,Tras_T,Dif_Fase_ER,Dif_Fase_ET] = Polarizacion(r_par,r_per,t_par,t_per,'PE');
    %plot Campo E Polarizacion elíptica levógira

    figure(),
    hold on
    plot (lambdas,Ref_T,'r',lambdas,Tras_T,'b',LineWidth=1.8)
    title('Factor de Reflexión y Trasmisión de Energía polarización elíptica levógira')
    grid on
    xlabel('Longitud de onda \mum')
    ylabel('Factor de Energía')
    legend('Reflejado', 'Trasmitido')
end
if strcmpi(material_Dos,'Al')
    %POLARIZACION
    [Ref_T,Tras_T,Dif_Fase_ER,Dif_Fase_ET] = Polarizacion(R_par,R_per,T_par,T_per,'PL');
    %plot Campo E Polarizacion lineal
    figure(),
    hold on
    plot (lambdas,Ref_T,'r',lambdas,Tras_T,'b',LineWidth=1.8)
    title('Factor de Reflexión y Trasmisión de Energía polarización lineal')
    grid on
    xlabel('Longitud de onda \mum')
    ylabel('Factor de Energía')
    legend('Reflejado', 'Trasmitido')
    %ylim([-1 1.5])

    [Ref_T,Tras_T,Dif_Fase_ER,Dif_Fase_ET] = Polarizacion(r_par,r_per,t_par,t_per,'PC');
    %plot Campo E Polarizacion circular
    figure(),
    hold on
    plot (lambdas,Ref_T,'r',lambdas,Tras_T,'b',LineWidth=1.8)
    title('Factor de Reflexión y Trasmisión de Energía polarización circular')
    grid on
    xlabel('Longitud de onda \mum')
    ylabel('Factor de Energía')
    legend('Reflejado', 'Trasmitido')

    [Ref_T,Tras_T,Dif_Fase_ER,Dif_Fase_ET] = Polarizacion(r_par,r_per,t_par,t_per,'PE');
    %plot Campo E Polarizacion elíptica levógira
    figure(),
    hold on
    plot (lambdas,Ref_T,'r',lambdas,Tras_T,'b',LineWidth=1.8)
    title('Factor de Reflexión y Trasmisión de Energía polarización elíptica levógira')
    grid on
    xlabel('Longitud de onda \mum')
    ylabel('Factor de Energía')
    legend('Reflejado', 'Trasmitido')
    
end


%% Comparación con Lumerical
if strcmpi(material_Dos,'Al')
    Val_Lumerical = importdata('Air Al 0.4 0.7 R valor absoluto.txt');
    Val_Lumerical_Data=Val_Lumerical.data;
    lambas_L = Val_Lumerical_Data(:,1);
    Coef = Val_Lumerical_Data(:,2);

    figure(),
    hold on
    plot (lambdas,R_par,'r',lambdas,T_par,'b','LineStyle','--',LineWidth=1.9)
    title('Factor de Energía Vs Longitud de onda \mum para Aluminio')
    grid on
    xlabel('Longitud de onda \mum')
    ylabel('Factor de Energia')

    plot (lambas_L,Coef,'g',LineWidth=1.9)
    Val_Lumerical = importdata('Air Al 0.4 0.7 T valor absoluto.txt');
    Val_Lumerical_Data=Val_Lumerical.data;
    lambas_L = Val_Lumerical_Data(:,1);
    Coef = Val_Lumerical_Data(:,2);

    plot (lambas_L,Coef,'Y',LineWidth=1.9)
    legend('R calculado','T calculado','R Lumerical','T Lumerical')
    ylim([-0.1 1.1])

elseif(strcmpi(material_Dos,'PMMA'))
        Val_Lumerical = importdata('Air PMMA 0.4 0.7 R valor absoluto.txt');
    Val_Lumerical_Data=Val_Lumerical.data;
    lambas_L = Val_Lumerical_Data(:,1);
    Coef = Val_Lumerical_Data(:,2);

    figure(),
    hold on
    plot (lambdas,R_par,'r',lambdas,T_par,'b','LineStyle','--',LineWidth=1.9)
    title('Factor de Energía Vs Longitud de onda \mum para PMMA')
    grid on
    xlabel('Longitud de onda \mum')
    ylabel('Factor de Energia')

    plot (lambas_L,Coef,'g',LineWidth=1.8)
    Val_Lumerical = importdata('Air PMMA 0.4 0.7 T valor absoluto.txt');
    Val_Lumerical_Data=Val_Lumerical.data;
    lambas_L = Val_Lumerical_Data(:,1);
    Coef = Val_Lumerical_Data(:,2);

    plot (lambas_L,Coef,'Y',LineWidth=1.8)
    legend('R calculado','T calculado','R Lumerical','T Lumerical')
    ylim([-0.1 1.1])

end

%% polarizacion de la onda resultante

lambda_inic = 0.7;
lambda_final = 0.7;

theta = 30;

%lambda = 0.8; %para una lambda de incidencia en um
material_Uno = 'Air';
material_Dos = 'PMMA';


%anadiendo la extension 
extension = '.csv';
material_ext = strcat(material_Dos,extension); %concatenando los valores para onbetenr el nombre del archivo en correspondencia con material

%funcion que recibe el nombre del material y el rango de frecuencia inicial
%y frecuencia final que se quiere visualizar
[lambdas,n_experim,k_experim,Nt_complejo] = leer_valores_exp(material_ext,lambda_inic,lambda_final); 

%Obtengo cuantas lambdas se van a usar en el barrido
n_lambdas = numel(lambdas);

%Creo los vectores con la cantidad de valores de barrido
r_per= zeros(1,n_lambdas);
t_per =zeros(1,n_lambdas);
r_par =zeros(1,n_lambdas);
t_par =zeros(1,n_lambdas);
R_per= zeros(1,n_lambdas);
T_per =zeros(1,n_lambdas);
R_par =zeros(1,n_lambdas);
T_par =zeros(1,n_lambdas);


ni=zeros(1,n_lambdas);
nt=zeros(1,n_lambdas);

%theta_t = zeros(1,n_lambdas);

for i=1:1:n_lambdas
    %Medio donde viaja la luz antes de incidir en el material
    if strcmpi(material_Uno,'PMMA')
        [epsilon] = Drude_Lorentz(lambdas(i) , 'Diele', material_Uno);
    else
        [epsilon] = Drude_Lorentz(lambdas(i) , 'DL', material_Uno);
    end
    [n, k, ni(i)] = Val_N_Complejo (epsilon);

    %Medio donde se trasmite la luz
    if strcmpi(material_Dos,'PMMA')
        [epsilon] = Drude_Lorentz(lambdas(i), 'Diele', material_Dos);
    else
        [epsilon] = Drude_Lorentz(lambdas(i) , 'DL', material_Dos);
    end
    [n, k, nt(i)] = Val_N_Complejo (epsilon);

    theta_t = asind(ni(i).*sind(theta)./nt(i));
    theta_t=real(theta_t);

    %calculo de los coeficientes de Fresnel
    [r_per(i),t_per(i),r_par(i),t_par(i)] = Coef_Fresnel(theta,theta_t,ni(i),nt(i));
    %Calculo de los Factores de Tx y Rf de Energía
    [R_per(i),T_per(i),R_par(i),T_par(i)] = Factores_de_R_y_T(ni(i),nt(i),theta,theta_t,r_per(i),t_per(i),r_par(i),t_par(i));

end


%Polarizacion lineal
[~,~,Dif_Fase_ER,Dif_Fase_ET, E_Amplitud_RP, E_Amplitud_RS, E_Amplitud_TP, E_Amplitud_TS] = Polarizacion(r_par,r_per,t_par,t_per,'PL');
[Polarizacion_R,Polarizacion_T] = Polarizacion_Onda_Salida (Dif_Fase_ER,Dif_Fase_ET,E_Amplitud_RP, E_Amplitud_RS, E_Amplitud_TP, E_Amplitud_TS, material_Dos);
s1 = 'El resultado de incidencia con Polarización Lineal sobre (';
s2 = ') es para la luz Trasmitida:';
s3 = ' y para la luz Reflejada:';
s = strcat (s1,material_Dos,s2,Polarizacion_T);
ss = strcat (s3,Polarizacion_R);
disp(s)
disp(ss)

%Polarizacion Circular
[~,~,Dif_Fase_ER,Dif_Fase_ET, E_Amplitud_RP, E_Amplitud_RS, E_Amplitud_TP, E_Amplitud_TS] = Polarizacion(r_par,r_per,t_par,t_per,'PC');
[Polarizacion_R,Polarizacion_T] = Polarizacion_Onda_Salida (Dif_Fase_ER,Dif_Fase_ET,E_Amplitud_RP, E_Amplitud_RS, E_Amplitud_TP, E_Amplitud_TS, material_Dos);
s1 = 'El resultado de incidencia con Polarización Circular sobre (';
s2 = ') es para la luz Trasmitida:';
s3 = ' y para la luz Reflejada:';
s = strcat (s1,material_Dos,s2,Polarizacion_T);
ss = strcat (s3,Polarizacion_R);
disp(s)
disp(ss)


%Polarizacion Elíptica
[~,~,Dif_Fase_ER,Dif_Fase_ET, E_Amplitud_RP, E_Amplitud_RS, E_Amplitud_TP, E_Amplitud_TS] = Polarizacion(r_par,r_per,t_par,t_per,'PE');
[Polarizacion_R,Polarizacion_T] = Polarizacion_Onda_Salida (Dif_Fase_ER,Dif_Fase_ET,E_Amplitud_RP, E_Amplitud_RS, E_Amplitud_TP, E_Amplitud_TS, material_Dos);
s1 = 'El resultado de incidencia con Polarización Eliptica sobre (';
s2 = ') es para la luz Trasmitida:';
s3 = ' y para la luz Reflejada:';
s = strcat (s1,material_Dos,s2,Polarizacion_T);
ss = strcat (s3,Polarizacion_R);
disp(s)
disp(ss)
