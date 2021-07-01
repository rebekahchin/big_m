%% Solving function
function tab = lpsolve(tab,c,r)
T = table2array(tab);
T(r,:) = T(r,:)/T(r,c);
[n,~]=size(T);
for i=1:n
    if i~=r
        T(i,:) = T(i,:) - T(i,c)*T(r,:);
    end
end
tab.Properties.RowNames{r}=tab.Properties.VariableNames{c};
row_names=tab.Properties.RowNames;
var_names=tab.Properties.VariableNames;
tab=array2table(T,'VariableNames',var_names,'RowNames',row_names);
end
