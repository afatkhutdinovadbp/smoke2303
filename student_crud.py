from dataclasses import dataclass, asdict
from typing import Optional


@dataclass
class Student:
    id: int
    name: str
    age: int
    email: str
    faculty: str
    gender: str


class StudentCRUD:
    def __init__(self) -> None:
        self._students: dict[int, Student] = {}
        self._next_id = 1

    def create(
        self,
        name: str,
        age: int,
        email: str,
        faculty: str,
        gender: str,
    ) -> Student:
        student = Student(
            id=self._next_id,
            name=name,
            age=age,
            email=email,
            faculty=faculty,
            gender=gender,
        )
        self._students[student.id] = student
        self._next_id += 1
        return student

    def read(self, student_id: int) -> Optional[Student]:
        return self._students.get(student_id)

    def read_all(self) -> list[Student]:
        return list(self._students.values())

    def update(
        self,
        student_id: int,
        name: Optional[str] = None,
        age: Optional[int] = None,
        email: Optional[str] = None,
        faculty: Optional[str] = None,
        gender: Optional[str] = None,
    ) -> Optional[Student]:
        student = self._students.get(student_id)
        if student is None:
            return None
        if name is not None:
            student.name = name
        if age is not None:
            student.age = age
        if email is not None:
            student.email = email
        if faculty is not None:
            student.faculty = faculty
        if gender is not None:
            student.gender = gender
        return student

    def delete(self, student_id: int) -> bool:
        return self._students.pop(student_id, None) is not None


if __name__ == "__main__":
    crud = StudentCRUD()

    alice = crud.create("Alice", 20, "alice@example.com", "CS", "female")
    bob = crud.create("Bob", 22, "bob@example.com", "Math", "male")
    print("Created:", asdict(alice), asdict(bob))

    print("Read:", asdict(crud.read(alice.id)))
    print("All:", [asdict(s) for s in crud.read_all()])

    updated = crud.update(
        alice.id,
        age=21,
        email="alice.new@example.com",
        faculty="AI",
    )
    print("Updated:", asdict(updated))

    print("Deleted Bob:", crud.delete(bob.id))
    print("After delete:", [asdict(s) for s in crud.read_all()])
