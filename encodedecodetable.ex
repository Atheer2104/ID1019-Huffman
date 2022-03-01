defmodule EncodeDecodeTable do


  # base case here we take in our char together with sequence and add it into acc
  def encode_table(c1, sequence, acc) when is_atom(c1) do
    #IO.inspect(c1, label: "c1 base")
    #IO.inspect(sequence, label: "sequence for c1 in base case")
    [{c1, Enum.reverse(sequence)} | acc]
  end

  # this will be used for when we have encode the start sequence rest of the elements will be in tuple form
  def encode_table({{left, right}, _}, sequence, acc) do
    encode_table(left, [0 | sequence], acc) ++ encode_table(right, [1 | sequence], acc)
  end

  def encode_table({_, left, right}, sequence, acc) do
    encode_table(left, [0 | sequence], acc) ++ encode_table(right, [1 | sequence], acc)
  end

  # this is used for startsequence only because they will be in list format in the begining that is
  def encode_table([{{left, right}, _}], sequence, acc) do
    encode_table(left, [0 | sequence], acc) ++ encode_table(right, [1 | sequence], acc)
  end

  def encode_table([{_, left, right}], sequence, acc) do
    encode_table(left, [0 | sequence], acc) ++ encode_table(right, [1 | sequence], acc)
  end



  def decode_table(c1, sequence, acc) when is_atom(c1) do
    [{c1, sequence} | acc]
  end

  # this will be used for when we have encode the start sequence rest of the elements will be in tuple form
  def decode_table({{left, right}, _}, sequence, acc) do
    decode_table(left, [0 | sequence], acc) ++ decode_table(right, [1 | sequence], acc)
  end

  def decode_table({_, left, right}, sequence, acc) do
    decode_table(left, [0 | sequence], acc) ++ decode_table(right, [1 | sequence], acc)
  end

  # this is used for startsequence only because they will be in list format in the begining that is
  def decode_table([{{left, right}, _}], sequence, acc) do
    decode_table(left, [0 | sequence], acc) ++ decode_table(right, [1 | sequence], acc)
  end

  def decode_table([{_, left, right}], sequence, acc) do
    decode_table(left, [0 | sequence], acc) ++ decode_table(right, [1 | sequence], acc)
  end



end
