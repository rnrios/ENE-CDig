function u = acao_controle(v)
global temp_e temp_u Kc pc zc

e = temp_e;
r = v(1);
y = v(2);
temp_e = r - y;
u = Kc*temp_e + pc*temp_u -zc*Kc*e;
temp_u = u;