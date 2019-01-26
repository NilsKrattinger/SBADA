with GNAT.Sockets, Text_IO, Ada.Exceptions, p_common;
use  GNAT.Sockets, Text_IO, Ada.Exceptions, p_common;

generic
  nbJoueurs : integer;
package p_server is

  task type T_Listen is
    entry start(c: in stream_access; pid: in integer);
  end T_Listen;

  type TR_Joueur is record
    name     : string(1..NAME_SIZE) := EMPTY_NAME;
    nameLen  : positive range 1..NAME_SIZE := NAME_SIZE;

    socket   : socket_type;
    channel  : stream_access;

    listen   : T_Listen;
    connecte : boolean := true;
  end record;

  type TV_Joueurs is array(1..nbJoueurs) of TR_Joueur;
  joueurs : TV_Joueurs;

  procedure traiterMessage(c: in stream_access; m: in string; pid: in integer);
  -- {} => {Gère un message reçu par le serveur}

  function verificationPseudo(pid: in integer; pseudo : in string) return boolean;
  -- {} => {Vérifie que le joueur à l'id pid a un pseudo correct}

  procedure envoyerMessageGlobal(code: in integer; m: in string);
  -- {} => {Le message m a été envoyé à tous les joueurs connectés}

end p_server;
