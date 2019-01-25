with GNAT.Sockets, Text_IO, Ada.Exceptions, p_status, p_common, p_server;
use  GNAT.Sockets, Text_IO, Ada.Exceptions, p_status, p_common;

procedure server is
  package p_pos_io is new integer_io(positive); use p_pos_io;

  address  : sock_addr_type;
  server   : socket_type;

  nbPlayers : positive;
begin
  Initialize (Process_Blocking_IO => False);
  address.addr := addresses (get_host_by_name (HOST_NAME), 1); -- Get 1st address of host
  address.port := 5432;

  put("Entrez le nombre de joueurs : "); get(nbPlayers);
  put_line("Start listening on address " & image(address.addr) & " and port" & Port_Type'image(address.port));

  declare
    package p_serverPlayers is new p_server(nbPlayers); use p_serverPlayers;
  begin
    create_socket (server);
    set_socket_option (server, SOCKET_LEVEL, (reuse_address, true));

    bind_socket (server, address);

    listen_socket (server); -- Start listening to connect events
    for i in players'range loop

      accept_socket (server, players(i).socket, address); -- Incoming connect events are being accepted
      players(i).channel := stream (players(i).socket);

      players(i).listen.start(players(i).channel, i);
      sendMessage(players(i).channel, getStatusMessage("", AUTHENTIFICATION_NEEDED));

      players(i).name := (others => ' ');
      while players(i).name = EMPTY_NAME loop
        delay 0.5;
      end loop;
    end loop;

    for i in players'range loop
      sendMessage(players(i).channel, "TestBB");
      close_socket (players(i).socket);
    end loop;

    close_socket (server);
  end;

exception
  when E : others => put_line(exception_name (E) & ": " & exception_message (E));
end server;
