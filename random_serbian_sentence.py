#!/usr/bin/env python3
"""Prints a random Serbian sentence in Cyrillic."""

import random

SUBJECTS = [
    "Дечак",
    "Девојка",
    "Студент",
    "Учитељ",
    "Мачка",
    "Пас",
    "Пријатељ",
    "Комшија",
]

VERBS = [
    "чита",
    "пише",
    "једе",
    "пије",
    "гледа",
    "слуша",
    "воли",
    "тражи",
]

OBJECTS = [
    "књигу",
    "писмо",
    "хлеб",
    "воду",
    "филм",
    "музику",
    "кафу",
    "цвеће",
]

PLACES = [
    "у парку",
    "код куће",
    "у школи",
    "на улици",
    "у кафићу",
    "поред реке",
    "у библиотеци",
    "на тргу",
]


def random_sentence() -> str:
    return f"{random.choice(SUBJECTS)} {random.choice(VERBS)} {random.choice(OBJECTS)} {random.choice(PLACES)}."


if __name__ == "__main__":
    print(random_sentence())
