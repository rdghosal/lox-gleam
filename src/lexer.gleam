import gleam/option.{type Option, None, Some}
import gleam/string

// TODO
pub type Literal

type Lexer {
  LexerState(source: String, line: Int, column: Int, current: Int, start: Int)
}

pub type Token {
  LParen(line: Int, column: Int, lexeme: String)
  RParen(line: Int, column: Int, lexeme: String)
}

fn scan_token(
  char: String,
  lexer: Lexer,
) -> Result(#(Lexer, Option(Token)), String) {
  let #(line, column) = #(lexer.line, lexer.column)
  case char {
    "(" -> {
      let lexer = advance(lexer, False)
      Ok(#(lexer, Some(LParen(line, column, char))))
    }
    ")" -> {
      let lexer = advance(lexer, False)
      Ok(#(lexer, Some(RParen(line, column, char))))
    }
    "\n" -> {
      let lexer = advance(lexer, True)
      Ok(#(lexer, None))
    }
    "" -> {
      let lexer = advance(lexer, False)
      Ok(#(lexer, None))
    }
    _ -> Error("Unexpected token: " <> char)
  }
}

fn advance(lexer: Lexer, move_line: Bool) -> Lexer {
  let #(line, column) = case move_line {
    True -> #(lexer.line + 1, 1)
    False -> #(lexer.line, lexer.column + 1)
  }
  LexerState(..lexer, current: lexer.current + 1, line: line, column: column)
}

fn peek(lexer: Lexer) -> String {
  string.slice(lexer.source, lexer.current, 1)
}

fn lex(lexer: Lexer, tokens: List(Token)) -> Result(List(Token), String) {
  case lexer.current <= string.length(lexer.source) {
    True -> {
      let result =
        peek(lexer)
        |> scan_token(lexer)
      case result {
        Ok(#(lexer, Some(token))) -> lex(lexer, [token, ..tokens])
        Ok(#(lexer, None)) -> lex(lexer, tokens)
        Error(e) -> Error(e)
      }
    }
    False -> Ok(tokens)
  }
}

pub fn run(input: String) -> Result(List(Token), String) {
  let lexer = LexerState(input, line: 1, column: 1, current: 0, start: 0)
  lex(lexer, [])
}
