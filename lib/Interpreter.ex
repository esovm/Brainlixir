
defmodule BrainfuckInterpreter do
    defp loopProc(code, ip, iteration) do

        if(iteration > 0) do
            loopProc(code, ip - 1, iteration - (case String.at(code, ip - 1) do
                "[" ->  1
                "]" -> -1
                _   ->  0
            end));
        else
            ip;
        end
    end

    defp loopProc(code, ip) do
        loopProc(code, ip, 1)
    end

    defp run(code, dp, ip, tape, doStdin) do
        
        tape = (case String.at(code, ip) do
            "+" -> put_elem(tape, dp, elem(tape, dp) + 1)
            "-" -> put_elem(tape, dp, elem(tape, dp) - 1)
            "," when doStdin == true -> put_elem(tape, dp, :stdin |> IO.stream(1))
            "," -> put_elem(tape, dp, 0)
            _ when dp >= tuple_size(tape)-1 -> Tuple.append(tape, 0)
            _ when dp <= tuple_size(tape) and elem(tape, tuple_size(tape)) == 0 -> Tuple.delete_at(tape, tuple_size(tape)-1)
            _ -> tape
        end);

        dp = (case String.at(code, ip) do
            "<" when dp > 1 -> dp - 1
            ">" -> dp + 1
            _ -> dp;
        end);

        if String.at(code, ip) == ".", do: IO.write(List.to_string([elem(tape, dp)]))

        if(String.at(code, ip) == "]" and elem(tape, dp) > 0) do
            run(code, dp, loopProc(code, ip), tape, doStdin)
        else
            if String.length(code) > 0 and String.at(code, ip) != "#" do
                run(code, dp, ip + 1, tape, doStdin)
            else
                "\nDone.\n"
            end
        end
    end

    def execute(str, doStdin \\ true)

    def execute(str, doStdin) when is_binary(str) do
        run(str <> "#", 1, 0, {:ok, 0}, doStdin)
    end

    def execute(_, _) do
        raise ArgumentError, message: "First parameter was expected to be string."
    end

    def loadAndRun(file, doStdin \\ true) do
        case File.read(file) do
            {:ok, body} -> execute(body, doStdin)
            {:error, reason} -> raise ArgumentError, message: "Couldn't read " <> file <> ": " <> String.upcase(Atom.to_string(reason))
        end
    end
end
