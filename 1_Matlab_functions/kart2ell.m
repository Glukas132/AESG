function [phi,lam,H] = kart2ell(X,Y,Z)

format long g

%X = 4331283.346;
%Y =  567549.923;
%Z = 4633140.215;

    a = 6378137.0;
alpha = 1.0/298.257222101;
    b = a*(1-alpha);

ee = (a^2-b^2)/a^2;

'Entfernung des Punktes von der z-Achse';
r1 = sqrt(X.^2+Y.^2);

'Näherungswert für beta';
beta = atan(Z./r1);

'Berechnung der Hilfsgrößen';
m = b*Z./(a*r1);
n = (a^2-b^2)./(a*r1);

'Bestimmung der reduzierten Breite beta';
for i=1:5
    beta = atan(m+n.*sin(beta));
end
'Bestimmung der geodätischen Breite phi';
phi = atan(a/b*tan(beta));

'Bestimmung der Länge lam';
lam = atan2(Y,X);

'Querkrümmungsradius N';
N = a./sqrt(1-ee*sin(phi).^2);

'ellipsoidische Höhe H';
H = Z./sin(phi)-(1-ee)*N;

phi = phi*180/pi;
lam = lam*180/pi;
