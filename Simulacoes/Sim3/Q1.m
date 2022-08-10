%%% T=0.5 %%%
num = [0.6487 0]
den = [1.6487 -2.6487 1]
G = tf(num,den,0.5)
%y = step(feedback(2*G,1))
%stepinfo(y)
rlocus(G)

%%% T = 1 %%%
num = [1.7183 0]
den = [2.7183 -3.7183 1]
G = tf(num,den,1)
rlocus(G)

%%% T = 2 %%%
num = [6.3891 0]
den = [7.3891 -8.3891 1]
G = tf(num,den,2)
rlocus(G)
