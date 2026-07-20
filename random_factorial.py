import math
import random


def random_factorial(lo=1, hi=100):
    n = random.randint(lo, hi)
    return n, math.factorial(n)


if __name__ == "__main__":
    n, f = random_factorial()
    print(f"{n}! = {f}")
