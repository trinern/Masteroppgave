function [ Dmin, Dmax ] = get_month( T0 )
%Calculates first and last days in a cycle's month

Mduration=[31 28 31 30 31 30 31 31 30 31 30 31];
Mstart=zeros(12,1);
Mstart(1)=1;
for m=2:12
    Mstart(m)=Mstart(m-1)+Mduration(m-1);
end

d=floor(T0/60/24);

for m=1:12
    if d<=(Mstart(m)+Mduration(m))
        Dmin=Mstart(m);
        Dmax=Mstart(m)+Mduration(m);
        break
    end
end
end

