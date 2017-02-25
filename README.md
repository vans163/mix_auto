# mix_auto
Recompiles elixir code when it changes inside lib/

## Supported OS
Due to mix_auto not relying on polling each os needs to implement their fs events. Currently I only implemented inotify for linux. 

  - Linux

## Known problems
Using recompile/0 crashes running modules constantly like gen_statem.  
https://github.com/elixir-lang/elixir/issues/5809

Now mix_auto uses r/1 instead of recompile/0 and this seems to work. There may be issues.
