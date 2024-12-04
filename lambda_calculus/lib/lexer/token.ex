defmodule LambdaCalculus.Lexer.Token do
  alias LambdaCalculus.Lexer.Token
  @enforce_keys [:type, :lexeme, :line]
  defstruct [:type, :lexeme, :line]

  def new(type: type, lexeme: lexeme, line: line) do
    %Token{type: type, lexeme: lexeme, line: line}
  end

  def get_line(%Token{line: line} = _token) do
    line
  end

  defimpl String.Chars, for: LambdaCalculus.Lexer.Token do
    def to_string(%LambdaCalculus.Lexer.Token{type: type, lexeme: _lexeme} = _token) do
      "#{type}"
    end
  end
end
