#!/usr/bin/env python3
"""Simple user login with username and password."""

USERS = {
    "admin": "admin123",
    "user": "password",
    "alina": "secret",
}


def login(username: str, password: str) -> bool:
    stored = USERS.get(username)
    if stored is None:
        print("Пользователь не найден.")
        return False
    if stored != password:
        print("Неверный пароль.")
        return False
    print(f"Добро пожаловать, {username}!")
    return True


if __name__ == "__main__":
    username = input("Логин: ").strip()
    password = input("Пароль: ").strip()
    login(username, password)
