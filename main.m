clc;
clear all;
close all;
%% get input parameter

sys_par=get_system_parameter();

%options=optimoptions('fsolve','MaxFunEvals',1700,'Algorithm', 'levenberg-marquardt');%,'Algorithm': 'trust-region-reflective','trust-region-dogleg,trust-region, levenberg-marquardt,
for i=1:size(sys_par.lambda,2)
   for j=1:size(sys_par.N,2)
    x=-rand(1,19);
    var=0;
    F=fun2(x,sys_par,i,j,var);
    x0=rand(1,19);
    while (x(1)<0 || x(1)>1 || x(2)<0 || x(2)>1 || x(3)<0 || x(3)>1 || x(4)<0 || x(4)>1 || x(5)<0 || x(5)>1 || sum(abs(F))>10^(-6))%|| x(6)<0 || x(6)>1 || x(7)<0 || x(7)>1 ||  sum(x>=0)<17
      [x,fval] = fsolve(@(x)fun2(x,sys_par,i,j,var),x0);%options
      %var=0;%variance(x,sys_par);
      %[x,fval] = fsolve(@(x)fun2(x,sys_par,i,var),x0,options);
      %var=variance(x,sys_par);
      x0=rand(1,19);%x;
      F=fun2(x,sys_par,i,j,var);
    end

    sum_F(i,j)=sum(abs(F))
     r.b_idle(i,j)      =x(1);
     r.ta(i,j)          =x(2);
     r.pb(i,j)          =x(3);
     r.pbusy(i,j)       =x(4);
     r.pf(i,j)          =x(5);
     r.Tbackoff_ij(i,j) =x(6);
     r.A_1(i,j)         =x(7);
     r.A_2(i,j)         =x(8);
     r.A(i,j)           =x(9);
     r.B(i,j)           =x(10);
     r.C(i,j)           =x(11);
     r.Tsuccess(i,j)    =x(12);
     r.Tfailur(i,j)       =x(13);
     r.Tservice(i,j)      =x(14);
     r.q(i,j)             =x(15);
     r.Psuccess(i,j)      =1-(r.pf(i,j))^(sys_par.m+1) ;
     r.ro(i,j)             =x(16);
     r.var_Tservice(i,j)   =x(17);
     r.sigma(i,j)               =x(18);
     r.p(i,j)                 =x(19);
     i
     x(15)
     x(16)
     %if sys_par.lambda(i)<1/r.Tservice(i)
        % r.throughput(i)    =1000*r.Psuccess(i)*sys_par.lambda(i);
    % else
         r.throughput_RCAP(i,j)    =900000000*sys_par.L.data*(1-r.b_idle(i,j) )*r.Psuccess(i,j)/r.Tservice(i,j)*sys_par.N(j);
         r.queue_waiting_RCAP(i,j) =r.Tservice(i,j)*r.ro(i,j) *(1+r.var_Tservice(i,j))/2/(1-r.ro(i,j));
         r.delay_RCAP(i,j)= r.queue_waiting_RCAP(i,j)+r.Tsuccess(i,j)+(sys_par.T.SD-sys_par.T.RCAP)^2/2/sys_par.T.SD;
         
    % end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    GaurdTime=2*25/10^6*sys_par.L.success;
    
    r.L_CTA(i,j)=max((sys_par.T.SD-sys_par.T.RCAP-sys_par.T.beacon)/sys_par.N(j),sys_par.L.success+GaurdTime);
    r.N_CTA(i,j)=min(sys_par.N(j),floor( r.L_CTA(i,j)/(sys_par.L.success+GaurdTime)));
    r.Tservice_CTA(i,j)= (sys_par.T.SD-r.L_CTA(i,j))^2/(2*sys_par.T.SD)+sys_par.L.success;
    r.ro_CTA(i,j)= sys_par.lambda_CTAP(i)*r.Tservice_CTA(i,j);
    r.q_CTA(i,j)=r.ro_CTA(i,j)/(1-r.ro_CTA(i,j))-r.ro_CTA(i,j)^2/(2*(1-r.ro_CTA(i,j)));
    r.sigma_CTA(i,j)=1/sys_par.lambda_CTAP(i)-r.Tservice_CTA(i,j);
    r.b_idle_CTA(i,j)=exp(- r.q_CTA(i,j))/(1-exp(-sys_par.lambda_CTAP(i)*r.sigma_CTA(i,j))+exp(r.q_CTA(i,j)));%%it has poblem :(
    
    r.throughput_CTA(i,j)=900000000*sys_par.L.data*(1-r.b_idle_CTA(i,j))/r.Tservice_CTA(i,j)* r.N_CTA(i,j);
    r.queue_waiting_CTA(i,j) =r.Tservice_CTA(i,j)*r.ro_CTA(i,j) /2/(1-r.ro_CTA(i,j));
    r.delay_CTA(i,j)= r.queue_waiting_CTA(i,j)+ r.Tservice_CTA(i,j)+(sys_par.T.SD-  r.L_CTA(i,j))^2/2/sys_par.T.SD;
    
    r.total_throughput(i,j)=r.throughput_CTA(i,j)+ r.throughput_RCAP(i,j);
   end
end
figure(1);
mesh(sys_par.N,sys_par.lambda,r.ta);
hold on;
ylabel('\lambda_R_C_A_P');
xlabel('N');
zlabel('\tau_R_C_A_P');
figure(2);
mesh(sys_par.N,sys_par.lambda,r.Tservice);
hold on;
ylabel('\lambda_R_C_A_P');
xlabel('N');
zlabel('T_s_e_r_v_i_c_e_,_R_C_A_P');
figure(3);
subplot(1,3,1),mesh(sys_par.N,sys_par.lambda,r.throughput_RCAP);
hold on;
ylabel('\lambda_R_C_A_P');
xlabel('N');
zlabel('\eta_R_C_A_P(bit/s)');
figure(4);
subplot(1,3,1),mesh(sys_par.N,sys_par.lambda,r.Psuccess);
hold on;
ylabel('\lambda_R_C_A_P');
xlabel('N');
zlabel('Reliability,_R_C_A_P');
figure(5);
mesh(sys_par.N,sys_par.lambda,r.b_idle);
hold on;
ylabel('\lambda_R_C_A_P');
xlabel('N');
zlabel('b_i_d_l_e_,_R_C_A_P');

figure(6);
subplot(1,3,1),mesh(sys_par.N,sys_par.lambda,r.throughput_CTA);
hold on;
ylabel('\lambda_R_C_A_P');
xlabel('N');
zlabel('\eta_C_T_A');
figure(7);
mesh(sys_par.N,sys_par.lambda,r.Tservice_CTA);
hold on;
ylabel('\lambda_R_C_A_P');
xlabel('N');
zlabel('T_s_e_r_v_i_c_e_,_C_T_A');
figure(8);
mesh(sys_par.N,sys_par.lambda,r.b_idle_CTA);
hold on;
ylabel('\lambda_R_C_A_P');
xlabel('N');
zlabel('b_i_d_l_e_,_C_T_A');

figure(9);
subplot(1,3,1),mesh(sys_par.N,sys_par.lambda,r.q_CTA);
hold on;
ylabel('\lambda_R_C_A_P');
xlabel('N');
zlabel('q_C_T_A');


figure(10);
subplot(1,3,1),mesh(sys_par.N,sys_par.lambda,r.total_throughput);
hold on;
ylabel('\lambda_R_C_A_P');
xlabel('N');
zlabel('\eta_t_o_t_a_l');


figure(11);
subplot(1,3,1),mesh(sys_par.N,sys_par.lambda,r.q);
hold on;
ylabel('\lambda_R_C_A_P');
xlabel('N');
zlabel('q_R_C_A_P');

figure(12);
mesh(sys_par.N,sys_par.lambda,r.Tsuccess);
hold on;
ylabel('\lambda_R_C_A_P');
xlabel('N');
zlabel('T_s_u_c_c_e_s_s_,_R_C_A_P');

figure(13);
mesh(sys_par.N,sys_par.lambda,r.queue_waiting_RCAP);
hold on;
ylabel('\lambda_R_C_A_P');
xlabel('N');
zlabel('T_w_a_i_t_i_n_g_q_,_R_C_A_P');

figure(14);
subplot(1,3,1),mesh(sys_par.N,sys_par.lambda,r.delay_RCAP);
hold on;
ylabel('\lambda_R_C_A_P(packet/s)');
xlabel('N');
zlabel('delay_R_C_A_P(s)');

figure(15);
mesh(sys_par.N,sys_par.lambda,r.ro_CTA);
hold on;
ylabel('\lambda_R_C_A_P(packet/s)');
xlabel('N');
zlabel('\rho_C_T_A');
mesh(sys_par.N,sys_par.lambda,ones(size(sys_par.lambda,2),size(sys_par.N,2)));

 

