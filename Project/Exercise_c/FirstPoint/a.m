clc;
clear all;
close all;

s=zpk('s');

%2. Supponiamo che il regolatore abbia la seguente struttura lineare;
%C(s) =      K
%     ----------------        
%          s (s + 1)
%Determinare:

%% (a)il valore limite di K in corrispondenza del quale la stabilità in retroazione non è più garantita

%Parametri sistema
R= 0.5;   %Obiettivo
epsilon= 0.25;  % ampiezza della fascia di tolleranza

%Script_G
numG= 2;
denG=[3 1];
G= tf(numG,denG)


K= 0.5;
numC=K;
denC=[1 1 0];
C=tf(numC,denC)


%Definiamo ora la sensitività del disturbo e la sensitività complementare.
L = series(G,C);

Sd = G/(1+series(G,C));

T = feedback(L,1);

