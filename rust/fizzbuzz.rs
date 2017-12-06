
fn pow(x:i32, k:i32) -> i32{ if k == 0 {1}  else {x*pow(x,k-1)} }

fn sum(v: Vec<i32>) -> i32 { let mut s = 0; for i in v { s+= i}; s }
  
fn nb_len(k:i32) -> i32 {
  if k>0 { ((k as f64).ln()/(10. as f64).ln()) as i32 + 1   } else {1}
}


fn digit(n:i32,k:i32) -> i32 {
  return (n /(pow(10,k)) - (n / pow(10,k+1))*10);
}

fn to_digits(n:i32) -> Vec<i32> {
  let mut res = Vec::new();
  for i in 0..nb_len(n) {   res.push(digit(n,i) );   }
  res
}

  
fn fizz(mut n:i32) -> bool {
  while nb_len(n) > 1 {
    n = sum(to_digits(n));
  }
  (n == 3 || n == 6 || n == 9)
}

fn buzz(n:i32) -> bool {digit(n,0) == 0 || digit(n,0) == 5}

fn main() {
  for i in 0..100 {
    if fizz(i) {
      if buzz(i) {  print!("fizzbuzz ");   }
      else {print!("fizz ");}
    }
    else if buzz(i) {print!("buzz ");}
    else {print!("{} ", i);}
  }
}
