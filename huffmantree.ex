defmodule Huffmantree do

  # start function
  def freq(sample) do
    freq(sample, [])
  end

  # we have gone through our chars and we return freq list
  defp freq([], freq) do
    freq
  end

  # we take in a charlist with current freq
  defp freq([char | rest], freq) do

    # we take the current char and convert into an atom
    charAtom = List.to_atom([char])

    # check if the char exists already in freq
    newFreq = case List.keyfind(freq, charAtom, 0) do
      # the char is the list we know we need to update the frequency
      {^charAtom, _} ->
        # we go through the list from the left and take each element
        List.foldl(freq, [], fn({c, f}, acc) ->
          # check is the atomvalue from the element we got is the same as what we are looking for
          case charAtom == c do
              # same atom we return same atom but increase freq
              true -> [{c, f+1} | acc]
              # not same we don't the element and we just return the element to accumualtor
              _ -> [{c,f} | acc]
            end
        end)

      # the char is not in the list
      _ ->
        #IO.puts("char don't exists")
        # we append into the freqlist with start frequency of 1
        [{charAtom, 1} | freq]

    end
    freq(rest, newFreq)
  end


  #Hufman

  # Represenation
  # leaf node: {char}
  # branch node: {value, left, right}

  def huffman(freq) do
      huffman(freq, [], [])
  end

  def huffman([], _, acc) when length(acc) == 1 do
    acc
  end

  def huffman([], _, acc) do
    #IO.puts("empty huffman")
    mergeTrees(Enum.reverse(acc), [])
    #mergeTrees(acc, [])

  end
  def huffman([freq], _, acc) do
    #IO.inspect(freq, label: "freq single")
    #IO.inspect(acc, label: "acc huffman single")
    #{_, freqVal} = freq
    # set min to the most upper tree in acc
    [{_,min}] = Enum.take(acc, 1)
    min = List.foldl(acc, min, fn({_, val}, acc) ->
      #IO.inspect(val, label: "val foldl")
      case val < min do
        true -> val
        _ -> min
      end
    end)

    newAcc = List.foldl(acc, [], fn({_, val} = tree, acc) ->
      case val == min do
        true ->
          [createBranch([freq], tree) | acc]
        _ -> [tree | acc]
      end
    end)

    # because we only had one element in freq we know need to merge acc in the way it's currently
    #Enum.reverse(acc)
    #acc
    mergeTrees(Enum.reverse(newAcc), [])
    #mergeTrees(newAcc, [])
  end

  def huffman(freq, tree, acc) do
    # sort frequency by frequency value in ascending order
    freq = Enum.sort(freq, fn({_, fc1}, {_, fc2}) -> fc1 <= fc2 end)

    #IO.inspect(freq, label: "freq hufmann generalt")

    {freq, tree} = startSubTree(freq, tree)

    #IO.inspect({freq, tree}, label: "subtree")
    #IO.inspect(acc, label: "acc")

    huffman(freq, [], [tree | acc])
  end

  def startSubTree(freq, _) do
    # take two lowest elements
    elements = Enum.take(freq, 2)
    #IO.inspect(elements, label: "two lowest elements in startSubTree")

    # remove the two lowest elements from the list
    freq = Enum.drop(freq, 2)
    #IO.inspect(freq, label: "freq in startSubTree")

    node = createBranch(elements)

    #IO.inspect(node, label: "node")

    {freq, subTree} = createSubTree(freq, node)
    {freq, subTree}
  end


  def createSubTree([], branch), do: {[], branch}

  def createSubTree(freq, branch) do
    # take lowest element
    lowestelement = Enum.take(freq, 1)

    #IO.inspect(addNode?(lowestelement, branch), label: "add node: ")
    #IO.inspect(lowestelement, label: "lowest: ")
    #IO.inspect(branch, label: "branch: ")

    case addNode?(lowestelement, branch) do
      true ->
        # drop the element we have
        #IO.puts("addNode YES")
        freq = Enum.drop(freq, 1)
        branch = createBranch(lowestelement, branch)
        createSubTree(freq, branch)
      false ->
        #IO.puts("NO!")
        {freq, branch}
    end
  end

  def createBranch([{c1, fc1} | [{c2, fc2}]]) do
    {{c1, c2}, fc1 + fc2}
  end

  #def createBranch([{c1, val}], {_, nodeVal} = node), do: {{node, c1}, nodeVal + val}
  def createBranch([{c1, val}], {_, nodeVal} = node), do: {{c1, node}, nodeVal + val}


  def addNode?([{_, lowVal}], {_, val}), do: lowVal >= val

  # tree2 > tree1
  def mergeTwoTrees({_, vt1} = tree1, {_, vt2} = tree2), do: {vt2 + vt1, tree2, tree1}

  def mergeTwoTrees({vt1, _, _} = tree1, {_, vt2} = tree2), do: {vt2 + vt1, tree2, tree1}

  #def mergeTwoTrees({_, vt1} = tree1, {_, vt2} = tree2), do: {vt2 + vt1, tree1, tree2}

  def mergeTrees(listOfTrees, _) when length(listOfTrees) == 1 do Enum.reverse(listOfTrees) end

  def mergeTrees(listOfTrees, acc) do
    [tree1, tree2] = Enum.take(listOfTrees, 2)

    merge = mergeTwoTrees(tree1, tree2)
    #IO.inspect(listOfTrees, label: "before drop")

    listOfTrees = Enum.drop(listOfTrees ,2)

    #IO.inspect(listOfTrees, label: "after drop")
    listOfTrees = [merge | listOfTrees]

    #IO.inspect(listOfTrees, label: "after adding merge")

    mergeTrees(listOfTrees, acc)


  end




end
