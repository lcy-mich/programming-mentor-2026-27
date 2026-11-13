- functions
- image
- inverse image
- injectivity (one to one)
- surjectivity (onto)
- bijectivity
- pre-images and inverse functions
- cardinality
- size of integers compared to rationals
- size of integers compared to reals

0 is a natural number
0 is a natural number
0 is a natural number
0 is a natural number

quantifiers that encapsulate the whole implication does not change on converse or inverse, however, if theres a negation in front of a quantifier, then it can change through some massaging, such as not for all x, such that P(x) becomes there exists x, such that not P(x).

basically you push the negation inside and swap the quantifier from there exists to for all and vice versa, and you can do it the other way round aswell.




let f : X -> Y be a function

show that:

if B is a subset of Y then
	f(f^-1(B)) is a subset of B

and

if f is surjective then
	f(f^-1(B)) = B

surjection definition:
	for all b in codomain, there exists an a in domain s.t. f(a) = b

subset definition:
	A is a subset of B
	when every element in A is an element in B

image definition:
	let f be a function from set X to Y
	an image of f = { y in Y | y = f(x) for some x in X }

inverse image definition:
	the inverse image of an element b in the codomain is the set of values a in the domain
	thats mapped to b by the function f:
		inverse image of b = { a | f(a) = b }

show is subset:

1.	f^-1(B) is the union of the inverse images of b where b is an element of B
2. f^-1(B) = { x in X | f(x) is an element of B }
3. f(f^-1(B)) = { y in Y | y = f(x) for some x in f^-1(B)} by definition of image
4. all ys in line (3) is an element of B
5. all elements of f(f^-1(B)) is an element of B
6. f(f^-1(B)) is a subset of B by definition of subsets

show is equal when surjective:

sufficient to show equivalence by showing subset the other way
1. for all y in Y, there exists an x in X such that f(x) = y by surjectivity
2. there exists an x such that f(x) = b for all b in B by line (1)
3. so there exists an x in X that is an element of f^-1(B)
4. as there exists an x in X such that b = f(x) and f(x) is an element of f(f^-1(B)) for all b in B
5. so every b from B is an element of f(f^-1(B))
6. so B is a subset of f(f^-1(B))
7. and as f(f^-1(B)) is a subset of B by prior proof, and by line (6), f(f^-1(B)) = B
