% # Compensador Avanço (Método I)
% 
% # alfa: fase do polo desejado de MF
% # gama: fase usada p/ calcular o zero do compensador (fase = 90 - gama)
% # beta: fase usada p/ calcular o polo do compensador (fase = 90 - beta)

function [K_c,z_c,p_c] = compensador(O,delta,z,p,K,T)

alfa = atan2(imag(O),real(O));
gama = 0.5*alfa-atan2(abs(real(O)),imag(O))-delta/2;
z_c = real(O) - tan(gama)*imag(O);
psi = gama + delta;
p_c = real(O) - tan(psi)*imag(O);
%fprintf('Zero Comp: %.2f \nPolo Comp: %.2f',z_c,p_c);
z = [z{1};z_c];
p = [p{1};p_c];
K_c = 1/CalculaGanho(K,z,p,O);
%fprintf("\nO ganho do compensador deve ser: %.2f",K_c);
end

function x = CalculaGanho(K,Zeros,Poles,O)
  num = 1;
  den = 1;

  for k = 1:length(Zeros)
    num = num*abs(O-Zeros(k));
    %fprintf("\nA contribuição do zero em %.2f é: %.2f\n",Zeros(k),abs(O-Zeros(k)))
  end
  
  for k = 1:length(Poles)
    den = den*abs(O-Poles(k));
    %fprintf("\nA contribuição do polo em %.2f é: %.2f\n",Poles(k),abs(O-Poles(k)));
  end
  
  x = K*num/den;
end