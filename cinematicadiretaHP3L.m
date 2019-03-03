function [x, y, z, T1, T02, T03, T04, T05, T06] = cinematicadiretaHP3L(t)
    % constantes do motoman HP3L
    % T01old T02old T03old T04old T05old T06old
    a2 = 100; a3 = 370; a4 = 85;
    d1 = 300; d2 = 170; d4 = 191.5; d5 = 380-d4; d6 = 90;
    
    t1 = t(1); t2 = t(2); t3 = t(3); 
    t4 = t(4); t5 = t(5); t6 = t(6);
    
    T1=[cosd(t1)   -sind(t1)	0	0;
         sind(t1)    cosd(t1)   0   0;
         0              0       1   d1;
         0              0       0   1];

    T2=[sind(t2)    cosd(t2)     0   a2;
         0              0         1   d2;
         cosd(t2)    -sind(t2)    0   0;
         0              0         0   1];

    T3=[cosd(t3)    -sind(t3)    0   a3;
         -sind(t3)   -cosd(t3)    0   0;
         0              0        -1   0;
         0              0         0   1];

    T4=[cosd(t4)    sind(t4)     0   a4;
         0              0        -1  -d4;
         -sind(t4)   cosd(t4)     0   d2;
         0              0         0   1];

    T5=[cosd(t5)    -sind(t5)    0   0;
         0              0         1   0;
         -sind(t5)   -cosd(t5)    0   d5;
         0              0         0   1];

    T6=[cosd(t6)    -sind(t6)    0   0;
         0              0        -1  -d6;
         sind(t6)    cosd(t6)     0   0;
         0              0         0   1];
     
    T02 = T1*T2;  T03 = T02*T3; T04 = T03*T4;    
    T05 = T04*T5; T06 = T05*T6;
    x = round(T06(1,4)); y = round(T06(2,4)); z = round(T06(3,4));    
end

