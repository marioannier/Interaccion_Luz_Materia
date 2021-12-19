function [Ang_Brew] = Ang_Brewster (ni,nt) 
%Función para calcular el ángulo de Brewster en dependencia de los índices
%de refracción del medio incidente y del trasmitido. Recibe dos valores de
%índices de refracción complejos y devuelve el ángulo correspondiente en
%grados

if imag(nt)==0
    ni=abs(ni);
    nt=abs(nt);
    Ang_Brew=atand(nt/ni);
else
    Ang_Brew=atand(abs(nt)/abs(ni));
     
end
end