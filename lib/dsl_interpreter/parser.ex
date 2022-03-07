defmodule DslInterpreter.Parser do
  @enforce_keys [:lang_path, :start_rule]
  defstruct [:lang_path, :start_rule]

  def new(lang_path, start_rule) do
    %DslInterpreter.Parser{lang_path: lang_path, start_rule: start_rule}
  end

  def parse(parser, code) do
    DslInterpreter.Parser.Antlr.parse(parser, code)
  end
end
