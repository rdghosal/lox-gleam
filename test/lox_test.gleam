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
    let expected = Ok([lexer.LParen(0, 0, "(")])
    lexer.lex("(", 0, [])
    |> should.equal(expected)
}
