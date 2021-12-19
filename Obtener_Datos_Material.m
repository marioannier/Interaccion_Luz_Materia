function [omegap,f,Gamma,omega,order,twopic,omegalight,invsqrt2,ehbar]=Obtener_Datos_Material(material,lambda)
%Función que recibe el acrónimo de un material y la longitud onda en um (material,lambda) y devuelve los 
%parámetros característicos basados en %REFERENCIA
%[Bora Ung (2021). Drude-Lorentz and Debye-Lorentz models for the
%dielectric constant of metals and water (https://www.mathworks.com/matlabcentral/fileexchange/18040-drude-lorentz-and-debye-lorentz-models-for-the-dielectric-constant-of-metals-and-water), MATLAB Central File Exchange. Retrieved October 28, 2021.]
%
% material ==>    'Al'  = aluminio
%                       
%                        
%***********************************************************************
% Constantes Físicas
%***********************************************************************
twopic = 1.883651567308853e+09; % twopic=2*pi*c donde c es la velocidad de la luz
omegalight = twopic.*(lambda.^(-1)); % frecuencia angular de la velocidad de la luz (rad/s)
invsqrt2 = 0.707106781186547;  % 1/sqrt(2)
ehbar = 1.51926751447914e+015; % e/hbar donde hbar=h/(2*pi) y e=1.6e-19
%***********************************************************************

switch material
    case 'Ag'
        % Plasma frequency
        omegap = 9.01*ehbar;
        % Oscillators' strenght
        f =     [0.845 0.065 0.124 0.011 0.840 5.646];
        % Damping frequency of each oscillator
        Gamma = [0.048 3.886 0.452 0.065 0.916 2.419]*ehbar;
        % Resonant frequency of each oscillator
        omega = [0.000 0.816 4.481 8.185 9.083 20.29]*ehbar;
        % Number of resonances
        order = length(omega);
    case 'Al'
        % Frecuencia del Plasma
        omegap = 14.98*ehbar;
        % Fuerzas del oscilador
        f =     [0.523 0.227 0.050 0.166 0.030];
        % Frecuencia de amortiguación de cada oscilador
        Gamma = [0.047 0.333 0.312 1.351 3.382]*ehbar;
        % Frecuencia de Resonancia de cada oscilador
        omega = [0.000 0.162 1.544 1.808 3.473]*ehbar;
        % Número de resonancias
        order = length(omega);                         
    case 'Air'
        omegap = 0;
        f =     [0 0 0 0 0];
        Gamma = [0 0 0 0 0]*ehbar;
        omega = [0 0 0 0 0]*ehbar;
        order = length(omega);     
    case 'LaF3'    %dielectrico de alto indice
        omegap = 0;
        f =     [0 0 0 0 0];
        Gamma = [0 0 0 0 0]*ehbar;
        omega = [0 0 0 0 0]*ehbar;
        order = length(omega);
    case 'C5H12'    %Dielectrico
        omegap = 4.118*10^15;
        f =     [1.093 -1.539 0.579 1.524];
        Gamma = [0.207 0.164 0.133 11.005]*ehbar;
        omega = [1.981 1.982 1.982 3.1]*ehbar;
        order = length(omega);
    case 'Pierce'    %Dielectrico
        omegap = 1.118*10^15;
        f =     [1.093 -1.539 0.579 1.524];
        Gamma = [0.207 0.164 0.133 11.005]*ehbar;
        omega = [1.981 1.982 1.982 3.1]*ehbar;
        order = length(omega);
        
     otherwise
       error('ERROR! Material seleccionado no válido')
end
end