# sorting, complexity, and queues

## Abstract data type
- a mathematical model for data types defined by behaviour (semantics) from the point of view of the user
	- defines what operations are supported (the interface)
		- list, stack, queue, set, map

## Data structure
- concrete way of data organisation in memory to implement an ADT efficiently
	- defines how data is stored and operations are implemented
 
## Big O Notation
- provides an asymptotic upper bound on the growth rate (worse case scenario)
	- O(1), constant, execution is independent of N. Ideal
	- O(log n), logarithmic, time increases very slowly (binary search)
	- O(n), linear, time is proportional to N
	- O(n log n), log-linear, common in efficient sorting algorithms
	- O(n^2), quadratic, time grows rapidly; too slow for large N
 
## Arrays (contiguous memory)
- Fast random access (o(1) indexing), cache friendly (locality of reference)
- insertion and deletion is ammortised o(n) as elements are shifted

## Linked List (non-contiguous memory)
- dynamic size with fast insertion and deletion
- slow to access

## Queue
- FIFO data structure
	- Enqueue (ADD), goal O(1)
	- Dequeue (POP), goal O(1)
	- IsEmpty (Check empty), goal O(1)
- Applications
	- Task scheduling (OS), network buffers, BFS (Breadth-First Search)
 
	- class invariant (if queue is empty, both head and tail is none )
 
# Sorting problem

- formal definition
	- Input: A sequence of N elements A = {a_1, a_2, a_3 ..., a_n} and a total order relations <=.
	- Output: A permutation (reordering) A' = {a_1', a_2', a_3', ..., a_n'} such that a_1' <= a_2' <= a_3' <= ... <= a_n'
 
- use case
	- enables efficient searching (binary search)
	- prerequesite for other algorithms (finding duplicates, median calculation, database joining)
 
- sorting is an operation/ problem, not algorithm
	- the problem: given a collection fo items, arrange them in a specific order
	- the algorithms: the specific, step-by-step procedures used to achieve this arrangement
 
- alternative formulation, linear optimisation
	- goal: find a permutation matrix P, that sorts a vector x in ascending order.
	- formulation: maximise the inner product of the permuted vector P_x with a vector of increasing weights w
	- subject to contraints that P is a doubly stochastic matrix

 - theoretical limit
	 - comparison models are algorithms that only use pair-wise comparisons
	 - any comparison-based sorting algorithm must perform O(N log N) comparisons in the worst case scenario to sort N items.
	 - proof sketch
		 - N! possible permutations (orderings) of input
		 - algorithm distinguish these using binary comparisons (a decision tree), with N! leaves
		 - height of tree H represent worst-case number of comparisons
		 - A binary tree of height H has at most 2^H leaves
		 - 2^H >= N! ==> H >= log_2(N!)
		 - Stirling's approximation, log_2(N!) ~= N log_2(N)
		 - thus, H = O(N log N)