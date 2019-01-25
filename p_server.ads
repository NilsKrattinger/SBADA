with GNAT.Sockets, Text_IO, Ada.Exceptions, p_common;
use  GNAT.Sockets, Text_IO, Ada.Exceptions, p_common;

generic
  nbPlayers : integer;
package p_server is

  task type T_Listen is
    entry start(c: in stream_access; pid: in integer);
  end T_Listen;

  type TR_Player is record
    name     : string(1..NAME_SIZE) := EMPTY_NAME;
    nameLen  : positive range 1..NAME_SIZE := NAME_SIZE;

    socket   : socket_type;
    channel  : stream_access;

    listen   : T_Listen;
  end record;

  type TV_Players is array(1..nbPlayers) of TR_Player;
  players : TV_Players;

  procedure handleMessage(c: in stream_access; m: in string; pid: in integer);
  -- {} => {Gère un message reçu par le serveur}

  function verificationPseudo(pid: in integer) return boolean;
  -- {} => {Vérifie que le joueur à l'id pid a un pseudo correct}

end p_server;
