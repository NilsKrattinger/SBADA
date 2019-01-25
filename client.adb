with GNAT.Sockets, Text_IO, Ada.Exceptions, p_status, p_client;
use  GNAT.Sockets, Text_IO, Ada.Exceptions, p_status, p_client;

procedure client is
  package p_port_io is new integer_io(Port_Type); use p_port_io;

  address   : sock_addr_type;
  socket    : socket_type;
  channel   : stream_access;

  addrIn    : string(1..15);
  addrSize  : integer;

  listen    : T_Listen;
begin
  put("Entrez l'adresse du serveur : ");
  get_line(addrIn, addrSize);
  address.addr := inet_addr(addrIn(1..addrSize));

  put("Entrez le port du serveur : ");
  get(address.port);
  skip_line;

  create_socket (socket);

  set_socket_option (socket, socket_Level, (reuse_address, true));

  delay 0.2;

  --  If the client's socket is not bound, Connect_socket will
  --  bind to an unused address. The client uses Connect_socket to
  --  create a logical connection between the client's socket and
  --  a server's socket returned by Accept_socket.

  connect_socket (socket, address);

  channel := stream (socket);
  listen.start(channel);

  delay 20.0;

  --  Receive and print message from server Pong.
  close_socket (socket);

exception
  when E : others => put_Line(exception_name (E) & ": " & exception_message (E));

end client;
