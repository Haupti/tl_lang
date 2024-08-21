
# Syntax

## like lisp ...
...basically


## ...except the types
function definitions take the types for the arguments of the function and the return type like this:
```
(defun (int string) (fizzbuzz arg)
    (cond 
        [= (% arg 3) (% arg 5) 0] "fizzbuzz"
        [= (% arg 3) 0] "fizz"
        [= (% arg 5) 0] "buzz"
        default (str arg)
    )
)
```
where `int` is the type of the functions argument and string is the type of the returned value

the same is true for typing of variables
```
(let int a 5)
(const string b "five")
```

and for lambdas:
```
(lambda (int string) (x) 
    (let string y (str x))
    (print y)
    y
)
```
they take three arguments, a list of types, a list of argument names and then the body

## and defining types themselfes

```
(type name int float bool)
```
for a general type alias

and 
```
(type greeting "hi" "salut" "gude")
```
for a value type
or combination

```
(type result "success" int)
```

