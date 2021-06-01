from random import choice


class Game:

    def __init__(self):
        self.board = {'0': ' ', '1': ' ', '2': ' ', '3': ' ', '4': ' ', '5': ' ', '6': ' ', '7': ' ', '8': ' '}
        self.player = ''
        self.computer = ''
        self.move_counter = 0

    def print_board(self):
        print(f"\n{self.board['0']}|{self.board['1']}|{self.board['2']}")
        print('-+-+-')
        print(f"{self.board['3']}|{self.board['4']}|{self.board['5']}")
        print('-+-+-')
        print(f"{self.board['6']}|{self.board['7']}|{self.board['8']}")

    def print_info(self):
        print('\nCell indexes:')
        print(f"0|1|2")
        print('-+-+-')
        print(f"3|4|5")
        print('-+-+-')
        print(f"6|7|8")
        print(f"\nYou're playing {self.player} side.")

    def pick_side(self):
        choice = input('\nChoose side: (o/x) ')
        if choice == 'o':
            self.player = choice
            self.computer = 'x'
        elif choice == 'x':
            self.player = choice
            self.computer = 'o'
        else:
            print('Err, choose again.')
            self.pick_side()

    def make_move(self):
        print('\nMake a move.')
        index = input("Enter cell's index: ")
        if index not in self.board or self.board[index] != ' ':
            print('Err, choose again.')
            self.make_move()
        else:
            self.board[index] = self.player

    def check_if_somebody_won(self, board):
        if board['0'] == board['1'] == board['2'] != ' ':
            return '0'
        elif board['3'] == board['4'] == board['5'] != ' ':
            return '3'
        elif board['6'] == board['7'] == board['8'] != ' ':
            return '6'
        elif board['0'] == board['3'] == board['6'] != ' ':
            return '0'
        elif board['1'] == board['4'] == board['7'] != ' ':
            return '1'
        elif board['2'] == board['5'] == board['8'] != ' ':
            return '2'
        elif board['0'] == board['4'] == board['8'] != ' ':
            return '0'
        elif board['2'] == board['4'] == board['6'] != ' ':
            return '2'

        return

    def print_winner(self, cell_index):
        self.print_board()
        if self.board[cell_index] == self.player:
            winner = 'You'
        else:
            winner = 'Computer'
        print(f"\nGame over. {winner} won!")

    def game_loop(self):
        while True:
            if self.player == 'o':
                self.print_board()

                self.make_move()
                self.move_counter += 1
                is_game_finished = self.check_if_somebody_won(self.board)
                if is_game_finished:
                    break
                if self.check_if_draw():
                    break

                self.make_move_computer()
                self.move_counter += 1
                is_game_finished = self.check_if_somebody_won(self.board)
                if is_game_finished:
                    break
                if self.check_if_draw():
                    break

            else:
                self.make_move_computer()
                self.move_counter += 1
                is_game_finished = self.check_if_somebody_won(self.board)
                if is_game_finished:
                    break
                if self.check_if_draw():
                    break

                self.print_board()

                self.make_move()
                self.move_counter += 1
                is_game_finished = self.check_if_somebody_won(self.board)
                if is_game_finished:
                    break
                if self.check_if_draw():
                    break

        if not is_game_finished:
            self.print_board()
            print('\nDraw.')
        else:
            self.print_winner(is_game_finished)
        self.restart_game()

    def restart_game(self):
        answer = input('Do you wanna play again? (y/n) ')
        if answer == 'y':
            for key in self.board:
                self.board[key] = ' '
            self.move_counter = 0
            self.initiate_game()
        elif answer == 'n':
            exit()
        else:
            print('Err, choose again.')
            self.restart_game()

    def initiate_game(self):
        self.pick_side()
        self.print_info()
        self.game_loop()

    def make_move_computer(self):
        for key in self.board:
            board_copy = self.board.copy()
            if board_copy[key] == ' ':
                board_copy[key] = self.computer
                if self.check_if_somebody_won(board_copy):
                    self.board[key] = self.computer
                    return

        for key in self.board:
            board_copy = self.board.copy()
            if board_copy[key] == ' ':
                board_copy[key] = self.player
                if self.check_if_somebody_won(board_copy):
                    self.board[key] = self.computer
                    return

        index = self.get_random_available_index(['0', '2', '6', '8'])
        if index:
            self.board[index] = self.computer
            return

        if self.board['4'] == ' ':
            self.board[index] = self.computer
            return

        self.board[self.get_random_available_index(['1', '3', '5', '7'])] = self.computer

    def get_random_available_index(self, indexes):
        possible_moves = []
        for index in indexes:
            if self.board[index] == ' ':
                possible_moves.append(index)

        if not possible_moves:
            return None
        else:
            return choice(possible_moves)

    def check_if_draw(self):
        if self.move_counter == 9:
            return True

        return False
