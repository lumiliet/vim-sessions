# vim-sessions

_This is still in development and features are likely to change and stop working_

Vim plugin to help manage Vim sessions. You can save sessions using `:SessionSave {name}` and restore sessions using `:SessionRestore {name}`. Mappings exist for all letters similar to registers. Save a session with `<Leader>ss{key}` and restore a session with `<Leader>sr{key}`.

There is also a jumplist that saves recent sessions you have used. A new jump is added when you save or restore a session. You can jump backwards with `:SessionTravelJumpList` or `<Leader>so`. 

A session is saved each time you close Vim. These can be restored with `:SessionTravelExitHistory {number}` or `<Leader>sr{number}`. `{number}` is the position in the exit history. Position 1 represents the most recent entry.

## Examples

* `<Leader>ssn` save session `n`.
* `<Leader>srn` restore session `n`.
* `<Leader>so` jump back in session jumplist. Will restore session `n` if run in this order.
* `<Leader>sr1` jump back in session exit history. Will restore Vim to when it was last closed.
* `<Leader>sr3`  restore Vim to when it was closed three times ago.
* `:SessionSave mySession` save session `mySession`.
* `:SessionRestore mySession` restore session `mySession`.

## Notes

The sessions are stored in `vim-plugin-folder/vim-sessions/sessions`. To manually restore a session you run `:source {path-to-session-file}` in Vim. You can also start Vim with a session from the command line: `vim -S {path-to-session-file}`.
