
defmodule BrainfuckInterpreter.Main do

    defp process(result) do
        BrainfuckInterpreter.loadAndRun(result.args.infile, result.flags.nostdin)
    end

    def main(args) do
        Optimus.new!(
            name: "brainlixir",
            description: "Industrial-grade Brainfuck interpreter.",
            version: "0.0.4",
            author: "Kamila Palaiologos Szewczyk kspalaiologos@gmail.com",
            allow_unknown_args: false,
            parse_double_dash: true,
            args: [
                infile: [
                    value_name: "input file",
                    help: "File with Brainfuck code.",
                    required: true,
                    parser: :string
                ]
            ],
            flags: [
                nostdin: [
                    short: "-n",
                    long: "--no-stdin",
                    help: "When specified, disable standard input reading (always return 0)",
                    multiple: false,
                ]
            ]
        ) |> Optimus.parse!(args) |> process
    end

end
