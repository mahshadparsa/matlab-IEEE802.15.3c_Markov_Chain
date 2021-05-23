function sys=get_system_parameter()
sys.N=15:15:100;
sys.M=6;
sys.lambda=2:6:7*6;%200000;
sys.lambda_CTAP=[20 20 20 20 20 20 20];
%sys.sigma=1*10^(-6);
sys.m=3;
sys.W0=8;
sys.DataWidth=900*10^6;
pPHYSIFSTime=2.5*10^(-6);%us
pCCADetectTime=4*10^(-6);%us
sys.L.SIFS=pPHYSIFSTime;
sys.L.BIFS=pPHYSIFSTime+pCCADetectTime;
sys.L.RIFS=2*pPHYSIFSTime+pCCADetectTime;
sys.L.data=80000/sys.DataWidth;%1000bit/900Mbps
sys.L.ACK=496/sys.DataWidth;
sys.L.success=sys.L.data+sys.L.SIFS+sys.L.ACK+sys.L.SIFS;
sys.L.failur=sys.L.data+sys.L.SIFS+sys.L.ACK+sys.L.SIFS+sys.L.RIFS;
sys.T.SD=0.065535;%us, max value
sys.T.RCAP=0.0325;%%0.01625, 0.04875,0.0325
sys.T.RSCAP=sys.T.RCAP/sys.M;
sys.T.beacon=0.000535;

sys.lx=sys.L.success/2;% how calculate?

sys.Pt=10*10^(-3);%watt
sys.Pr=3.1623*10^(-6);% -55dB
sys.D=10;% room radius
sys.N0=6.4565*10^(-10);%-91.9 dB
sys.G0= 15.8489;% 27dBi or 12dBi
sys.Gt=sys.G0*sys.M;
sys.Gr=sys.G0*sys.M;
sys.k=((.5*10^(-2))/(4*pi))^2;

sys.r_er=((sys.k*sys.Gt*sys.Gr*sys.Pt)/(sys.N0*sys.DataWidth))^.5;
sys.p_r_er=(sys.r_er/(sys.D*sys.M))^2;
sys.n_r_er=(sys.N/sys.M)*sys.p_r_er;
sys.n_r_er_bar=(sys.N/sys.M)-sys.n_r_er;

sys.r_sr=((sys.k*sys.Gt*sys.Gr*sys.Pt)/sys.Pr)^.5;
sys.p_r_sr=(sys.r_sr/(sys.D*sys.M))^2;
sys.n_r_sr=(sys.N/sys.M)*sys.p_r_sr;
sys.n_r_sr_bar=(sys.N/sys.M)-sys.n_r_sr;

sys.SINR=2;%2:2:28dB,with 2dB step
sys.FER=10^(-1);%10^(-1):10^(-10), in step of 10^(-1) Frame error rate
