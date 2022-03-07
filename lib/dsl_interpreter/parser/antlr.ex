defmodule DslInterpreter.Parser.Antlr do
  alias Porcelain.Result

  def parse(parser, code) do
    tmp_code_file = "/tmp/#{UUID.uuid4()}.code.tmp"
    :ok = File.write!(tmp_code_file, code)
    %Result{out: output, status: status} = Porcelain.shell("cat #{tmp_code_file} | #{parser.lang_path}")
    :ok = File.rm!(tmp_code_file)
    {status, output}
  end
end
