import math
import random
import unittest
from unittest.mock import patch

from random_factorial import random_factorial


class RandomFactorialTest(unittest.TestCase):
    def test_returns_number_in_range(self):
        for _ in range(100):
            n, _ = random_factorial()
            self.assertGreaterEqual(n, 1)
            self.assertLessEqual(n, 100)

    def test_factorial_matches_number(self):
        for _ in range(100):
            n, f = random_factorial()
            self.assertEqual(f, math.factorial(n))

    def test_custom_range(self):
        n, f = random_factorial(5, 5)
        self.assertEqual(n, 5)
        self.assertEqual(f, 120)

    @patch("random_factorial.random.randint")
    def test_uses_random_randint_with_default_bounds(self, mock_randint):
        mock_randint.return_value = 10
        n, f = random_factorial()
        mock_randint.assert_called_once_with(1, 100)
        self.assertEqual(n, 10)
        self.assertEqual(f, 3628800)


if __name__ == "__main__":
    unittest.main()
