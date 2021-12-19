function [epsilon_inf, epsilon_s, omega_t, gamma_cero, omegalight]=Obtener_Datos_Material_Diele(lambda)
twopic = 1.883651567308853e+09; % twopic=2*pi*c donde c es la velocidad de la luz
ehbar = 1.51926751447914e+015;
omegalight = twopic.*(lambda.^(-1)); % frecuencia angular de la velocidad de la luz (rad/s)

epsilon_inf = 1;

epsilon_s = 2.17;

omega_t = 11.427*ehbar;

gamma_cero = 0;


end