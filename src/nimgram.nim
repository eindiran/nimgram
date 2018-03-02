## nimgram.nim
## A simple and fast ngram counter written in Nim.

import tables
import strutils

proc read_vocab*(vocab_file: string): Table[string, int] =
    ## Generate a vocab table using the vocabulary file as input.
    var vocab_table: Table[string, int] = initTable[string, int]()
    for line in lines vocab_file:
        var word: string = line.rsplit("\t")[0]
        if hasKey(vocab_table, word): # Emulate a defaultdict
            vocab_table[word] += 1
        else:
            vocab_table[word] = 1
    return vocab_table


proc print_kv_pairs*(input_table: Table[string, int]): void =
    ## Debugging function, used to print the key-value pairs in a table.
    var i: int = 0
    for key in keys[string](input_table):
        var val: int = input_table[key]
        echo("Index: ", i, "\tKey: ", key, "\n\t\tValue: ", val, "\n")
        inc(i)


proc print_seq_info*(input_seq: seq[string]): void =
    ## Debugging function, used to print info about a seq.
    echo("Seq is " & $input_seq.len & " elements long.")
    for i in input_seq:
        echo(i)


proc get_seq_slice*(lower_bound: int, upper_bound: int, s: seq[string]): seq[string] =
    ## Take as input two seq indices and a seq and return a slice.
    var return_slice: seq[string] = newSeq[string]()
    # This should work like the Python: seq[lower_bound:upper_bound]
    for i in lower_bound..upper_bound-1:
        try:
            return_slice.add(s[i])
        except IndexError:
            break
    return return_slice


proc generate_ngrams*(n: int, tokens: seq[string]): seq[string] =
    ## Generate the list of ngrams from the tokens.
    var tokens_mut: seq[string] = tokens # Get a mutable copy
    var ngram_list: seq[string] = newSeq[string]() # New seq for output
    for i in 1..n-1:
        tokens_mut.insert("<s>", 0) # Add sentence start tokens
        tokens_mut.add("</s>") # Add sentence end tokens
    var num_tokens: int = tokens_mut.len
    for i in 0..num_tokens-1:
        var low_bound: int = i + n
        var high_bound: int = min(low_bound, num_tokens) + 1
        for j in low_bound..high_bound-1:
            var tokens_slice: seq[string] = get_seq_slice(i, j, tokens_mut)
            let current_ngram: string = join(tokens_slice, sep=" ")
            ngram_list.add(current_ngram)
    return ngram_list


proc write_ngram_counts*(filename: string, ngram_counts: Table[string, int]): void =
    ## Write an ngram count Table to file.
    var out_file = open(filename, fmWrite)
    for ngram in keys(ngram_counts):
        var count: int = ngram_counts[ngram]
        out_file.write(ngram & "\t" & $count & "\n")
    out_file.close()


proc tokenize_str(input_str: string): seq[string] =
    ## Converts a string into a seq[string], by splitting on whitespace.
    var tokens: seq[string] = newSeq[string]()
    for token in split(input_str):
        tokens.add(token)
    return tokens


proc process_file*(filename: string, n: int): Table[string, int] =
    ## Takes a file an returns an ngram count table.
    var ngram_counts: Table[string, int] = initTable[string, int]()
    for line in lines filename:
        var
            count: int
            tokens: seq[string] = tokenize_str(line)
            ngram_list: seq[string] = generate_ngrams(n, tokens)
        for ngram in ngram_list:
            if hasKey(ngram_counts, ngram):
                count = ngram_counts[ngram] + 1
            else:
                count = 1
            `[]=`(ngram_counts, ngram, count)
    return ngram_counts


proc handle_args(): void =
    ## Handle the args passed in on the commandline.
    # TODO: Write this functionality, adding optparse to nimble
    echo("No argument handling capabilities yet!")


when isMainModule:
    proc main =
        ## Main function
        handle_args()
        let input_filename: string = "input_file.txt"
        # read in input_filename
        var ngram_counts: Table[string, int] = process_file(input_filename, 2)
        write_ngram_counts("output_filename.txt", ngram_counts)
    main()
