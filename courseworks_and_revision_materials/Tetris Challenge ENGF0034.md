### Heuristics

Check tetris piece has no empty air gaps below  
tileable essentially  
bound search first 4 rows

height - lower aggregate height is better usually  
holes - difficult to fill

bumpiness - penalise height differences between adjacent columns

line clears - reward line clears

Distinction is above 20k score

only player.py file changes

15 min max run time  
400 falling blocks max

256mb ram  
50 % of one core

64k top score last year

1 row 25 points  
2 rows at once 100  
3 rows at once 400  
4 rows at once (tetris) 1600

new features  
discard (d) key allows player discard current block (limited uses)  
bomb (b) key turns next block into a bomb blows up surrounding blocks causes blocks above to fall (limited uses)

bounded depth search  
quiescence

72k theoretical maximum score

linux library "resource" restricts amount  
python 3.7.8 venv

&nbsp;

hooks into blocks at the bottom