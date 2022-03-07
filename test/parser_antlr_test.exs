defmodule DslInterpreter.ParserAntlrTest do
  use ExUnit.Case
  doctest DslInterpreter.Parser

  def parser_for(lang, start_rule) do
    lang_path = Path.expand("./langs/#{lang}", __DIR__)
    DslInterpreter.Parser.new(lang_path, start_rule)
  end

  test "parses ArrayInit grammar" do
    parser = parser_for("ArrayInit", "init")
    {exit_code, output} = DslInterpreter.Parser.Antlr.parse(parser, "{123, 1, 2}")

    assert exit_code == 0
    assert output == "(init { (value 123) , (value 1) , (value 2) })\n"
  end
end
