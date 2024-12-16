use rand::{thread_rng, Rng};
use strum::IntoEnumIterator;
use strum_macros::{Display, EnumIter};
use serde::{Serialize, Deserialize};

// Define a trait that describes how to calculate the area of a shape
trait Shape {
    fn area(&self) -> f64;
}

// Implement the Shape trait for a Circle
struct Circle {
    radius: f64,
}

impl Shape for Circle {
    fn area(&self) -> f64 {
        std::f64::consts::PI * self.radius.powi(2)
    }
}

// Implement the Shape trait for a Rectangle
struct Rectangle {
    width: f64,
    height: f64,
}

impl Shape for Rectangle {
    fn area(&self) -> f64 {
        self.width * self.height
    }
}

fn calculate_area(shape: &dyn Shape) -> f64 {
    shape.area()
}

// Define a function that uses the Shape trait to print the area of an object
fn print_shape_area(shape: &dyn Shape) {
    println!("The area of this shape is: {}", calculate_area(shape));
}

fn main() {
    let circle = Circle { radius: 5.0 };
    let rectangle = Rectangle { width: 4.0, height: 6.0 };

    print_shape_area(&circle);
    print_shape_area(&rectangle);

    // Example of a function that uses both the Shape and Display traits
    fn display_area<T: Shape + std::fmt::Display>(shape: &T) {
        println!("The area of this {} is: {}", shape, calculate_area(shape));
    }

    display_area(&circle);
    display_area(&rectangle);

    // Example of a function that uses the Shape trait with generics
    fn sum_areas<T: Shape>(shapes: Vec<&T>) -> f64 {
        shapes.iter().map(|shape| shape.area()).sum()
    }

    let shapes = vec![&circle, &rectangle];
    println!("The total area is: {}", sum_areas(shapes));
}
