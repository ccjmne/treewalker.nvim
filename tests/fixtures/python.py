class Person:
    def __init__(self, name):
        self.name = name

    def greet(self):
        print(f"Hello, my name is {self.name}!")

class Book:
    def __init__(self, title, author):
        self.title = title
        self.author = author

    def describe(self):
        print(f"{self.title} by {self.author}")

class Car:
    def __init__(self, make, model, year):
        self.make = make
        self.model = model
        self.year = year

    def display_info(self):
        print(f"Make: {self.make}, Model: {self.model}, Year: {self.year}")

def main():
    """
    This function demonstrates a nested structure.
    It uses four levels of nesting to perform different tasks.
    """

    # Level 1: Outer Loop
    for i in range(5):
        print(f"Outer Loop iteration {i+1}")

        # Level 2: Middle Function Call
        def middle_func(x):
            """This function prints a message and returns the input value."""
            print(f"Middle function called with argument {x}.")
            return x

        middle_value = middle_func(i)

        if middle_value == i:
            print("Condition met.")

            # Level 3: Inner Loop
            for j in range(10):
                print(f"Inner Loop iteration {j+1}")

                # Level 4: Deepest Nesting (Conditional Statement)
                if j % 2 == 0:
                    print("Even number detected.")
                else:
                    print("Odd number detected.")

if __name__ == "__main__":
    main()

