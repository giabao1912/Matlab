clc; clear; close all;

%Load file va doc cac du lieu
load('ques_520H0516.mat');
R = ques.A;
M = ques.M;
% R = [Inf, Inf, 3, Inf, 5, 0;
%      2, Inf, 5, Inf, 7, 0;
%      5, 7, 0, Inf, 8, 9;
%      Inf, Inf, Inf, 7, Inf, 8];
% R = [2.5, 4.5, 3, 5.2, 5, 0;
%      2, 5.1, 5, 7.9, 7, 0;
%      5, 7, 9, 6.5, 8, 9;
%      3.8, 8, 2.8, 7, 8.7, 8];
% M = [1, 0; 0, 1; 1, 0; 1, 0];
id = ques.id_query;
if id == 0 
    id = 1; 
end
C = [0, 1, 3;
     0, 1, 4;
     1, 0, 3;   
     1, 0, 3;
     0, 1, 3;
     1, 0, 4];
m = size(R, 1); % so luong sinh vien
clear ques;

%Cau 1
fprintf('Cau 1:\n');
GPA = zeros(m, 1);
for i = 1:m
    totalPoints = 0;
    totalCredits = 0;
    for j = 1:6
        if R(i,j) ~= Inf 
            totalPoints = totalPoints + C(j, 3) * R(i, j);
            totalCredits = totalCredits + C(j, 3);
        end
    end
    if totalCredits > 0
        GPA(i) = round(totalPoints / totalCredits, 1);
    end
end
a.Reg1 = GPA;
clear totalPoints totalCredits GPA;
fprintf('a.Reg1 = \n'); disp(a.Reg1);


%Cau 2
fprintf('Cau 2:\n');
maxCount = -1;
temp = 0
for i = 1:2
    count = 0;
    for j = 1:m
        if M(j, i) == 1 && a.Reg1(j) < 5
            count = count + 1;
        end
    end
    if count == 0
        continue
    end
    if count > maxCount
        temp = [i];
        maxCount = count;
    elseif count == maxCount
        temp = [temp, i];
    end
end
a.Reg2 = temp;
clear temp count maxCount;
fprintf('a.Reg2 = '); disp(a.Reg2);

%Cau 3
fprintf('Cau 3:\n');
for j = 1:6
    sum = 0;
    count = 0;
    for i = 1:m
        if R(i, j) ~= Inf
            sum = sum + R(i, j);
            count = count + 1;
        end
    end
    if count > 0
        sum = round(sum / count, 1);
    end
    for i = 1:m
        R_mean(i, j) = sum;
        if R(i, j) == Inf
            R_pre(i, j) = sum;
        else
            R_pre(i, j) = R(i, j);
        end
    end
end

[U, S, V] = svd(R_pre - R_mean);
k = min(m, 3);
res = U(:, 1:k) * sqrt(S(1:k,1:k)) * sqrt(S(1:k,1:k)) * V(1:k,:) + R_mean;
for i = 1:m
    for j = 1:6
        if R(i, j) ~= Inf
            res(i, j) = R(i, j);
        else
            res(i, j) = min(max(round(res(i, j), 1), 0), 10);
        end
    end
end
a.Reg3 = res;
clear sum count res R_mean R_pre res U S V k;
fprintf('a.Reg3 = \n'); disp(a.Reg3);

%Cau 4
fprintf('Cau 4:\n');
a.Reg4 = [];
for i = 1:m
    totalPoints = 0;
    totalCredits = 0;
    for j = 1:6
        totalPoints = totalPoints + C(j, 3) * a.Reg3(i, j);
        totalCredits = totalCredits + C(j, 3);
    end
    if totalPoints/totalCredits < 5
        a.Reg4 = [a.Reg4; i];
    end
end
clear totalPoints totalCredits;
fprintf('a.Reg4 = \n'); disp(a.Reg4);

%Cau 5
fprintf('Cau 5:\n');
a.Reg5a = [];
for i = 1:6
    if R(id, i) == Inf && a.Reg3(id, i) < 5
        a.Reg5a = [a.Reg5a, i];
    end
end
if size(a.Reg5a, 2) == 0
    a.Reg5a = 0;
end
a.Reg5b = [];
for i = 1:6
    if R(id, i) == Inf && a.Reg3(id, i) >= 5
        a.Reg5b = [a.Reg5b, i];
    end
end
if size(a.Reg5b, 2) == 0
    a.Reg5b = 0;
end
fprintf('a.Reg5a = '); disp(a.Reg5a);
fprintf('a.Reg5b = '); disp(a.Reg5b);

%Cau 6
fprintf('Cau 6:\n');
a.Reg6 = M;
for i = 1:m
    totalPoints = zeros(1, 2);
    totalCredits = zeros(1, 2);
    for j = 1:6
        if R(i, j) ~= Inf
            for k = 1:2
                if C(j, k) == 1
                    totalPoints(k) = totalPoints(k) + R(i, j);
                    totalCredits(k) = totalCredits(k) + 1;
                    break;
                end
            end
        end
    end
    for j = 1:2
        if totalCredits(j) > 0
            totalPoints(j) = totalPoints(j) / totalCredits(j);   
        end
    end
    if totalPoints(1) > totalPoints(2)
        a.Reg6(i,1:2) = [1, 0];
    elseif totalPoints(1) < totalPoints(2)
        a.Reg6(i,1:2) = [0, 1];
    end
end
clear totalPoints totalCredits;
fprintf('a.Reg6 = \n'); disp(a.Reg6);

%Cau 7
fprintf('Cau 7:\n');
count = 0;
for i = 1:m
    if M(i, 1) ~= a.Reg6(i, 1)
        count = count + 1;
    end
end
a.Reg7 = round(count / m * 100, 1);
clear count;
fprintf('a.Reg7 = '); disp(a.Reg7);

%Cau 8
fprintf('Cau 8:\n');
a.Reg8 = [];
for i = 1:m
    if M(i, 1) ~= a.Reg6(i, 1)
        a.Reg8 = [a.Reg8, i];
    end
end
fprintf('a.Reg8 = '); disp(a.Reg8);