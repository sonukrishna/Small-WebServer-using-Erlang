%% simple web server in erlang , prints hello world

-module(web_server).
-compile(export_all).

start(Port) ->
    spawn(web_server, listen, [Port]).

listen(Port) ->
    {ok, Socket} = gen_tcp:listen(Port, [{active, false}]),
    loop(Socket).

loop(Socket) ->
    {ok, Conn} = gen_tcp:accept(Socket),
    Handle = spawn(web_server, handle, [Conn]),
    gen_tcp:controlling_process(Conn, Handle),
    loop(Socket).

handle(Conn) ->
    Response = response("Hello, World!"),
    gen_tcp:send(Conn, Response),
    gen_tcp:close(Conn).

response(Str) ->
    B = iolist_to_binary(Str),
    iolist_to_binary(io_lib:fwrite("HTTP/1.0.200 OK\nContent-Type: text/html\nContent-Length: ~p\n\n~s",[size(B), B])).
