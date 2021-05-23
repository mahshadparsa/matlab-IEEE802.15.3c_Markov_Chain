function sys=get_system_parameter()
sys.N=2:2:20;
sys.lambda=4:4:50;%4:4:28;%200000;
sys.lambda_CTAP=4*ones(1,12);
%sys.sigma=1*10^(-6);
sys.m=3;
sys.W0=8;
pPHYSIFSTime=2.5*10^(-6);%us
pCCADetectTime=4*10^(-6);%us
sys.L.SIFS=pPHYSIFSTime;
sys.L.BIFS=pPHYSIFSTime+pCCADetectTime;
sys.L.RIFS=2*pPHYSIFSTime+pCCADetectTime;
sys.L.data=1000/1518000000;%1000bit/900Mbps,80*
sys.L.ACK=496/900000000;
sys.L.success=sys.L.data+sys.L.SIFS+sys.L.ACK+sys.L.SIFS;
sys.L.failur=sys.L.data+sys.L.SIFS+sys.L.ACK+sys.L.SIFS+sys.L.RIFS;
sys.T.SD=0.065535;%us, max value
sys.T.RCAP=0.04875;%%0.04875,0.0325,0.01625
sys.T.beacon=0.000535;

sys.lx=sys.L.success/2;% how calculate?

sys.trans_power=501.1872;%Maximum indoor EIRP: 27 dBi
sys.distance=10;
sys.noise_power=1;
sys.SINR=2;%2:2:28dB,with 2dB step
sys.FER=10^(-1);%10^(-1):10^(-10), in step of 10^(-1) Frame error rate
