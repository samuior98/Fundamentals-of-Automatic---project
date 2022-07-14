clc;
clear all;
close all;

%2. Supponiamo che il regolatore abbia la seguente struttura lineare;
%C(s) =      K
%     ----------------        
%          s (s + 1)
%Determinare:

%% (b)scelto a piacere un valore di K appartenente alla regione di stabilità, rappresentare il diagramma dei moduli e delle fasi 
%      della funzione di sensitività e sensitività complementare

% Scegliamo un valore di K appartenente all’intervallo ricavato nel punto 
% precedente in cui è garantita  la stabilità in retroazione, ovvero K=0.40
% Scriviamo le funzioni dell'impianto e del regolatore

s=zpk('s');
k=0.4;

C= k/(s*(s+1))
G=2/(1+3*s)
L=C*G
S=1/(1+L)
T=L/(1+L)

bode(L,T,S)
grid on


