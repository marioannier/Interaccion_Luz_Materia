function [lambdas_out,n,k,Nt_compl] = leer_valores_exp(filename,lam_i,lam_f)
%Función que recibe el nombre del fichero que con los valores de longitud
%de onda (um), n y k extraído de refractiveindex.info y los valores de longitud de onda que voy a
%tomar(un valor inicial y uno final: en um) para extraído el barrido de
%frecuencias. Devuelve las frecuencias del intervalo seleccionado así
%como sus correspondientes valores de parte real e imaginaria del índice 
%de refracción del material.

%leo los datos del archivo csv
csv_matrix = readmatrix(filename);

%agrupo en vectores columna los valores de lambdas, n y k
lambdas=csv_matrix(:,1);
index_n=csv_matrix(:,2);
index_k=csv_matrix(:,3);

%%  Buscando las longitudes de onda
if (lam_i<lam_f) %si el valor de lambdas es diferente (un rango de valores)
    x=find((lambdas >= lam_i) & (lambdas <= lam_f));

elseif(lam_i==lam_f)%si se introduce un solo valor de lambdas
    [minDistance, indexOfMin] = min(abs(lambdas-lam_i)); %se encuentra el valor de la lamda mas cerca a ese valor
    x=indexOfMin;
else
    error('ERROR! Elije un barrido con Val_long_onda_inic <= Val_long_onda_final')
end

lambdas_out=lambdas(x);
n=index_n(x);
k=index_k(x);

%Se determina el valor de complejo
Nt_compl=n+1i*k;

end

