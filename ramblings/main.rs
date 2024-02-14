struct Data(u32);

fn main() {
    let vec = vec![Data(0), Data(2)];
    for elem in vec {
        process(elem);
    }
}

fn process(data: Data) { }