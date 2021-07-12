%% Sorting fn
function [tab] = lpsort(A,Aeq,b,beq,f)
[m0,n0]=size(A);
[m,n]=size(A);
[m2,n2]=size(Aeq); %n and n2 should be equal

% check for well-behaved constraints (b_i>=0)
k=[]; % index of constraints that sastify the condition (normal constraint)
k4=[]; % index of constraints that DON'T sastify the condition (case 3)
s_in=[]; % index of extra variables
mu_in=[];
t_in=[];
for i=1:m
    if b(i)>=0
        if isempty(k)
            k(1)=i;
        else
            k(end+1)=i;
        end
    else 
        if isempty(k4)
            k4(1)=i;
        else
            k4(end+1)=i;
        end
    end
end
if isempty(k)==0
    % add slack variables, s
    E = zeros(m,length(k));
    for i=1:length(k)
        E(k(i),i)=1;
    end
    A(:,n+1:n+length(k))=E;
    Aeq(:,n+1:n+length(k))=zeros(m2,length(k));
    % index of slack variables
    s_in=length(k);
end

% update size of A and Aeq
[m,n]=size(A);
[m2,~]=size(Aeq);

% check for case 3 (b_i<0)
if isempty(k4)
    f0 = 0; %initial sol (in terms of M)
    f2 = zeros(n,1); %obj fn (terms with M)
else
    P = eye(m);
    E = zeros(m,length(k4));
    e = ones(m,1);
    % Add artificial variable, mu
    for i=1:length(k4)
        P(k4(i),k4(i))=-1; %multiply A by -1
        E(k4(i),i)=-1; %mu)
        e(k4(i))=-1; %multiply b by -1
    end
    A(:,1:n0)=P*A(:,1:n0);
    A(:,end+1:end+length(k4))=E;
    Aeq(:,end+1:end+length(k4))=zeros(m2,length(k4));
    b=b.*e;
    
    % index of slack variables
    mu_in=length(k4);
    
    % update the size of A and Aeq:
    [m,n]=size(A);
    [m2,~]=size(Aeq);
    f0 = 0; %initial sol (in terms of M)
    f2 = zeros(n,1); %obj fn (terms with M)
    
    for i=1:length(k4)
        f0=f0+b(k4(i));
        for j=1:n
            f2(j)=f2(j)+A(k4(i),j);
        end
    end


    % Add artificial variable, t
    A(:,n+1:n+length(k4))=-E;
    Aeq(:,n+1:n+length(k4))=zeros(m2,length(k4));
end

% update size of A and Aeq
[m,n]=size(A);
[m2,~]=size(Aeq); %n and n2 should be equal

% check for case 2 (beq<0)
k2=[];
for i=1:m2
    if beq(i)<0
        if isempty(k2)
            k2(1)=i;
        else
            k2(end+1)=i;
        end
    end
end
if isempty(k2)==0
    P = eye(m2);
    e = ones(m2,1);
    for i=1:length(k2)
        P(k2(i),k2(i))=-1;
        e(k2(i))= -1;
    end
    Aeq(:,1:n0)=P*Aeq(:,1:n0);
    beq=beq.*e;
end

% update size of A and Aeq
[m,n]=size(A);
[m2,~]=size(Aeq); %n and n2 should be equal

%check for case 1 (beq>0) (all Aeq constraints fulfill this condition if Aeq is non-empty):
k3=1:m2;
if m2>0
    n3=length(f2);
    if n>n3
        f2(end+1:n)=zeros(n-n3,1);
    end
    E = eye(m2,m2);
    for i=1:m2
        f0=f0+beq(i);
        for j=1:n
            f2(j)=f2(j)+Aeq(i,j);
        end
    end
    Aeq(:,n+1:n+m2)=E;
    A(:,n+1:n+m2)=zeros(m,m2);

    % update f2
    f2(end+1:end+m2)=zeros(m2,1);
    
    % index of artificial variables, t
    t_in=m2+mu_in;
end

% update size of A and Aeq
[m,n]=size(A);
[m2,~]=size(Aeq); %n and n2 should be equal

% Combine A and Aeq, and b and beq
A(m+1:m+m2,:)=Aeq;
b(m+1:m+m2,1)=beq;

% Tableau
% update the size of A and Aeq:
[m,n]=size(A);
T=zeros(m+2,n+1);
% first row of tableau, no terms with M
T(1,1:length(f))=-f';
% 2nd row of tableau with M terms only
T(2,1:n)=f2';
% 3rd row to end row of tableau
T(3:end,1:n)=A;
% Sol col
T(2,end)=f0;
T(3:end,end)=b;

% writing the tableau col, row names
[m2,n2]=size(T);
var_names={};
for i=1:n0
    str="x_"+num2str(i);
    var_names{i}=char(str);
end
for i=1:s_in
    var_names{n0+i}=char("s_"+num2str(i));
end
for i=1:mu_in
    var_names{n0+s_in+i}=char("mu_"+num2str(i));
end
for i=1:t_in
    var_names{n0+s_in+mu_in+i}=char("t_"+num2str(i));
end
var_names{end+1}='Sol';
row_names={'z','M'};
for i=1:m
    row_names{2+i}='';
end
for i=1:s_in % name regular constraints as s_i
        row_names{2+k(i)}=char("s_"+num2str(i));
end
for i=1:t_in % name the remaining constraints in A and Aeq as t_i's
    for j=1:m
        if isempty(row_names{2+j})
            row_names{2+j}=char("t_"+num2str(i));
            break
        end
    end
end
tab=array2table(T,'VariableNames',var_names,'RowNames',row_names);
end
