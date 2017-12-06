use std::env;
use std::cmp;


fn make_empty_matrix(i:usize, j:usize) -> Vec<Vec<i32>> {
  let mut res = Vec::with_capacity(i);

  for k in 0..i {
    res.push(Vec::with_capacity(j));
    for _l in 0..j {
      res[k].push(0);
    }
  }
  return res;;
}

fn spir(res: &mut Vec<Vec<i32>>, m: usize, n: usize, i: usize, c: &mut i32) {
  
  for k in i..(n-i) {
    res[i][k] = *c;
    *c = *c+1;
  }
  for k in (i+1)..(m-i) {
    res[k][n-i-1] = *c;
    *c = *c+1;
  }
  if *c < (n*m) as i32 {
    for k in (i..(n-i-1)).rev() {
      res[m-i-1][k] = *c;
      *c = *c+1;
    }
    for k in ((i+1)..(m-i-1)).rev() {
      res[k][i] = *c;
      *c = *c+1;
    }
  }
}

fn print_matrix(res: Vec<Vec<i32>>, m: usize, n: usize) {
  fn nb_len(k:i32) -> i32 {
    if k>0 {
      return ((k as f64).ln()/(10. as f64).ln()) as i32 + 1
    } else {1}
  }

  let max_len = nb_len((m*n) as i32 );

  for i in 0..m {
    for j in 0..n {
      for _k in 0..(max_len - nb_len(res[i][j])) {print!(" ");}
      print!("{} ", res[i][j]);
    }
    print!("\n");
  }
}

fn main () {
  let args: Vec<String> = env::args().collect();
  let n: usize = (args[1]).parse().unwrap();
  let m: usize = (args[2]).parse().unwrap();
  
  let mut res = make_empty_matrix(m,n);
  let mut c = 1;
  let b = (cmp::min(n,m)/2)+1;
  
  for i in 0..b {
    spir(&mut res, m,n,i,&mut c);
  }

  print_matrix(res, m, n);
}
