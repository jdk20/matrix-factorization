clc; clear all; close all;

load('build/data.mat');
load('build/svd.mat');

% orthogonal, square matrix where rows are orthogonal and have unit norm (orthonormal)
% A^T*A = A*A^T = I and A^-1 = A^T, inverse is very cheap to compute
%
% A (orthogonal, 20 by 20 matrix), left-singular vectors, eigenvectors of V*V^T, latent factors of movie matrix
% s (singular values, 20 by 1682 diagonal matrix), singular values of V, square roots of eigenvalues of A^T*T or A*A^T
% B (orthogonal, 1682 by 1682 matrix), right-singular vectors, eigenvectors of V^T*V

u = mean(V,2);
V = bsxfun(@minus, V, u);
U = bsxfun(@minus, U, u);

[A, s, B] = svd(V);

V_hat = A(:,1:2)' * V;
U_hat = A(:,1:2)' * U;

V_hat = bsxfun(@rdivide, V_hat, std(V_hat')');
U_hat = bsxfun(@rdivide, U_hat, std(U_hat')');

% ten random movies
figure(1)
index = [29 231 254 50 172 181 800 635 565 406];
v = V_hat(:,index);
t = titles(index);
for i = 1:length(t)
    hold on; box off;
    text(v(1,i), v(2,i), [' ', t{i}], 'FontSize', 8); 
    plot(v(1,i), v(2,i), 'k.');
end
xlabel('dimension 1');
ylabel('dimension 2');
xlim([-1.5 3.5]);

% ten most popular movies 
figure(2)
index = [50 258 100 181 294 286 288 1 300 121];
v = V_hat(:,index);
t = titles(index);
for i = 1:length(t)
    hold on; box off;
    text(v(1,i), v(2,i), [' ', t{i}], 'FontSize', 8); 
    plot(v(1,i), v(2,i), 'k.');
end
xlabel('dimension 1');
ylabel('dimension 2');
ylim([-1.6 0.6]);
xlim([-2 3]);

% ten best movies 
figure(3)
index = [814 1122 1189 1201 1293 1467 1500 1536 1599 1653];
v = V_hat(:,index);
t = titles(index);
for i = 1:length(t)
    hold on; box off;
    text(v(1,i), v(2,i), [' ', t{i}], 'FontSize', 8); 
    plot(v(1,i), v(2,i), 'k.');
end
xlabel('dimension 1');
ylabel('dimension 2');
ylim([-1.5 1.2]);
xlim([-1.4 0.5]);

% three genres Film-Noir, Horror, Western - 11, 12, 19 
figure(4)
a = find(genres(:,11));
b = find(genres(:,12));
c = find(genres(:,19));
index = [a(1:10); b(1:10); c(1:10)];
v = V_hat(:,index);
t = titles(index);
for i = 1:length(t)
    if i <= 10
        col = [0.466 0.674 0.188];
    elseif i > 10 && i <= 20
        col = [0.635 0.078 0.184];
    else
        col = [0.929 0.694 0.125];
    end
    
    hold on; box off;
    text(v(1,i), v(2,i), [' ', t{i}], 'Color', col, 'FontSize', 8); 
    plot(v(1,i), v(2,i), 'k.');
end
xlabel('dimension 1');
ylabel('dimension 2');
% ylim([-1.5 1.2]);
% xlim([-1.4 0.5]);

for i = 1:4
    set(figure(i),'PaperPosition',[0 0 5.6 5.6]);
%     print(figure(i),'-r600','-dtiff',['Matrix_',num2str(i),'.tiff'])
    print(figure(i),'-depsc2',['Matrix_',num2str(i),'.eps'])
end
