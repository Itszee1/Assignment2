%Input Parameters
sizeRectangle = 20;
Length = 3 * sizeRectangle;
Width = 2 * sizeRectangle;
mainV = 1;

Matrix1 = sparse(1,Length);
Matrix2 = sparse(Width,Length);
Matrix3 = sparse(Width, Length);

Boundary1 = 0;
Boundary2 = mainV;

numIter = 100;

fig1 = figure;
Matrix1(Length) = Boundary1;
Matrix(1) = Boundary2;
Matrix(2:Length-1) = deal(0.5*(Boundary1 + Boundary2));

figure (fig1)
for steps = 1:numIter
    plot(Matrix1)
    title('Finite Difference Process')
    pause(0.01)
    for iter = 2:Length-1
        Matrix1(iter) = 1/2*(Matrix1(iter-1)+Matrix1(iter+1));
    end
end


%%%FOR QUESTION 1B
Iter2 = iter;
fig2 = figure;

figure(fig2)
for iter = 1:Length       
    for jd = 1:Width
        Matrix3(jd,iter) = analyticalsol2(iter,jd,mainV,Length,Width,Iter2); 
    end
end
subplot(3,1,1);
surf(Matrix3);
title('Analytical Solution');
pause(0.01);



% to find the average of the boundry conditions, we do
[Matrix2(1, 1), Matrix2(1, Length), Matrix2(Width, 1), Matrix2(Width, Length), ...  
    Matrix2(2 : Width - 1, 2 : Length - 1)] = deal (1/2*(Boundary1 + Boundary2));
[Matrix2(1, 2 : Length-1), Matrix2(Width, 2 : Length-1)] = deal(Boundary1);
[Matrix2(2 : Width-1, 1), Matrix2(2 : Width-1, Length)] = deal(Boundary2);

for step = 1:iter
    subplot(3,1,2);
    surf(Matrix2);
    title('Numerical Solution');
    subplot(3, 1, 3);
    surf(log(abs(Matrix2 - Matrix3)))
    set(gca, 'ZScale' , 'log')
    title('Difference in Numerical  Analytical Solution')
    pause(0.01);
    
    for iter = 2 : Length-1
        for jd = 2:Width-1
            Matrix2(jd, iter) = 0.25*(Matrix2(jd + 1, iter) + Matrix2(jd - 1, iter) + ...
                Matrix2(jd, iter + 1) + Matrix2(jd, iter - 1));
        end
    end
end