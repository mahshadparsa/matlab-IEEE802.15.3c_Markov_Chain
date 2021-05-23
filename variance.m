function variance_service_time= variance(x,sys)
b_idle=x(1);
ta=x(2);
pr=x(3);
pb=x(4);
pbusy=x(5);
pf=x(6);
pc=x(7);
Tbackoff_ij=x(8);
A_1=x(9);
A_2=x(10);
A=x(11);
B=x(12);
C=x(13);
Tsuccess=x(14);
Tfailur=x(15);
Tservice=x(16);
q=x(17);
%% clculation of delay and probability of successful transmition path
% series1 path(1:8)
for i=1:8
    delay_succ_path(i)       = i*(Tbackoff_ij+sys.L.BIFS)+sys.L.success;
    probability_succ_path(i) = 1/sys.W0*(1-pf);%*(1-pb)/*(1-pb)^i
end
% series2 path(1:16)*8
for j=1:16  
    delay_succ_path      (8*j+1:8*j+8)     = delay_succ_path(1:8)+(j)*(Tbackoff_ij+sys.L.BIFS)+sys.L.failur;
    probability_succ_path(8*j+1:8*j+8)     = 1/sys.W0*1/(2*sys.W0)*pf*(1-pf);%*(1-pb)^2/*(1-pb)^(i+j)  
end
% series3 path(1:32)*16*8
for k=1:32
    delay_succ_path      ((16*8*k+9):(16*8*k+16*8+8))  =delay_succ_path(9:(8*16+8))+ k*(Tbackoff_ij+sys.L.BIFS)+sys.L.failur;
    probability_succ_path((16*8*k+9):(16*8*k+16*8+8))  = 1/sys.W0*1/(2*sys.W0)*1/(4*sys.W0)*pf^2*(1-pf);%*(1-pb)^3/*(1-pb)^(i+j+k)
end
% series4 path(1:64)*32*16*8
for L=1:64
    delay_succ_path      ((32*16*8*L+16*8+9):(32*16*8*L+32*16*8+16*8+8)) =delay_succ_path((16*8+9):(32*16*8+16*8+8))+ L*(Tbackoff_ij+sys.L.BIFS)+sys.L.failur;
    probability_succ_path((32*16*8*L+16*8+9):(32*16*8*L+32*16*8+16*8+8)) = 1/sys.W0*1/(2*sys.W0)*1/(4*sys.W0)*1/(8*sys.W0)*pf^3*(1-pf);%*(1-pb)^4/*(1-pb)^(i+j+k+L) 
end

% series5 path(1:64)*32*16*8
for L=1:64
    delay_failure_path      (32*16*8*L+16*8+9:32*16*8*L+32*16*8+16*8+8) =delay_succ_path(16*8+9:32*16*8+16*8+8)+ L*(Tbackoff_ij+sys.L.BIFS)+2*sys.L.failur-sys.L.success;
    probability_failure_path(32*16*8*L+16*8+9:32*16*8*L+32*16*8+16*8+8) = 1/sys.W0*1/(2*sys.W0)*1/(4*sys.W0)*1/(8*sys.W0)*pf^4*(1-pb)^4; %*(1-pb)^(i+j+k+L)
end
avrage_success_service_time = sum(delay_succ_path.*probability_succ_path);
avrage_failure_service_time = sum(delay_failure_path .* probability_failure_path);

avrage_service_time   =  avrage_success_service_time + avrage_failure_service_time;
variance_service_time = sum(probability_succ_path.*((delay_succ_path-avrage_service_time).^2))+sum(probability_failure_path.*((delay_failure_path-avrage_service_time).^2)); 

