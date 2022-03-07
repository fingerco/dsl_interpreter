defmodule DslInterpreter.Parser.Antlr do
  def parse(parser, code) do
    dir = Path.dirname(parser.lang_path)
    lang = Path.basename(parser.lang_path)

    tmp_code_file = "/tmp/#{UUID.uuid4()}.code.tmp"
    :ok = File.write!(tmp_code_file, code)
    {output, exit_code} = System.cmd("grun", [lang, parser.start_rule, "-tree", tmp_code_file], [
      cd: dir,
      stderr_to_stdout: true
    ])

    File.rm!(tmp_code_file)
    {exit_code, output}
  end
end
