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
  exec "nim c -r tests/test_nimgram"
