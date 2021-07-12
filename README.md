# big_m
## lpsort - Documentation
### Syntax
```MATLAB
tab = lpsort(A,Aeq,b,beq,f)
```
### Description
Linear programming calculator that produces a tableau based on the problem specified by:\
\
<img src="https://user-images.githubusercontent.com/83638650/125194032-0d32f000-e282-11eb-9890-7b507c4c9060.png" height="100">\
where `f`, `x`, `b`, and `beq` are vectors, and `A` and `Aeq` are matrices.
***
`tab = lpsort(A,Aeq,b,beq,f)` produces a tableau that would be solved by `lpsolve` based on the the given constraints `A`, `b`, `Aeq`, and `beq`. 
***
>Note: Set `Aeq` and `beq` as `[]` if no such constraints exist.
### Example
For the problem:\
\
<img src="https://user-images.githubusercontent.com/83638650/125269767-99edb480-e33b-11eb-8334-f342ab9e8ab3.png" height="200">\
Set:
```MATLAB
A =  [6 7 8 9 10;
      -11 12 13 -14 15;
      -16 17 18 -19 20];
Aeq = [21 22 23 24 25;
       -26 27 28 -29 30
       -31 32 33 -34 35];
b = [1; -1; -1];
beq = [1; -1; -1];
f = [-1; 2; 3; -4; 5];
```
Use `lpsort`:
```
tab = lpsort(A,Aeq,b,beq,f)
```
Output:
```
tab =

  8×14 table

           x_1    x_2    x_3    x_4    x_5    s_1    mu_1    mu_2    t_1    t_2    t_3    t_4    t_5    Sol
           ___    ___    ___    ___    ___    ___    ____    ____    ___    ___    ___    ___    ___    ___

    z        1     -2     -3      4     -5     0       0       0      0      0      0      0      0      0 
    M      105    -66    -69    120    -75     0      -1      -1      0      0      0      0      0      5 
    s_1      6      7      8      9     10     1       0       0      0      0      0      0      0      1 
    t_1     11    -12    -13     14    -15     0      -1       0      1      0      0      0      0      1 
    t_2     16    -17    -18     19    -20     0       0      -1      0      1      0      0      0      1 
    t_3     21     22     23     24     25     0       0       0      0      0      1      0      0      1 
    t_4     26    -27    -28     29    -30     0       0       0      0      0      0      1      0      1 
    t_5     31    -32    -33     34    -35     0       0       0      0      0      0      0      1      1 
```
>Note: Here, the second row, the `M` row, contains the M terms that would ordinarily be in the `Z` row should one solve the tableau by hand.
## lpsolve - Documentation
### Syntax
```MATLAB
tab = lpsolve(tab,c,r)
```

### Description
>Note: This function is dependent on the output of `lpsort`.
***
`tab = lpsolve(tab,c,r)` performs row operations on the `tab` based on the pivot element. The pivot element is the (`r`,`c`)th element of `tab`, where `c` is the entering column, and `r` the leaving row, while `tab` is the output from `lpsort`.
***

### Example
From [the earlier example](https://github.com/rebekahchin/big_m#example), we see that the entering column, `c`, is `x_4`, while the leaving row, `r`, is `t_5`, based on the simplex algorithm.\
\
Having used `lpsort`, use `lpsolve`:
```MATLAB
tab = lpsolve(tab,4,8)
```
\
Output:
```
tab =

  8×14 table

             x_1         x_2         x_3       x_4      x_5       s_1    mu_1    mu_2    t_1    t_2    t_3    t_4      t_5         Sol   
           ________    ________    ________    ___    ________    ___    ____    ____    ___    ___    ___    ___    ________    ________

    z       -2.6471      1.7647     0.88235     0     -0.88235     0       0       0      0      0      0      0     -0.11765    -0.11765
    M       -4.4118      46.941      47.471     0       48.529     0      -1      -1      0      0      0      0      -3.5294      1.4706
    s_1     -2.2059      15.471      16.735     0       19.265     1       0       0      0      0      0      0     -0.26471     0.73529
    t_1     -1.7647      1.1765     0.58824     0     -0.58824     0      -1       0      1      0      0      0     -0.41176     0.58824
    t_2     -1.3235     0.88235     0.44118     0     -0.44118     0       0      -1      0      1      0      0     -0.55882     0.44118
    t_3    -0.88235      44.588      46.294     0       49.706     0       0       0      0      0      1      0     -0.70588     0.29412
    t_4    -0.44118     0.29412     0.14706     0     -0.14706     0       0       0      0      0      0      1     -0.85294     0.14706
    x_4     0.91176    -0.94118    -0.97059     1      -1.0294     0       0       0      0      0      0      0     0.029412    0.029412
```
