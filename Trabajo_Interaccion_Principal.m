%% Coeficientes de Fresnel
theta_i_1 =0;
theta_i_2 =90;
%comprobación de errores en relación con el barrido de ángulos de incidencia
if theta_i_1>theta_i_2
    error('ERROR! Elije un barrido con theta_i_1 <= theta_i_2')
else

%Material Dispersivo para una lambda de incidencia en um y para diferentes
%angulos de incidencia

lambda = 0.8; %para una lambda de incidencia en um
material_Uno = 'Air';
material_Dos = 'Al';

%Medio donde viaja la luz antes de incidir en el material
if strcmpi(material_Uno,'PMMA')
    [epsilon] = Drude_Lorentz(lambda , 'Diele', material_Uno);
else
[epsilon] = Drude_Lorentz(lambda , 'DL', material_Uno);
end
[n, k, ni] = Val_N_Complejo (epsilon);

%Medio donde se trasmite la luz
if strcmpi(material_Dos,'PMMA')
    [epsilon] = Drude_Lorentz(lambda , 'Diele', material_Dos);
else
[epsilon] = Drude_Lorentz(lambda , 'DL', material_Dos);
end
[n, k, nt] = Val_N_Complejo (epsilon);

%trabajando con los coeficientes n complejos
%ni=abs(ni);
%nt=abs(nt);

cant_ang=theta_i_2 - theta_i_1 + 1  ; %determino la cantidad de ángulos de incidencia
                                      %se suma uno porque el arreglo comienza
                                      %en cero y los index de matlab en 1


%Creo los vectores con la cantidad de valores de barrido
r_per= zeros(1,cant_ang);
t_per =zeros(1,cant_ang);
r_par =zeros(1,cant_ang);
t_par =zeros(1,cant_ang);
R_per= zeros(1,cant_ang);
T_per =zeros(1,cant_ang);
R_par =zeros(1,cant_ang);
T_par =zeros(1,cant_ang);
theta_i = (theta_i_1:1:theta_i_2);%variación del ángulo de incidencia;

for i=1:1:cant_ang

    %Calculo del angulo de trasmision (theta_t) por ley de Snell
    theta_t = asind(ni.*sind(theta_i(i))./nt);
    theta_t=real(theta_t);
    %calculo de los coeficientes de Fresnel y angulo de Brewstwr y Critico
    [r_per(i),t_per(i),r_par(i),t_par(i)] = Coef_Fresnel(theta_i(i),theta_t,ni,nt);
    %Calculo de los Factores de Tx y Rf de Energia
    [R_per(i),T_per(i),R_par(i),T_par(i)] = Factores_de_R_y_T(ni, nt,theta_i(i),theta_t, r_per(i),t_per(i),r_par(i),t_par(i));
    
end


%Graficas
figure (1),
hold on
plot (theta_i,r_per,'y',theta_i,t_per,'r',theta_i,r_par,'g',theta_i,t_par,'b')
title('Material Dispersivo para una lambda y diferentes angulos de incidencia')
xlabel('Angulos de Incidencia(grados)')
ylabel('Coeficientes de Amplitud')
grid on

%graficando angulo de Breswter
if ~strcmp(material_Dos,'Al')
    Ang_Brew=Ang_Brewster (abs(ni),abs(nt));
    if ni>nt
        %Calculo del ángulo crítico para que se produzca la reflexión total interna 
        Angulo_Critico = asind(real(nt/ni));
    else
        Angulo_Critico = NaN;
    end
    %Graficando el Angulo de Breswter
    if theta_i_2 >= Ang_Brew 
        x=[Ang_Brew Ang_Brew];
        y=ylim;
        plot(x,y,'LineStyle','-.','Color','k');
        legend('r Perpendicular','t Perpendicular','r Paralelo','t Paralelo','Ang Brewster')
    end
    %Graficando el Angulo Critico
    if ~isnan(Angulo_Critico)
        x=[Angulo_Critico Angulo_Critico];
        y=ylim;
        plot(x,y,'LineStyle','-.','Color','r');
        legend('r Perpendicular','t Perpendicular','r Paralelo','t Paralelo','Ang Brewster','Ang Crítico')
    end
end

figure(2),
hold on
plot (theta_i,T_per,'r',theta_i,T_par,'b')
title('Factor de Trasmisión de Energía Vs Ángulo de Incidencia')
legend('T Perpendicular','T Paralelo')
grid on
xlabel('Angulos de Incidencia(grados)')
ylabel('Factor de Trasmision de Energia')

%plot Factor de Reflexion de Energia
figure(3),
hold on
plot (theta_i,R_per,'y',theta_i,R_par,'g')
title('Factor de Reflexión de Energía Vs Ángulo de Incidencia')
legend('R Perpendicular','R Paralelo')
grid on
xlabel('Angulos de Incidencia(grados)')
ylabel('Factor de Reflexion de Energia')


end
%% Varación de la lambda

lambda_inic = 0;
lambda_final = 2;

theta =0;

%lambda = 0.8; %para una lambda de incidencia en um
material_Uno = 'Air';
material_Dos = 'Al';


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

%     %Medio donde viaja la luz antes de incidir en el material
%     [epsilon] = Drude_Lorentz(lambdas(i) , 'DL', material_Uno);
%     [n, k, ni(i)] = Val_N_Complejo (epsilon);
% 
%     %Medio donde se trasmite la luz
%     [epsilon] = Drude_Lorentz(lambdas(i) , 'DL', material_Dos);
%     [n, k, nt(i)] = Val_N_Complejo (epsilon);

    theta_t = asind(ni(i).*sind(theta)./nt(i));
    theta_t=real(theta_t);

    %calculo de los coeficientes de Fresnel
    [r_per(i),t_per(i),r_par(i),t_par(i)] = Coef_Fresnel(theta,theta_t,ni(i),nt(i));
    %Calculo de los Factores de Tx y Rf de Energía
    [R_per(i),T_per(i),R_par(i),T_par(i)] = Factores_de_R_y_T(ni(i),nt(i),theta,theta_t,r_per(i),t_per(i),r_par(i),t_par(i));

end

%Gráficas
figure (4),
grid on,
hold on
plot (lambdas,abs(r_per),'y',lambdas,abs(t_per),'r',lambdas,abs(r_par),'g',lambdas,abs(t_par),'b')
title('Material Dispersivo para un ángulos de incidencia y diferentes lambda ')
xlabel('Longitud de onda \mum')
ylabel('Coeficientes de Amplitud')
legend('r Perpendicular','t Perpendicular','r Paralelo','t Paralelo')


figure(5),
hold on
plot (lambdas,T_per,'r',lambdas,T_par,'b')
title('Factor de Trasmisión de Energía Vs Ángulo de Incidencia')
legend('T Perpendicular','T Paralelo')
grid on
xlabel('Longitud de onda \mum')
ylabel('Factor de Trasmisión de Energia')

%plot Factor de Reflexión de Energía
figure(6),
hold on
plot (lambdas,R_per,'y',lambdas,R_par,'g')
title('Factor de Reflexión de Energía Vs Ángulo de Incidencia')
legend('R Perpendicular','R Paralelo')
grid on
xlabel('Longitud de onda \mum')
ylabel('Factor de Reflexión de Energía')

%% Comparación del modelo de Drude-Lorentz con los valores de Refractive Index

%Introducir los valores de Longitud de Onda Inicial y Final para visualizar
%en um
Val_long_onda_inic = 0;
Val_long_onda_final = 2;

%anadiendo la extension 
extension = '.csv';
material_ext = strcat(material_Dos,extension); %concatenando los valores para onbetenr el nombre del archivo en correspondencia con material

%funcion que recibe el nombre del material y el rango de frecuencia inicial
%y frecuencia final que se quiere visualizar
[lambdas,n_experim,k_experim,Nt_complejo] = leer_valores_exp(material_ext,Val_long_onda_inic,Val_long_onda_final); 

%calculando los valores de n y k para el modelo de Drude-Lorentz
%Medio donde viaja la luz antes de incidir en el material

if strcmpi(material_Dos,'PMMA')
    [epsilon] = Drude_Lorentz(lambdas , 'Diele', material_Dos);
else
    [epsilon] = Drude_Lorentz(lambdas , 'DL', material_Dos);
end
[n, k] = Val_N_Complejo (epsilon);

%Graficar los valores: n_experim, k_experim (experimentales), n y k calculados; para
%comparar
figure(7), plot(lambdas,n_experim,'LineStyle','-','Color','r');
hold on
grid on
plot(lambdas,n,'LineStyle','-.','Color','r')
plot(lambdas,k_experim,'LineStyle','-','Color','b')
plot(lambdas,k,'LineStyle','-.','Color','b')
legend('n Experimental','n Drude-Lorentz','k Experimental','k Drude-Lorentz');
title('Comparación del modelo de Drude-Lorentz con los valores de Refractive Index')
xlabel('Longitud de onda \mum')
ylabel('Índices de refracción')