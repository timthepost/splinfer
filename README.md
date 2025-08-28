# Splinfer - A Flexible Inference Layer With Advanced Capabilities

Splinfer is based on [llama.cpp][1], and aims to bring "Big AI" features
to local, privacy-respecting, self-hosted experiences in a safe and 
accessible way.

Splinfer is built around the idea of keeping multiple models "hot" while 
managing persona and user mapped context regions to support multiple
concurrent and independent conversations.

Built on top of [the splinter bus architecture][2], Splinfer doesn't use 
sockets natively - all communication (including model thinking) is done in
a lock-free, thread-safe memory-mapped region that can be subscribed to.

Changing context, then, even over persistent network storage, becomes a 
matter of moving pointers around. This also enables Splinfer to provide 
hooks for workers to dispatch and do things on its behalf like:

 - Short term memory (KV style, for remembering user preferences and session
   data)
 - Plays extremely well with [Tieto][3] for long-term memory, current events
   and RAG.
 - Web searches (most likely facilitated by Deno workers)
 - Accessing local hardware in limited settings (runs in a VM or chroot)
 - Writing, building, running and even limited debugging of code
 - GPIO interaction through linked libraries / FFI

If the model can be taught to reliably emit certain token sequences in
order to cause things to happen (via system prompts), Splinfer can be 
made to provide backing for it.

If socket access to completion (e.g. OpenAI style) or MCP is desired, you
can use the [Libsplinter Deno FFI bindings][4] and an Oak front-end.

## Current Status And Focus (What's Going On?)

For the most part, it's still llama-cli. That is very quickly going to 
change.

I'm in the process of converting  ***all*** I/O, including debugging, over 
to Splinter writes. There's also a lot of wrangling around how memory and 
threads are ultimately going to be managed.

The base [libsplinter wire protocol][5] is the starting point for handoff,
and should be sufficient for what's needed, but everything is going to need
to start speaking it.

Streaming will just emit token sequences as JSONL for pub/sub (will be easy
to toggle between streams and chunks).

Most options are vanishing and moving to a configuration format (most likely
JSON in Splinter) - we're keeping most innards.

Improved support for [RWKV][6] is eminently planned (Splinter is ideal 
for this as state vector updates can also become subscriptions, and instantaneous
switching between conversations by orchestrating address resolution).

Because [Runa][7] (what Splinfer is designed to support) is going to support 
[dynamic personality mapping and adjusting][8], being able to atomically switch
to new token selection algorithms or parameters is essential, and splinter 
does this natively.

Finally, I ***just might*** move tokenization to the bus (model gets clean tokens
based on its trained vocab right from splinter). I'm not positively sold on it yet but
it lets *just* tokenization run as a service with higher priority than most things. Still
kicking the idea around (perf impact would be negligible since it's shared memory).

## Client Will Be Included, But Isn't Yet.

A client that connects to the bus and lets you have a conversation (similar to llama-cli)
will be included soon. Right now, once I finish ripping out console IO, that's just not 
possible unless you manually manipulate the bus.

## Breaks Often

It may build right now. But won't for the next three weeks. And it may also just
spiral up and lock up your terminal. Until I tag in an actual release, treat this as 
radioactive goop. 

## Building 

See the Makefile. I don't want to create an illusion of safety by offering a convenient polished build script that makes it easy to deploy something that's probably going to be unstable, so that's the best it's going to get for now. Note that you'll need libllama, libggml, libggml-base from llama.cpp (you need to build and install them separately). 

If you use it, you know what you're doing (and probably what I'm doing, too!)


  [1]: https://github.com/ggml-org/llama.cpp
  [2]: https://github.com/timthepost/libsplinter/blob/main/docs/README.md
  [3]: https://github.com/timthepost/tieto
  [4]: https://github.com/timthepost/libsplinter/blob/main/bindings/ts/splinter_deno_ffi.ts
  [5]: https://github.com/timthepost/libsplinter/blob/main/docs/base-protocol.md
  [6]: https://www.rwkv.com/
  [7]: https://github.com/timthepost/runa
  [8]: https://github.com/timthepost/runa/blob/main/docs/personality_mapping.md
