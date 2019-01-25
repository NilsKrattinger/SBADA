with GNAT.Sockets ;
use  GNAT.Sockets ;

package p_client is
  task type T_Listen is
    entry start(c: in stream_access);
  end T_Listen;

  address      : sock_addr_type;
  socket       : socket_type;
  channel      : stream_access;

  pseudoClient : string(1..20);

  function connexion(addr: in string; port: in integer) return boolean;
  -- {} => {résultat = vrai si le client se connecte au serveur}

  procedure deconnexion;
  -- {} => {Le client se déconnecte du serveur}

  procedure traiterMessage(c: in stream_access; m: in string);
  -- {} => {Gère un message reçu par le serveur}

  procedure authentification(c: in stream_access);
  -- {} => {Authentifie le joueur}
end p_client;
