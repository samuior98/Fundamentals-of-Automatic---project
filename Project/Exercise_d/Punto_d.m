%SAMUELE IORIO - matricola: 189706 - traccia 48
clc;
clear;
close all;

s=zpk('s');

%1)Precisione statica

%La funzione di trasferimento dell'impianto è:
G=(s+2)/(s*(s+1/2)^2);

% Controllore per precisione statica
k=1.5;
C=k;

% Funzione di anello di "partenza" o non compensata
L=series(C,G);

figure(1)
margin(L)
grid on;

%Otteniamo un margine di fase di -16.3 ad una pulsazione di 1.5 rad/s.



%% 
%2)Precisione dinamica
ts= 70;  %tempo assestamento
S=0.25;  %max sovraelongazione

%Calcoliamo lo smorzamento critico mediante la funzione smorz_S(S)
delta_cr= smorz_S(S);
fprintf('Lo smorzamento critico è: %d\n ',delta_cr)

%Per delta>delta_cr -> S%<0.25

%Possiamo ricavare la pulsazione naturale critica dalla seguente forumla
% inversa
wn_cr= 3/(ts*delta_cr);
fprintf('La pulsazione naturale critica è: %d\n ',wn_cr)

%Devo quindi prendere wn > wn_cr

%Calcoliamo la configurazione ammissibile della banda passante attraverso
% la funzione Wbwn(delta_cr)
wBwn(delta_cr);

%Quindi la banda passante del sistema retroazionato
% in media frequenza è
wB= wBwn(delta_cr)*wn_cr;
fprintf('La banda passante è: %d\n ', wB)


%Scelgo la pulsazione di attraversamento di progetto
wc_new= 0.15;

%E il margine di fase di progetto che deve essere maggiore di
% 100*delta_cr = 40.37°
phim=56;

%Calcolo il modulo e la fase della funzione di anello non compensata in
% corrispondenza di wc_new
[modulo,fase]=bode(L,wc_new);

%Distanza goniometrica:
dist_g = 180-abs(fase); 
%In questo caso modulo > 1 e 180-abs(fase)=60,8907 > phim
% Serve una rete attenuatrice:
%
%   1+s*tauz     1+s*alpha*T
%  ---------- = ----------
%   1+s*taup     1+s*T
%
%   taup > tauz
%
%   0 < alpha < 1


% Calcolo m e theta:
m=1/modulo;

%theta= phim-(180-abs(fase));
theta= phim-(180-abs(fase));

%[alpha,T1,T2]= sella(wc_new,m,theta,K);
[tauz,taup]=generica(wc_new,m,theta);

%A questo punto la rete correttrice è:
%Cd= ((1+s*alpha*T1)/(1+s*T1))*((1+s*T2)/(1+s*alpha*T2));
Cd=(1+s*tauz)/(1+s*taup);

%Il grafico della rete correttrice è:
figure(2);
margin(Cd);
grid;

%La funzione di anello compensata è:
Lhat=series(series(C,G),Cd);

%Tracciamo ora il diagramma di Bode della funzione compensata sovrapponendola
% con la funzione non compensata
figure(3);
margin(L);
hold on;
grid;
margin(Lhat);

%Calcoliamo i parametri del sistema retroazionato:
T=feedback(Lhat,1);
figure(4);
step(T);
grid;

% Parametri del transitorio della risposta al gradino
parametri_risposta_al_gradino= stepinfo(T,'SettlingTimeThreshold',0.25)

% La massimia sovraelongazione - overshoot - è 15.5110% < 25%
% Il tempo di assestamento - SettlingTime -  è 8.8179 sec < 70 sec
