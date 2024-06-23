import gleeunit
import gleeunit/should
import lexer

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}

pub fn lexer_test() {
  let src = "(\n)"
  let expected = Ok([lexer.RParen(2, 1, ")"), lexer.LParen(1, 1, "(")])
  lexer.run(src)
  |> should.equal(expected)
}
