
defmodule BrainfuckInterpreter do
    def loopProc(code, ip, iteration) do

        if(iteration > 0) do
            loopProc(code, ip - 1, iteration - (case String.at(code, ip - 1) do
                "[" -> 1;
                "]" -> -1;
                _   -> 0;
            end));
        else
            ip;
        end
    end

    def loopProc(code, ip) do
        loopProc(code, ip, 1)
    end

    def run(code, dp, ip, tape) do
        
        tape = (case String.at(code, ip) do
            "+" -> put_elem(tape, dp, elem(tape, dp) + 1);
            "-" -> put_elem(tape, dp, elem(tape, dp) - 1);
            "," -> put_elem(tape, dp, :stdin |> IO.stream(1));
            _ when dp >= tuple_size(tape)-1 -> Tuple.append(tape, 0);
            _ -> tape
        end);

        dp = (case String.at(code, ip) do
            "<" when dp > 1 -> dp - 1;
            ">" -> dp + 1;
            _ -> dp;
        end);

        if(String.at(code, ip) == ".") do
            IO.write(List.to_string([elem(tape, dp)]));
        end

        if(String.at(code, ip) == "]" and elem(tape, dp) > 0) do
            run(code, dp, loopProc(code, ip), tape);
        end

        if String.length(code) > 0 and String.at(code, ip) != "#" do
            run(code, dp, ip + 1, tape);
        end
    end

    def execute(str) when is_binary(str) do
        run(str, 1, 0, {:ok, 0});
    end

    def execute(_) do
        raise ArgumentError, message: "First parameter was expected to be string.";
    end
end

BrainfuckInterpreter.execute("++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.#");
