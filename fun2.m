function F = fun2(x,sys,i,j,var)

F=[% x(1)=b_idle=1/(1 + ( (sys.W0+1)/2+pf/2*(1-pf^m)/(1-pf)+sys.W0*pf*(1-(2*pf)^m)/(1-2*pf) )*sys.lambda/(1-pb)/(1-q) )
 %-x(1)+sys.lambda(i)*exp(-sys.lambda(i)*x(18));
 -x(1)+1/(1 + ( (sys.W0+1)/2+x(5)/2*(1-x(5)^sys.m)/(1-x(5))+sys.W0*x(5)*(1-(2*x(5))^sys.m)/(1-2*x(5)) )*x(19)/(1-x(3))/(exp(-x(15))) )
 
 % x(2)=ta=b_idle*sys.lambda*(1-pf^(m+1))/(1-pf)/(1-q);
 %-x(2)+x(1)*(1-x(18))*(1-x(5)^(sys.m+1))/(1-x(5))/exp(-x(15));% ta
 -x(2)+x(1)*x(19)*(1-x(5)^(sys.m+1))/(1-x(5))/exp(-x(15));% ta
 
 % x(3)=pb=pbusy+sys.L.success/sys.T.RCAP;
 -x(3)+x(4)+sys.L.success/sys.T.RCAP;% pb
 
 % x(4)=pbusy=1-(1-ta)^N;
 -x(4)+1-(1-x(2))^sys.N(j);% pbusy
 
 % x(5)=pf=1-(1-ta)^(N-1);
 -x(5)+1-(1-x(2))^(sys.N(j)-1);%pc

 % x(6)=Tbackoff_ij=( sys.L.BIFS*pbusy/(1-pbusy)^2 + sys.lx*(sys.lx+sys.T.SD-sys.T.RCAP)/(1-pbusy))/sys.T.RCAP;
 -x(6)+( sys.L.BIFS*x(4)/(1-x(4))^2 + sys.lx*(sys.lx+sys.T.SD-sys.T.RCAP)/(1-x(4)))/sys.T.RCAP;%Tbackoff_ij
 
 % x(7)=A_1=sys.W0*( (1-(2*pf)^(sys.m+1))/(1-2*pf) ) + .5*(1-sys.W0)* (1- pf^(m+1))/(1-pf) ;
 -x(7)+ sys.W0*( (1-(2*x(5))^(sys.m+1))/(1-2*x(5)) ) + .5*(1-sys.W0)* (1- x(5)^(sys.m+1))/(1-x(5));
 
 % x(8)=A_2=.5*pf/(1-pf) *( -(sys.m+1)*pf^sys.m + (1-(pf)^(sys.m+1))/(1-pf)) ;
 -x(8)+.5*x(5)/(1-x(5)) *( -(sys.m+1)*x(5)^sys.m + (1-x(5)^(sys.m+1))/(1-x(5))) ;
 
 % x(9)=A=(Tbackoff_ij+sys.L.BIFS)*(1-pf)*(A_1+A_2);
 -x(9)+(x(6)+sys.L.BIFS)*(1-x(5))*(x(7)+x(8));
 
 % x(10)=B=sys.L.success*(1-pf)*(1-pf^(sys.m+1))/(1-pf);
  -x(10)+sys.L.success*(1-x(3))*(1-x(5)^(sys.m+1));%%-x(10)+sys.L.success*(1-x(5))*(1-x(5)^(sys.m+1))/(1-x(5));
 
 % x(11)=C=sys.L.failur*pf*(1-pf)*( ((1-pf^(sys.m+1))/(1-pf)^2) - ((sys.m+1)*pf^sys.m/(1-pf)) );
 %%-x(11)+sys.L.failur*x(5)*( ((1-x(5)^(sys.m+1))/(1-x(5))) - ((sys.m+1)*x(5)^sys.m) );
-x(11)+sys.L.failur*x(5)*(1-x(5))*(1-x(3))^2/(1-x(5)*(1-x(3)))*((1-x(5)^(sys.m+1))/(1-x(5))-(sys.m+1)*(1-x(3))*x(5)^sys.m );
 % x(12)=Tsuccess=A+B+C;
 -x(12)+x(9)+x(10)+x(11);
 
 %x(13)=Tfailur=( (sys.m+1)*sys.L.failur + (Tbackoff_ij+sys.L.BIFS)*(.5*(sys.m+1) - .5*sys.W0*(1-2^(sys.m+1))) )*(pf)^(sys.m+1);
 -x(13)+( (sys.m+1)*sys.L.failur + (x(6)+sys.L.BIFS)*(.5*(sys.m+1) - .5*sys.W0*(1-2^(sys.m+1))) )*(x(5))^(sys.m+1);
 
 %x(14)=Tservice=Tsuccess+Tfailur;
 %-x(14)+x(12)+x(13)+(sys.T.SD-sys.T.RCAP)^2/(2*sys.T.SD);
 %x(14)=p(s)*Tsuccess+p(f)*Tfailur;
 -x(14)+(1-x(5)^(sys.m+1))*x(12)+x(13)*x(5)^(sys.m+1)+(sys.T.SD-sys.T.RCAP)^2/(2*sys.T.SD);
 
 % x(15)=q=ro+ro^2*(1+var_Tservice)/(2*(1-ro));
 -x(15)+x(16)+x(16)^2*(1+x(17))/(2*(1-x(16)));
 
 % x(16)=ro=lambda*Tservice;
 -x(16)+sys.lambda(i)*x(14);
 
 % x(17)=var_Tservice;
 -x(17)+variance(x,sys);
 
 % x(18)=sigma=exp(2q)*Tservice
 %-x(18)+exp(2*x(15))*x(14);
 -x(18)+sigma(x,sys,i);
 
 % x(19)=p=exp(-q)exp(-lambda*sigma)/(1-exp(-lambda*sigma))
 %-x(19)+exp(-x(15))*exp(sys.lambda(i)*x(18))/(1-exp(sys.lambda(i)*x(18)))
 -x(19)+1-exp(-sys.lambda(i)*x(18))
 ];
      
