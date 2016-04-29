# vim-sessions

Vim plugin to help manage vim sessions. You can save sessions using `:SessionSave {name}` and restore sessions using `:SessionRestore {name}`. Mappings exist for all letters similar to registers. Save a session with `<Leader>ss{key}` and restore a session with `<Leader>sr{key}`. There is also a jumplist that saves recent sessions you have used. A new jump is added when you save or restore a session. You can jump backwards with `:SessionTravel` or `<Leader>so`. 

## Examples

* `<Leader>ssh` save session `h`.
* `<Leader>srh` restore session `h`.
* `:SessionSave mySession` save session `mySession`.
* `:SessionRestore mySession` restore session `mySession`.
* `<Leader>so` jump back in session history.

## Notes

The sessions are stored in `vim-plugin-folder/vim-sessions/sessions`. To manually restore a session you run `:source {path-to-session-file}` in `Vim`. You can also start `Vim` with a session from the command line: `vim -S {path-to-session-file}`.
