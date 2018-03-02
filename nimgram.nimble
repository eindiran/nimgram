# Package

version       = "0.1.0"
author        = "Elliott Indiran"
description   = "A simple and fast ngram counter written in Nim."
license       = "MIT"
srcDir        = "src"
bin           = @["nimgram"]
binDir        = "bin"

# Dependencies

requires "nim >= 0.17.2"

# Tasks

task test, "Runs the test suite":
  exec "nim c -r test/test_nimgram"

task clean, "Cleans up the directory":
  exec "rm -rf src/nimcache"
  exec "rm -rf test/nimcache"
  exec "rm -f test/test_nimgram"
  exec "rm -f bin/nimgram"
  exec "rm -f ngram_counts.*grams"
