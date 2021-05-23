function Sig = sigma( x,sys,i )
if 1/sys.lambda(i)-x(14)>0
    Sig=1/sys.lambda(i)-x(14);
else
    Sig=0;
end

