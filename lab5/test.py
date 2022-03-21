import unittest
from game_lib import game

# I tested the following functionalities:
# - checking if any player has won,
# - checking if there was a draw,
# - generating a random index from the given list.

# For testing I used the `unittest` library. To generate test reports I used `xmlrunner` library.

class TestTicTacToe(unittest.TestCase):

    def setUp(self):
        self.gameObject = game.Game()

    def test_check_if_somebody_won_after_init(self):
        self.assertFalse(self.gameObject.check_if_somebody_won(self.gameObject.board))

    def test_check_if_somebody_won_after_3_moves(self):
        self.gameObject.board['0'] = 'o'
        self.gameObject.board['1'] = 'o'
        self.gameObject.board['2'] = 'o'
        self.assertEqual(self.gameObject.check_if_somebody_won(self.gameObject.board), '0')

    def test_check_if_draw_after_8_moves(self):
        self.gameObject.move_counter = 8
        self.assertFalse(self.gameObject.check_if_draw())

    def test_check_if_draw_after_9_moves(self):
        self.gameObject.move_counter = 9
        self.assertTrue(self.gameObject.check_if_draw())

    def test_get_random_available_index_if_list_has_one_element(self):
        self.assertEqual(self.gameObject.get_random_available_index(['1']), '1')

    def test_get_random_available_index_if_list_has_multiple_element(self):
        self.assertIn(self.gameObject.get_random_available_index(['1', '3', '5', '7']), ['1', '3', '5', '7'])


if __name__ == '__main__':
    import xmlrunner

    runner = xmlrunner.XMLTestRunner(output='test-reports')
    unittest.main(testRunner=runner)

    unittest.main()
