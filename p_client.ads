with GNAT.Sockets ;
use  GNAT.Sockets ;

package p_client is
  task type T_Listen is
    entry start(c: in stream_access);
  end T_Listen;

  procedure traiterMessage(c: in stream_access; m: in string);
  -- {} => {Handles a message received by the server}

  procedure authentification(c: in stream_access);
  -- {} => {Authentifie le joueur}
end p_client;
