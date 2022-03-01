defmodule EncodeDecode do

  def encode(text, table) do
    List.foldl(text, [], fn(char, acc) ->
      # convert chat into atom
      charAtom = List.to_atom([char])

      # finding the entry of char in our table
      {_, sequence} = List.keyfind(table, charAtom, 0)
      #acc ++ sequence
      sequence ++ acc
    end)
  end

  def decode([], table)  do
    []
  end

  def decode(seq, table) do
    #IO.inspect(maxN, label: "maxN")
    {char, rest} = decode_char(seq, 1, table)
    List.to_charlist([char | decode(rest, table)])
  end
  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    #IO.inspect(n, label: "n")
    #IO.inspect(code, label: "code")
    #IO.inspect(rest, label: "rest")
    case List.keyfind(table, code, 1) do
      {char, ^code} ->
              #IO.puts("found")
              {Atom.to_charlist(char), rest}
      nil ->
        decode_char(seq, n+1, table)

     end
  end


end
