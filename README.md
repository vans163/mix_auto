# mix_auto
Recompiles elixir code when it changes inside lib/
## Known problems
Using recompile/0 crashes modules when they have inflight messages.  
This makes recompiling fail if you have components like a gen_statem  
that has a state_timeout inflight.  
https://github.com/elixir-lang/elixir/issues/5809
