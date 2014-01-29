## Desperados: Wanted Dead or Alive parser

This project contains a simple parser for a very limited subset of the game *Desperados: Wanted Dead or Alive* files. It is written in Ruby and uses the BinData library.

At the moment the only feature is parsing of the *Profiles* file located in *\<install dir\>\Game\Data\Savegame\Profiles*. The parser was written for playing with the game resolution and this was the only feature needed. I don't expect to add any more features or updates whatsoever. However, you can always contact me and try your luck :-)

#### Usage
The **main.rb** file in the parser directory contains all code. Before running change the hardcoded string (ugh) in `File.open` to point to a Desperados profiles file. Then run it with `ruby main.rb`. Of course, remember to run `bundle install` first. The program will output the decoded data to stdout.

#### Notes
Only tested with the **Desperados v1.01**. May work with other Spellbound games (e.g Robin Hood) but I haven't tested it.
