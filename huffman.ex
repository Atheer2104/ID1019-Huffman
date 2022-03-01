defmodule Huffman do
  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text()  do
    'this is something that we should encode'
  end

  def text1()  do
    'AAAAAAAAAAEEEEEEEEEEEEEEEIIIIIIIIIIIISSSTTTTPPPPPPPPPPPPP\n'
  end

  def text2()  do
    'AAAAAAAAAA EEEEEEEEEEEEEEE IIIIIIIIIIII SSS TTTT PPPPPPPPPPPPP \n'
  end

  def text3()  do
    'this is some'
  end

  # create a Huffman tree given a sample text.
  # sample is our text but in will be internaly a list of charaters foo = [102, 111, 111]
  def tree(sample) do
    freq = Huffmantree.freq(sample)
    Huffmantree.huffman(freq)
  end

  # create an encoding table containing the map-ping from characters to codes given a Huffman tree.
  # left: 0
  # right: 1
  def encode_table(tree) do
    EncodeDecodeTable.encode_table(tree, [], [])
  end

  # create an decoding table containing the mapping from codes to characters given a Huffman tree.
  def decode_table(tree) do
    # To implement...
    #EncodeDecode.decode_table(tree, [], [])
    EncodeDecodeTable.encode_table(tree, [], [])
  end

  # encode the text using the mapping in the ta- ble, return a sequence of bits.
  def encode(text, table) do
    # To implement...
    EncodeDecode.encode(text, table)
  end

  # decode the bit sequence using the map- ping in table, return a text.
  def decode(seq, table) do
    # To implement..
    #EncodeDecode.decode(seq, table)
    Enum.reverse(EncodeDecode.decode(seq, table))
  end


  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)

    case :unicode.characters_to_list(binary, :utf8) do
        {:incomplete, list, _} ->
          list
        list ->
          list
    end
  end

  def test(n, text, l) do
      list = read(text)

      #List.to_charlist(list)
      {timeTree, t} = :timer.tc(fn() -> loop(l, fn -> tree(list) end) end)
      {timeEncodingTable, encodingTable} = :timer.tc(fn() -> loop(l, fn -> encode_table(t) end) end)
      {timeEncoding, sequence} = :timer.tc(fn() -> loop(l, fn -> encode(list, encodingTable) end) end)
      #decodingTable = decode_table(t)
      {timeDecoding, _} = :timer.tc(fn() -> loop(l, fn -> decode(sequence, encodingTable) end) end)
      {n, timeTree, timeEncodingTable, timeEncoding, timeDecoding}
  end

  def bench(), do: bench(50)

  def bench(l) do

    bench = fn() ->

      time = fn(fun) ->
        fun.()
      end

      test500 = fn () ->
        test(:"500", "dummytext500.txt", l)
      end

      test1k = fn () ->
        test(:"1k", "dummytext1k.txt", l)
      end

      test2k = fn () ->
        test(:"2k", "dummytext2k.txt", l)
      end

      test4k = fn () ->
        test(:"4k","dummytext4k.txt", l)
      end

      test8k = fn () ->
        test(:"8k", "dummytext8k.txt", l)
      end

      test16k = fn () ->
        test(:"16k", "dummytext16k.txt", l)
      end

      test32k = fn () ->
        test(:"32k", "dummytext32k.txt", l)
      end

      test64k = fn () ->
        test(:"64k", "dummytext64k.txt", l)
      end

      test100k = fn () ->
        test(:"100k", "dummytext100k.txt", l)
      end

      time500 = time.(test500)
      time1k = time.(test1k)
      time2k = time.(test2k)
      time4k = time.(test4k)
      time8k = time.(test8k)
      time16k = time.(test16k)
      time32k = time.(test32k)
      time64k = time.(test64k)
      time100k = time.(test100k)


      write = fn(benchmarks) ->
        #benchmarks
        Enum.each(benchmarks, fn(x) ->
          {n, timeTree, timeEncodingTable, timeSequence, timeDecoding} = x
          IO.write("#{n}\t\t\t#{timeTree}\t\t\t#{timeEncodingTable}\t\t\t#{timeSequence}\t\t\t#{timeDecoding}\n")
        end)
      end

      benchmarks = [time500, time1k, time2k, time4k, time8k, time16k, time32k, time64k, time100k]
      #benchmarks = [time500, time1k, time2k]
      #benchmarks = [time500]
      write.(benchmarks)
    end

    IO.write("# benchmark of Huffman loops: #{l} \n")
    IO.write("N\t\t     timeTree \t\ttimeEncodingTable \t    timeEncoding \t   timeDecoding \n")

    bench.()

  end

  def loop(1,f) do f.() end
  def loop(n, f) do
    f.()
    loop(n-1, f)
  end


end
