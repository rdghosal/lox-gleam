import gleam/io
import gleam/option.{type Option, None, Some}
import gleam/string

// TODO
pub type Literal

pub type TokenInfo {
  Info(line: Int, lexeme: String)
}

pub type Token {
  LParen(line: Int, column: Int, lexeme: String)
  RParen(line: Int, column: Int, lexeme: String)
}

// pub fn scan_token() {}

fn scan_token(
  char: String,
  //  line: Int,
  // column: Int,
) -> Result(Option(Token), String) {
  case char {
    "(" -> Ok(Some(LParen(0, 0, char)))
    ")" -> Ok(Some(RParen(0, 0, char)))
    "\n" | "" -> Ok(None)
    _ -> Error("Unexpected token: " <> char)
  }
}

pub fn lex(input: String, column: Int, tokens: List(Token)) -> Result(List(Token), String) {
  case string.first(input) {
    Ok(c) -> {
      case scan_token(c) {
        Ok(Some(t)) -> {
          string.slice(input, column + 1, string.length(input))
          |> lex(column + 1, [t, ..tokens])
        }
        Ok(None) -> {
          Ok(tokens)
        }
        Error(e) -> Error(e)
      }
    }
    Error(..) -> Ok(tokens)
  }
}
