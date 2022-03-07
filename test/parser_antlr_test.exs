defmodule DslInterpreter.ParserAntlrTest do
  use ExUnit.Case
  doctest DslInterpreter.Parser

  def parser_for(lang, start_rule) do
    lang_path = "/parsers/#{lang}"
    DslInterpreter.Parser.new(lang_path, start_rule)
  end

  test "parses ArrayInit grammar" do
    parser = parser_for("ArrayInit", "init")
    {exit_code, output} = DslInterpreter.Parser.Antlr.parse(parser, "{123, 1, 2}")

    assert output == "{\n  \"rule\": \"top_level\",\n  \"children\": [\n    {\n      \"type\": 1,\n      \"text\": \"{\"\n    },\n    {\n      \"rule\": \"value\",\n      \"children\": [\n        {\n          \"vocab_symbol\": \"INT\",\n          \"type\": 4,\n          \"text\": \"123\"\n        }\n      ]\n    },\n    {\n      \"type\": 2,\n      \"text\": \",\"\n    },\n    {\n      \"rule\": \"value\",\n      \"children\": [\n        {\n          \"vocab_symbol\": \"INT\",\n          \"type\": 4,\n          \"text\": \"1\"\n        }\n      ]\n    },\n    {\n      \"type\": 2,\n      \"text\": \",\"\n    },\n    {\n      \"rule\": \"value\",\n      \"children\": [\n        {\n          \"vocab_symbol\": \"INT\",\n          \"type\": 4,\n          \"text\": \"2\"\n        }\n      ]\n    },\n    {\n      \"type\": 3,\n      \"text\": \"}\"\n    }\n  ]\n}\n"
    assert exit_code == 0
  end
end
