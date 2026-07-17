def reverse_string(text: str) -> str:
    return text[::-1]


if __name__ == "__main__":
    text = input("Введите строку: ")
    print(reverse_string(text))
