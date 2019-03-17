
defmodule BrainfuckInterpreter do
    def performOb(code, ip) do

        if(String.at(code[ip]) != "]") do
            performOb(code, ip + 1);
        else
            ip;
        end
        
    end

    def performCb(code, loop, ip) do

        if(loop > 0 and String.at(code, ip) != "]") do
            performCb(code, loop, ip - 1);
        else
            ip;
        end

    end

    def run(code, loop, dp, ip, tape) do
        
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

        if(String.at(code, ip) == "[") do
            if(elem(tape, dp) > 0) do
                loop = loop + 1;
            end

            if(elem(tape, dp) == 0) do
                loop = loop - 1;
                ip = performOb(code, ip);
            end
        end

        if(String.at(code, ip) == "]" and loop != 1 and elem(tape, dp) != 0) do
            ip = performCb(code, loop, ip);
            ip = ip - 1;
        end

        if String.length(code) > 0 and String.at(code, ip) != "#" do
            run(code, loop, dp, ip + 1, tape);
        end
    end

    def execute(str) when is_binary(str) do
        run(str, 0, 1, 0, {:ok, 0});
    end

    def execute(_) do
        raise ArgumentError, message: "First parameter was expected to be string.";
    end
end

BrainfuckInterpreter.execute("++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.");
