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
  line: Int,
  column: Int,
) -> Result(#(Option(Token), Int), String) {
  case char {
    "(" -> Ok(#(Some(LParen(line, column, char)), line))
    ")" -> Ok(#(Some(RParen(line, column, char)), line))
    "\n" -> Ok(#(None, line + 1))
    "" -> Ok(#(None, line))
    _ -> Error("Unexpected token: " <> char)
  }
}

pub fn lex(
  input: String,
  pos: Int,
  line: Int,
  column: Int,
  tokens: List(Token),
) -> Result(List(Token), String) {
  case string.first(input) {
    Ok(char) -> {
      let next_pos = pos + 1
      case scan_token(char, line, column) {
        Ok(#(Some(t), next_line)) -> {
          string.slice(input, 1, string.length(input))
          |> lex(next_pos, next_line, column + 1, [t, ..tokens])
        }
        Ok(#(None, next_line)) -> {
          string.slice(input, 1, string.length(input))
          |> lex(next_pos, next_line, 1, tokens)
        }
        Error(e) -> Error(e)
      }
    }
    Error(_) -> Ok(tokens)
  }
}
