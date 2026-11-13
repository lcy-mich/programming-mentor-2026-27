import os
import random as _random
from adversary import RandomAdversary
from board import Board
from constants import BOARD_HEIGHT, BOARD_WIDTH, DEFAULT_SEED, BLOCK_LIMIT
from exceptions import BlockLimitException
from player import SelectedPlayer

def run():
    # allow override with ADV_SEED env var, otherwise pick a strong random seed
    adv_seed = int(os.environ['ADV_SEED']) if os.environ.get('ADV_SEED') else _random.SystemRandom().randint(0, 2**31-1)
    print("Adversary seed:", adv_seed)

    player = SelectedPlayer()  # player keeps its own internal random seed
    adversary = RandomAdversary(adv_seed, BLOCK_LIMIT)
    board = Board(BOARD_WIDTH, BOARD_HEIGHT)
    
    try:
        for move in board.run(player, adversary):
            pass  # Just run without display
    except BlockLimitException:
        print("Out of blocks")
    
    print("Score=", board.score)

if __name__ == '__main__':
    run()




    from board import Direction, Rotation, Action
from random import Random
import time

class Player:
    def choose_action(self, board):
        raise NotImplementedError


class RandomPlayer(Player): 
    def __init__(self, seed=None):
        self.random = Random(seed)

    def print_board(self, board):
        print("--------")
        for y in range(24):
            s = ""
            for x in range(10):
                if (x,y) in board.cells:
                    s += "#"
                else:
                    s += "."
            print(s, y)
                

            

    def choose_action(self, board):
        # self.print_board(board)
        # time.sleep(0.5)
        return Action


class MyPlayer(Player):

    saved_moves = []

    def __init__(self):
        return
    
    def _scorefunc(self, board, base_score, _debug=False):

        score = board.score - (base_score or 0)
        scorefactor = 0

        lines = 0
        linefactor = 0.760666

        scores = [25, 100, 400, 1600]
        # print(score)
        for value in scores:
            if score >= value:
                lines+= 1


        bumpiness = 0
        bumpfactor = -.184483

        wells = 0
        wellfactor = 0

        holes = 0
        holefactor = -0.35663

        max_overhang_search = 0
        overhangs = 0
        overhangfactor = 0

        heightfactor = 0
        heightscore = 0

        aggheight= 0
        aggheightfactor = -0.510066

        sidebiasfactor = 0
        sidebias = 0 #add wells heuristic

        row_transitions = 0
        row_t_factor = 0

        column_transitions = 0
        column_t_factor = 0

        
        board_arr = [[0 for _ in range(24)] for _ in range(10)]

        surface = [0 for _ in range(10)]

        for (x, y) in board.cells:
            board_arr[x][23-y] = 1

            heightscore = max(heightscore, 23 - y)

            surface[x] = max(surface[x], 24 - y)
            sidebias += -x
        aggheight = sum(surface)
        
        
        for i, y in enumerate(surface[1:]):
            bumpiness += (y - surface[i])


        #holes

        for x in range(10):
            for y in range(24):
                if y < 23:
                    column_transitions += 1 if board_arr[x][y] == board_arr[x][y+1] else 0
                if x < 9:
                    row_transitions += 1 if board_arr[x][y] == board_arr[x+1][y] else 0
                if y < surface[x]:
                    if not board_arr[x][y]:
                        holes += 1
                        #flood fill to check for peeking holes
                        # seen = {(x,y):True}
                        # x_dir = [0,  0, 1, -1]
                        # y_dir = [1, -1, 0,  0]
                        # frontier = [(x, y)]
                        # checked_times = 0
                        # while len(frontier) and checked_times <= max_overhang_search:
                        #     checked_times += 1
                        #     current_pos = frontier.pop()
                        #     for i in range(4):
                        #         new_pos = (current_pos[0] + x_dir[i], current_pos[1] + y_dir[i])
                        #         #print(new_pos)
                        #         if not new_pos in seen and (new_pos[0] >= 0 and new_pos[0] < 10) and (new_pos[1] >= 0 and new_pos[1] < 24) and not board_arr[new_pos[0]][new_pos[1]]:
                        #             seen[new_pos] = True
                        #             if new_pos[1] >= surface[new_pos[0]]:
                        #                 holes -= 1
                        #                 overhangs += 1
                        #                 frontier = []
                        #                 break
                        #             frontier.append(new_pos)
                else:
                    break
                    

        for x in range(10):
            depth = 0
            for y in range(24):
                if (x, y) in board.cells:
                    break
                left = (x==0 or (x-1,y) in board.cells)
                right = (x==9 or (x+1,y) in board.cells)
                if left and right:
                    depth += 1
            wells += depth

        # heuristic place more towards the sides?

        # calculate heuristic
        heuristics = heightfactor*heightscore + bumpfactor*bumpiness + holefactor*holes + sidebias*sidebiasfactor + overhangs*overhangfactor + wells*wellfactor + aggheight*aggheightfactor + row_transitions*row_t_factor + column_t_factor*column_transitions + lines*linefactor

        score *= scorefactor
        score += heuristics
        # if _debug:
        print(board)
        print(f"height: {heightscore} factor: {heightfactor}\nbumpiness: {bumpiness} factor: {bumpfactor}\nholes: {holes} factor: {holefactor}\nside bias:{sidebias} factor: {sidebiasfactor}\noverhangs:{overhangs} factor: {overhangfactor}")
        print(f"total score: {score}")
        return score
    
    def scorefunc(self, board, base_score):

        score = board.score - base_score


        lines = 0
        for line_num, line_score in enumerate([0, 25, 100, 400, 1600]):
            if score >= line_score:
                lines = line_num 

        lbias = 0

        surface = [0 for _ in range(board.width)]

        board_array = [[0 for _ in range(board.height)] for _ in range(board.width)]

        for (x, y) in board.cells:
            board_array[x][board.height-y-1] = board.height-y
            lbias -= x

        holes = 0
        for x in range(board.width):
            surface[x] = max(board_array[x])
            for y in range(surface[x]):
                if board_array[x][y] == 0:
                    holes += 1
        
        bumpiness = 0
        for i, v in enumerate(surface[:-1]):
            bumpiness += abs(surface[i+1]-v)


        row_transitions = 0
        column_transitions = 0
        for x in range(board.width):
            for y in range(board.height):
                if x < board.width - 1:
                    row_transitions += 1 if board_array[x][y] != board_array[x+1][y] else 0
                if y < board.height - 1:
                    column_transitions += 1 if board_array[x][y] != board_array[x][y+1] else 0

        r_empty = surface[board.width-1] + surface[board.width-2] 

        aggregate_height = sum(surface)

        aggweight = -0.510066
        lineweight = 0.760666
        holeweight = -0.35663
        bumpweight = -0.184483
        rtweight =   -0.000001
        ctweight =   -0.0000005
        lbiasweight = 0.0001
        r_empty_factor = 0 if aggregate_height >= 36 else -10000000000
#(-1 if aggregate_height <= 30 else 1)*
        return aggweight*aggregate_height + (-1 if aggregate_height <= 36 else 1)*lineweight*(lines**2) + r_empty_factor*r_empty + holeweight*holes + bumpweight*bumpiness + row_transitions*rtweight + column_transitions*ctweight + lbiasweight*lbias


    def search(self, board, second_iter = False):
        #grid = (x, y, r)
        moveset = [None, Direction.Left, Direction.Right, Direction.Down, Rotation.Clockwise]
        movevector = [(0,-1,0), (-1, -1, 0), (1, -1, 0), (0, -2, 0), (0, -1, 1)]
        root = (board.falling.center[0], board.falling.center[1], 0)
        move_before = {root : -1}
        place_before = {root: None}
        board_at_place = {root : board.clone()}
        seen = {root:0}
        leaves = []

        second_moves = []
        second_score = 0
        second_score_factor = 1

        frontier = [root]

        while len(frontier):    
            current_place = frontier.pop()
            current_board_cells = board_at_place[current_place].cells
            # print(current_place)

            for i in range(len(moveset)):

                new_board = board_at_place[current_place].clone()
    
                move = moveset[i]
                # print("moves")
                # print(move)
                # print('frontier')  
                # print(len(frontier))      
                # print(frontier)
                after_place = (current_place[0] + movevector[i][0], current_place[1] + movevector[i][1], (current_place[2] + movevector[i][2]) % 4)
                # print('after move')
                # print(new_board)
                # print(after_place)
                # print(seen)

                if not new_board.falling: #check moves
                    score = 0
                    if not after_place in seen:
                        score = self.scorefunc(new_board, board.score)
                        if not second_iter and place_before[current_place] and score*.9 >= self.scorefunc(board_at_place[place_before[current_place]], (place_before[place_before[current_place]] and seen[place_before[place_before[current_place]]]) or 0):
                            second_moves, second_score = self.search(new_board, True)
                        leaves.append((after_place,  score + second_score*second_score_factor))
                    move_before[after_place] = move
                    place_before[after_place] = current_place
                    board_at_place[after_place] = new_board.clone()
                    seen[after_place] = score
                    continue
                
                if after_place in seen:
                    continue
                if self.move_success(move, new_board):
                    # print("BEFORE BOARD")
                    # print(new_board)
                    self.follow_moves(new_board, [move])
                    # print("new frontier")
                    # print(move)
                    # print(after_place)
                    # print(new_board)
                    # print("FRONTIER")
                    # print(new_board.falling)
                    if current_board_cells == new_board.cells:
                        frontier.append(after_place)   
                    move_before[after_place] = move
                    place_before[after_place] = current_place
                    board_at_place[after_place] = new_board.clone()
                    seen[after_place] = True
                    continue
                if self.follow_moves(new_board, [move]): #check moves
                    score = self.scorefunc(new_board, board.score)
                    if not second_iter and place_before[current_place] and score*.9 >= self.scorefunc(board_at_place[place_before[current_place]], (place_before[place_before[current_place]] and seen[place_before[place_before[current_place]]]) or 0):
                        # print("check second")
                        second_moves, second_score = self.search(new_board, True)
                        # print(f"first score {score} second score {second_score}")
                    leaves.append((after_place,  score + second_score*second_score_factor))
                    move_before[after_place] = move
                    place_before[after_place] = current_place
                    board_at_place[after_place] = new_board.clone()
                    seen[after_place] = score
                    continue


        leaves = sorted(leaves, key=lambda x : x[1])
        # print(f"leaf amount: {len(leaves)}")
        # for values in leaves:
        #     leaf = values[0]
        #     score = values[1]
            # print(leaf, score)
            # print(board_at_place[leaf])
            # self.scorefunc(board_at_place[leaf], True)
        # print(f"seen {len(seen)}")

        best_leaf, score = leaves.pop()

        # print(best_leaf, score)

        moves = []

        prior_move = move_before[best_leaf]
        prior_place = place_before[best_leaf]
        while prior_move != -1 and prior_place:
            moves.append(prior_move)
            prior_move = move_before[prior_place]
            prior_place = place_before[prior_place]

        # print("FOUND MOVES")
        if not second_iter:
            return moves, second_moves
        return moves, score

    def simulate_iterations(self, board, second_iter=False):
        second_factor = 1
        best_second_moves = []
        best_score = -1000000000000000000000000.0
        best_moves = 0
        best_rot = 0
        try:
            is_bomb = board.falling and board.falling.shape.value == "B"
            for rotations in range(-1, 3):
                new_board = board.clone()
                if not is_bomb:
                    for _ in range(abs(rotations)):
                        # print(new_board.falling)
                        if rotations < 0:
                            if new_board.rotate(Rotation.Anticlockwise):
                                break
                        else:
                            if new_board.rotate(Rotation.Clockwise):
                                break
                
                for moves in range(-new_board.falling.left, new_board.width - new_board.falling.right):
                    newer_board = new_board.clone()
                    for _ in range(abs(moves)):
                        if not newer_board.falling:
                            break
                        if moves < 0:
                            newer_board.move(Direction.Left)
                        else:
                            newer_board.move(Direction.Right)
                    if newer_board.falling:
                        newer_board.move(Direction.Drop)

                    second_score = 0
                    second_moves = []
                    if not second_iter:
                        second_score, second_moves = self.simulate_iterations(newer_board, True)

                    score = self.scorefunc(newer_board, board.score) + second_factor*second_score

                    if not second_iter:
                        highest = (-1, 24)
                        for (x, y) in board.cells:
                            if y <= highest[1]:
                                highest = (x, y)
                        if highest[0] != -1 and highest[1] <= 5:
                            moves = self.move_to(best_moves, best_rot) if not is_bomb else self.move_to(highest[0] - 5, 0)
                            return moves[::-1] + [Action.Bomb, None]
                        
                    # print(newer_board)
                    # print(f"best score, score {best_score}, {score} best moves, rot {best_moves}, {best_rot} current moves, rot {moves}, {rotations}")
                    if score >= best_score:
                        best_moves = moves
                        best_rot = rotations
                        best_score = score
                        best_second_moves = second_moves
        finally:
            if second_iter:
                return best_score, self.move_to(best_moves, best_rot)
            return self.move_to(best_moves, best_rot), best_second_moves



    def move_to(self, moves, rot):
        movements = []
        for _ in range(abs(rot)):
                if rot < 0:
                    movements.append(Rotation.Anticlockwise)
                else:
                    movements.append(Rotation.Clockwise)
        for _ in range(abs(moves)):
            if moves < 0:
                movements.append(Direction.Left)
            else:
                movements.append(Direction.Right)
        movements.append(Direction.Drop)
        # print(movements)
        return movements


    def move_success(self, move, board):
        """
        Moves block count steps on on the board in the given direction. Returns
        true if this action is successful, false otherwise.
        """
        new_board = board.clone()
        block = new_board.falling

        if move == Direction.Right:
            block.cells = {(x+1, y) for (x, y) in block}
            if block.right >= board.width or block.collides(board):
                # We hit something by moving; undo.
                return False
            return True

        elif move == Direction.Left:
            block.cells = {(x-1, y) for (x, y) in block}
            if block.left < 0 or block.collides(board):
                # We hit something by moving; undo.
                return False
            return True

        elif move == Direction.Down:
            if block.supported(board):
                # There is already something directly below the block; mark it
                # as dropped and do not move it.
                return False
            return True
        
        
        cx, cy = block.center
        if move == Rotation.Clockwise:
            block.cells = {(int(-(y-cy)+cx), int(x-cx+cy)) for (x, y) in block}
        elif move == Rotation.Anticlockwise:
            block.cells = {(int(y-cy+cx), int(-(x-cx)+cy)) for (x, y) in block}

        # If block has hit left boundary, back off.
        left = block.left
        if left < 0:
            block.move(Direction.Right, board, -left)
            # We could not correct; abort the move.
            if block.left < 0:
                return False
        # Same for the right boundary.
        right = block.right
        if right >= board.width:
            block.move(Direction.Left, board, right-board.width+1)
            # We could not correct; abort moving.
            if block.right >= board.width:
                return False
        # Do not move beyond the top boundary either.
        top = block.top
        if top < 0:
            block.move(Direction.Down, board, -top)
            # We could not correct; abort moving.
            if block.top < 0:
                return False
        # If we rotated beyond the bottom, there is no way to correct.
        if block.bottom >= board.height:
            return False
        # Also abort if the new position overlaps an existing block.
        if block.collides(board):
            return False
        return True
         
    def follow_moves(self, board, moves):
        while len(moves):
            move = moves.pop()
            check_landed = False
            if isinstance(move, Direction):
                check_landed = board.move(move)
            else:
                check_landed = board.rotate(move)
            if check_landed: #CHECK IF ROTATION ON LANDING STILL WORKS
                return True
        return False

    
    def choose_action(self, board):
        # if not len(self.saved_moves):
        #     # print('bruh')
        #     first_moves, second_moves= self.search(board)
        #     self.saved_moves.append(second_moves)
        #     self.saved_moves.append(first_moves)
        # next_moves = self.saved_moves.pop()
        # while len(next_moves):
        #     yield next_moves.pop()
        # print(self.scorefunc(board))
        if not len(self.saved_moves):
            first_moves, second_moves = self.simulate_iterations(board)
            self.saved_moves.append(first_moves)
            self.saved_moves.append(second_moves)
        next_moves = self.saved_moves.pop(0)
        # time.sleep(10000)/
        # print(get_best_moves)
        for move in next_moves:
            yield move
        
        # print('drop')
        
 
SelectedPlayer = MyPlayer
