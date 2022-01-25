function [Ref_T,Tras_T,Dif_Fase_ER,Dif_Fase_ET, E_Amplitud_RP, E_Amplitud_RS, E_Amplitud_TP, E_Amplitud_TS] = Polarizacion(r_par,r_per,t_par,t_per, id_Polarizacion)


switch id_Polarizacion
   case 'PL'
      %Polarización lineal
      delta=pi; %defasaje entre las componentes    
      E_incidente=(1/sqrt(2))*[1;1];
   case 'PC'
      %Polarización circular dextrógira
      delta=-3*pi/2; %defasaje entre las componentes
      %Polarización circular dextrógira
       E_incidente=(1/sqrt(2))*[1;-1i];
    case 'PE'
      %Polarización elíptica dextrógira 
      delta=2.3*pi/2; %defasaje entre las componentes      
      %Polarización elíptica levógira
      E_incidente=[10*sqrt(149)/149;7*sqrt(149)/149];
    otherwise
      %Número no válido del identificador de Polarización
end

m = length(r_par);
E_Rp = zeros(1,m);
E_Rs = zeros(1,m);
E_Tp = zeros(1,m);
E_Ts = zeros(1,m);
Ref_T = zeros(1,m);
Tras_T = zeros(1,m);

for i=1:m
  E_resultanteR=  [r_par(i),0; 0,r_per(i)]*E_incidente;
  E_Rp(i)=E_resultanteR(1);
  E_Rs(i)=E_resultanteR(2);
  E_resultanteT=[t_par(i),0; 0,t_per(i)]*E_incidente;
  E_Tp(i)=E_resultanteT(1);
  E_Ts(i)=E_resultanteT(2);

  %factores de energías de Trasmisión y Reflexión
  Ref_T(i)=(abs(E_Rp(i)))^2+(abs(E_Rs(i)))^2;
  Tras_T(i)=1-Ref_T(i);

end
%Determinando las amplitudes de cada componete
E_Amplitud_RP=abs(E_Rp);
E_Amplitud_RS=abs(E_Rs);
E_Amplitud_TP=abs(E_Tp);
E_Amplitud_TS=abs(E_Ts);
%calculando las fases
fase_E_RP=angle(E_Rp);
fase_E_RS=angle(E_Rs);
fase_E_TP=angle(E_Tp);
fase_E_TS=angle(E_Ts);
%Diferencias de fase
Dif_Fase_ER=fase_E_RP-fase_E_RS;
Dif_Fase_ET=fase_E_TP-fase_E_TS;

end

