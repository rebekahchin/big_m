# big_m
## lpsort - Documentation
### Syntax
```MATLAB
tab = lpsort(A,Aeq,b,beq,f)
```
### Description
Linear programming calculator that produces a tableau based on the problem specified by:\
<img src="https://user-images.githubusercontent.com/83638650/125194032-0d32f000-e282-11eb-9890-7b507c4c9060.png" height="100">\
where `f`, `x`, `b`, and `beq` are vectors, and `A` and `Aeq` are matrices.\
`tab = lpsort(A,Aeq,b,beq,f)` produces a tableau that would be solved by `lpsolve()` based on the the given constraints `A`, `b`, `Aeq`, and `beq`. 
>Note: Set `Aeq` and `beq` as `[]` if no such constraints exist.
### Examples
For the problem:\
<img src="https://user-images.githubusercontent.com/83638650/125194681-ecb86500-e284-11eb-9197-5a87be0aa1b4.png" height="200">\
set
```MATLAB
A =  [1 2 3 4 5;
      6 7 8 9 10;
      11 12 13 14 15;
Aeq = [16 17 18 19 20;
       21 22 23 24 25;
       26 27 28 29 30];
b = [
```
