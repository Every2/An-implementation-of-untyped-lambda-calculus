defmodule LexerError do
  defexception message: "Lexer error"
end

defmodule LambdaCalculus.Lexer.Scanner do
  alias LambdaCalculus.Lexer.Token

  def error(message) do
    raise message
  end

  def is_var(c) do
	(c >= "a" && c <= "z" || (c >= "A" && c <= "Z"))
  end

  def operators(_chars = [char | rest], tokens, line) do
	token =
	  case char do
		"(" -> Token.new(type: :LEFT_PAREN, lexeme: char, line: line)
		")" -> Token.new(type: :RIGHT_PAREN, lexeme: char, line: line)
		"." -> Token.new(type: :DOT, lexeme: char, line: line)
		"\\" -> Token.new(type: :LAMBDA, lexeme: char, line: line)
		_ -> raise LexerError, message: "Lexer Error: Unexpected char #{char}"
	  end

	tokenize(rest, [token | tokens], line)
  end

  def is_whitespace(c) do
	c == "" || c == " " || c == "\t" || c == "\r"
  end

  def identifier_op(chars, tokens, line) do
	{identifier, rest} = Enum.split_while(chars, fn c -> is_var(c) end)

	identifier = Enum.join(identifier)

	type = :VARIABLE

	token = Token.new(type: type, lexeme: identifier, line: line)

	tokenize(rest, [token | tokens], line)
  end
  
  def tokenize(content) do
	chars = String.split(content, "", trim: true)
	tokenize(chars, [], 1)
  end
  
  def tokenize(chars = [char | rest], tokens, line) do
	cond do
	  is_whitespace(char) ->
		tokenize(rest, tokens, line)
	  is_var(char) ->
		identifier_op(chars, tokens, line)
	  true ->
		operators(chars, tokens, line)
	end
  end

  def tokenize([], tokens, line) do
	Enum.reverse([Token.new(type: :EOF, lexeme: "", line: line) | tokens])
  end
end
