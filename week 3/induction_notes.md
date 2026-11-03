recursive and structural induction





weak:

Base Case: x = 0

I.H.:  assume x = k is true 

I.S. show x = k+1 is also true

strong:

base case: x = 0 (dont technically need one)

I.H. assume x = k and every element less than k is also true

step: show k+1 is true



k natural set

for all k greater than or equal to 2 -> k is less than 10

base case x= 2


i.h. for all k greater than or equal to 2 -> k is less than 10

inductive step, show k + 1 is true given i.h.

k is exactly less than 10 by i.h,, so 9
k + 1 is then 10, which disproves implication.


u_1 = 6
u_2 = 27

u_n+2 = 6*u_n+1 - 9u_n   n>=1

show for positives n
u_n = 3^n ( n+1)



base case n = 1
3 ^ 1 ( 1 + 1) = 6
= u_1

... = u_2

i.h.
u_k = 3^k ( k+1) 
u_k+1 = 3^(k+1) (k + 2)

step n = u_k+2

6*u_k+1 - 9u_k
6*3^(k+1) ( k+2) - 9 * 3^k (k+1) 		(by i.h.)
.
.
.
= u_k+2 = 3^(k+2) ( k+3)



Show that every natural number n ≥ 2 has a prime divisor.

base case: 2
yes, 2 divides itself, and 2 is prime


inductive hypothesis:
assume for everything up to k, the number has a prime divisor


step:
take k + 1
.
case that k + 1 is even:
	2 is divides all even numbers
	proven boom!
case that k + 1 is odd:
	it has to have a shape of some 2q + 1
	
	more cases!!!
	case k+1 is prime:
		trivially true, k+1 and 1 is its own divisor
	case k+1 is not prime:
		must be the case there are more divisors than just 1 and k+1
		therefore:

			there exists a divisor for k+1 thats less than or equal to k
			by inductive hypothesis, that divisor is less than k, so it has to have a prime divisor
			so k+1 has a prime divisor




strong induction is able to prove more proofs than weak induction?

strong induction is equivalent to weak induction

its always possible to find the other induction equivalent, 


is it true that n split amongst m with minimum 1 value is same as n split amongst m - n split amongst m-1 - ...
c


n objects

m containers

all containers has to be atleast 1



n - m stars
m - 1 bars

n - m + m -1 choose m - 1






binary numbers

   0 1 2 3 4 5 6 7 8 9 ......
1. 1 0 0 0 0 ....
2. 1 0 1 0 0 ....
3. 1 1 1 1 1 ....
4. 0 0 0 0 0 ....
5. 1 0 1 1 1 ....
.
.
.

1 1 0 1 1 ...
0 0 1 0 0 ...

by diagonalisation, positive integers is not equivalent in size as power set of positive integers
for there to be a bijection between two sets, they have to be equal in size, therefore there is no bijection
from positive ints to power set of pos ints.

bam!!