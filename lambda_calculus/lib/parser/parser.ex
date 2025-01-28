defmodule ParserError do
  defexception message: "Parser Error"
end

defmodule LambdaCalculus.Parser.Parser do
  alias LambdaCalculus.Ast.{
    Abstraction,
    Application,
    Variable
  }

  alias LambdaCalculus.Lexer.Token

  @enforce_keys [:curr, :peek, :rest]
  defstruct [:curr, :peek, :rest]

  def from_tokens(tokens) do
    case tokens do
      [curr | [peek | rest]] ->
        %LambdaCalculus.Parser.Parser{curr: curr, peek: peek, rest: rest}

      [curr] when curr.type == :EOF ->
        %LambdaCalculus.Parser.Parser{curr: curr, peek: nil, rest: []}

      _ ->
        raise ParserError, message: "Invalid token stream"
    end
  end

  defp next_token(%LambdaCalculus.Parser.Parser{rest: []} = p) do
    %{p | curr: p.peek, peek: nil}
  end

  defp next_token(%LambdaCalculus.Parser.Parser{} = p) do
    [head | tail] = p.rest
    %{p | curr: p.peek, peek: head, rest: tail}
  end

  defp expect(%LambdaCalculus.Parser.Parser{} = p, expected_type, msg \\ "") do
    if p.curr.type == expected_type do
      next_token(p)
    else
      message =
        if msg == "" do
          "Expected #{expected_type} but got #{p.curr} on line #{p.curr.line}"
        else
          msg
        end

      raise ParserError, message: message
    end
  end

  defp match(%LambdaCalculus.Parser.Parser{curr: curr} = _p, expected_type) do
    if curr.type == expected_type do
      true
    else
      false
    end
  end

  defp consume(%LambdaCalculus.Parser.Parser{curr: curr} = p, expected_type) do
    if curr.type == expected_type do
      {next_token(p), curr}
    else
      :error
    end
  end

  def parse(tokens) do
    from_tokens(tokens)
    |> parse_program([])
  end

  defp parse_program(p, stmts) do
    case p.curr.type do
      :EOF ->
        nil

      :VARIABLE ->
        {new_p, var} = parse_variable(p)
        var

      :LEFT_PAREN ->
        {new_p, abstraction} = parse_abstraction(p)
        abstraction

      _ ->
        msg = "Unexpected token: #{p.curr.type}"
        raise ParserError, message: msg
    end
  end

  defp parse_variable(p) do
    case p.curr.type do
      :VARIABLE ->
        var = %Variable{name: p.curr.lexeme}
        {next_token(p), var}

      _ ->
        msg = "Expected a variable, but got #{p.curr.type}"
        expect(p, nil, msg)
    end
  end

  defp parse_abstraction(p) do
    p = expect(p, :LEFT_PAREN)
    p = expect(p, :LAMBDA)

    {new_p, var} = parse_variable(p)

    p = expect(new_p, :DOT)

    {p, body} = parse_term(p)

    p = expect(p, :RIGHT_PAREN)

    {p, %Abstraction{term: body, param: var}}
  end

  defp parse_term(p) do
    case p.curr.type do
      :VARIABLE -> parse_variable(p)
      :LAMBDA -> parse_abstraction(p)
      :LEFT_PAREN -> parse_parenthesized_term(p)
      _ -> raise "Unexpected token: #{p.curr.type}"
    end
  end

  defp parse_parenthesized_term(p) do
    p = expect(p, :LEFT_PAREN)
    {new_p, term} = parse_term(p)
    p = expect(new_p, :RIGHT_PAREN)
    {p, term}
  end
end
