%DATA (example data generation of Problem 4)
n = 20;
m = 40;
A = randi([-4,4],m,n);
b = rand(m,1)*10 -5;
rho = 10;
a = rand(n,1)*4;
%save('P4')

% %Write_data if you want to solve the problem in AIMMS
% capital_n = (1:n);
% capital_m = (1:m);
% filename = 'example_data_5.xlsx';
% xlswrite(filename, capital_n', 'n');
% xlswrite(filename, capital_m', 'm');
% xlswrite(filename, rho, 'rho');
% xlswrite(filename, A, 'A');
% xlswrite(filename, a, 'small_a');
% xlswrite(filename, b, 'b');