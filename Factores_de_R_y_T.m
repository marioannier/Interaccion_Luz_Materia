function [R_per, T_per, R_par, T_par]= Factores_de_R_y_T(ni, nt,theta_i,theta_t,r_per, t_per, r_par, t_par)
%Esta función calcula el factor de reflexión de energía R y el factor de
%transmisión de energía T para cada una de las polarizaciones paralelas y
%perpendicular [R_per, T_per, R_par, T_par]. Recibe como entrada los
%valores de los índices de refracción del medio incidente y del trasmitido el
%ángulo de incidencia y los valores de los coeficientes de Fresnel. Todo
%ello para cada uno de los valores de entrada de ángulos de incidencia y
%trasmisión (theta_i,theta_t) respectivamente


%Calculo del factor de Reflexión de Energía
R_per=(abs(r_per)).^2;
R_par=(abs(r_par)).^2;


%Calculo del factor de Trasmisión de Energía
T_par=((real(nt).*cosd((theta_t)))./(real(ni).*cosd((theta_i)))).*(abs((t_par)).^2);
T_per=((real(nt).*cosd((theta_t)))./(real(ni).*cosd((theta_i)))).*(abs((t_per)).^2);

end