## test_nimgram.nim
## Tests for the nimgram n-gram counter.

import nimgram
import tables
import strutils

proc test_build_vocab(): void =
    ## Demonstrate that we can read in a vocab file
    var vocab_table: Table[string, int] = read_vocab("test/input_file.txt")
    print_kv_pairs(vocab_table)


proc build_test_seq(): seq[string] =
    ## Generate a seq[string] for testing
    var result_seq = newSeq[string]()
    result_seq.add("Zero")
    result_seq.add("One")
    result_seq.add("Two")
    result_seq.add("Three")
    result_seq.add("Four")
    result_seq.add("Five")
    result_seq.add("Six")
    result_seq.add("Seven")
    return result_seq


proc test_unigrams(): void =
    ## Print out info for unigrams
    var test_seq = build_test_seq()
    var unigram_list = generate_ngrams(1, test_seq)
    print_seq_info(unigram_list)


proc test_bigrams(): void =
    ## Print out info for bigrams
    var test_seq = build_test_seq()
    var bigram_list = generate_ngrams(2, test_seq)
    print_seq_info(bigram_list)


proc test_trigrams(): void =
    ## Print out info for trigrams
    var test_seq = build_test_seq()
    var trigram_list = generate_ngrams(3, test_seq)
    print_seq_info(trigram_list)


proc test_4grams(): void =
    ## Print out info for 4-grams
    var test_seq = build_test_seq()
    var four_gram_list = generate_ngrams(4, test_seq)
    print_seq_info(four_gram_list)


proc test_ngrams(): void =
    ## Do unigrams to 4-grams for test_seq
    echo("Running unigrams:\n")
    test_unigrams()
    echo("\nRunning bigrams:\n")
    test_bigrams()
    echo("\nRunning trigrams:\n")
    test_trigrams()
    echo("\nRunning 4-grams:\n")
    test_4grams()
    echo("\nDone!")


proc test_seq_slice(): void =
    ## Test that get_seq_slice behaves as expected
    var test_seq = build_test_seq()
    var test_slice = get_seq_slice(2, 5, test_seq)
    print_seq_info(test_slice)


proc test_write_ngram_counts(): void =
    ## Test our output function
    var output_file: string = "ngram_counts.bigrams"
    var ngram_counts: Table[string, int] = {"<s> Zero": 3,
                                            "Zero One": 2,
                                            "One Two": 1,
                                            "Six Seven": 14}.toTable
    echo("Writing file...")
    write_ngram_counts(output_file, ngram_counts)
    echo("Done!")


when isMainModule:
    proc main =
        ## Main function
        let all_tests: bool = true
        if all_tests:
            test_write_ngram_counts()
            test_seq_slice()
            test_build_vocab()
        test_ngrams()
    main()
