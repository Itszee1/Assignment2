cMp2 = ones(Length,Width); % Mapping for conductivity
bnLength = Length/3;         % Bottle neck length
boxesWidth = 3*(Width/8);       % Width of boxes
s = 10e-2;
[cMp2(floor((Length - bnLength)/2) : floor((Length + bnLength)/2), 1 : floor((Width - boxesWidth)/2)),...
    cMp2(floor((Length - bnLength)/2) : floor((Ln + bnLength)/2), ...
    floor((Wd + boxesWidth)/2) : Wd)] = deal(s);

Matrix4 = sparse(Length*Width, Lenght*Width); 
Matrix3 = zeros(1, Length*Width);

[Matrix3(2 : Width - 1), Matrix3((Length - 1)*Width + 1 : Length*Width- 1 )] = deal(Boundary2);
[Matrix3(1), Matrix3(Width), Matrix3((Length - 1)*Width), Matrix3(Length*Width)] = deal(0.5*(Boundary1 + Boundary2)); 

for iter = 1 : Length
    for jd = 1 : Width
        n = jd + (iter - 1)*Width;   
        if iter==1 || iter == Ln || jd == 1 || jd == Width
            Matrix4(n,n)=1;
        else
            nxpp = jd + iter*Width;
            nxmm = jd + (iter - 2)*Width;
            nyp=n+1;
            nym=n-1;
            
            rxpp = 1/2*(cMp2(iter, jd) + cMp2(iter + 1, jd));
            rxmm = 1/2*(cMp2(iter, jd) + cMp2(iter - 1, jd));
            rypp = 1/2*(cMp2(iter, jd) + cMp2(iter, jd + 1));
            rymm = 1/2*(cMp2(iter, jd) + cMp2(iter, jd - 1));
            
            Matrix4(n, n) = -(rxpp + rxmm + rypp + rymm);
            Matrix4(n, nxpp) = rxpp;
            Matrix4(n, nxmm) = rxmm;
            Matrix4(n, nyp) = rypp;
            Matrix4(n, nym) = rymm;
        end    
    end
end

V2V=Matrix4\(Matrix3'); % Variable to get V(x,y) from conductivity map

V2Mp = zeros(Length, Width);

for iter = 1 : Length
    for jd = 1 : Width
        V2Mp(iter, jd) = V2V(jd + (iter - 1)*Wd);
    end
end


eXs = zeros(Ln, Wd);
eYs = zeros(Ln, Wd);

for iter = 1 : Ln
    for jd = 1 : Wd
        if iter == 1
            eXs(iter,jd) = V2Mp(iter + 1, jd) - V2Mp(iter, jd);
        elseif iter == Ln
            eXs(iter, jd) = V2Mp(iter,jd) - V2Mp(iter - 1, jd);
        else
            eXs(iter, jd) = (V2Mp(iter + 1, jd) - V2Mp(iter - 1, jd))*0.5;
        end
        if jd == 1
            eYs(iter,jd) = V2Mp(iter,jd+1)-V2Mp(iter,jd);
        elseif jd == Wd
            eYs(iter,jd) = V2Mp(iter,jd)-V2Mp(iter,jd-1);
        else
            eYs(iter,jd) = (V2Mp(iter,jd+1)-V2Mp(iter,jd-1))*0.5;
        end
    end
end

eXs=-eXs;
eYs=-eYs;