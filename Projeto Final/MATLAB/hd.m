clear 
close all
clc

%%Dados
J =1;
b = 20;
Ka = 15;
R = 1;
Km = 5;
L = 10^-3;

%%Processo
T_l = J/b;
s = tf('s');
G = zpk(Km/(s*(J*s+b)*(L*s+R)));

%%Restrições
sysc = feedback(Ka*G,1);                   % Sistema a Malha Fechada c/
S1 = stepinfo(sysc);                       % amplificação típica
Tsys = S1.SettlingTime;                    % Tempo de acomodação de sysc
ts = Tsys*0.8;                             % Requisito #1
Mp = 0.1;                                  % Requisito #2
T = 0.1;

%%Discretizacao
G = c2d(G,T,'zoh');                        %Discretização Planta
[z,p,k] = zpkdata(G);                      %Parâmetros da FT

global zc pc Kc temp_u temp_e

%%Calculos LGR
O = CalculaPolo(ts,Mp,T);                  %Posição Desejada p/ o polo
Delta = CalculaFase(z,p,O);                %Fase que deve ser acrescida
[Kc,zc,pc] = compensador(O,Delta,z,p,k,T); %Parâmetros do Compensador

temp_u = 0;
temp_e = 0;
D = 0.1;                                   %Amplitude Degrau
W = 0;                                     %Amplitude Perturbação
Tsim = 1;                                  %Tempo de Simulação
sim('symblock');
figure
plot(y(:,1),y(:,2),'Color',[0.4660 0.6740 0.1880],'LineWidth',2);
xlabel('t');
ylabel('y(t)');
title('Resposta do Sistema com Controlador');
grid

figure
plot(x(:,1),x(:,2),'LineWidth',2);
hold on
plot(x(:,1),x(:,3),'LineWidth',2);
xlabel('t');
ylabel('e(t),u(t)');
title('Erro e Ação de Controle');
legend('e(t)','u(t)')
grid

temp_u = 0;
temp_e = 0;
D = 0;                                   %Amplitude Degrau
W = 1;                                   %Amplitude Perturbação
Tsim = 1;                                %Tempo de Simulação
sim('symblock');
figure
plot(y(:,1),y(:,2),'LineWidth',2);
xlabel('t');
ylabel('y(t)');
title('Resposta à Perturbação');
grid


function x = CalculaPolo(ts,Mp,T)
    csi = -log(Mp)/(sqrt(pi^2+(log(Mp)^2)));
    wn = 4/(csi*ts);
    x = CalculaPosicao(csi,wn,T);
end

function x = CalculaPosicao(csi,wn,T)
  sigma = exp(-csi*wn*T)*cos(wn*sqrt(1-csi^2)*T); 
  w = exp(-csi*wn*T)*sin(wn*sqrt(1-csi^2)*T);     
  x = sigma+w*1j;
end

function x = ContribuicaoFase(Z_P,O)
  x =  atan2((imag(O) - imag(Z_P)),(real(O) - real(Z_P)));
end

function x = CalculaFase(Zeros,Poles,O)
  theta = 0;
  phi = 0;
  
  for k = 1:length(Zeros{1})
    temp = ContribuicaoFase(Zeros{1}(k),O);
    phi = temp + phi;
    %fprintf('Zero: %.2f Fase: %.2f\n',Zeros{1}(k),rad2deg(temp));
  end

  for k = 1:length(Poles{1})
    temp = ContribuicaoFase(Poles{1}(k),O);
    theta = temp + theta;
    %fprintf('Zero: %.2f Fase: %.2f\n',Poles{1}(k),rad2deg(temp));
  end
  
  x = -pi -(phi - theta);
end
