with GNAT.Sockets, p_fenbase;
use  GNAT.Sockets, p_fenbase;

package p_client is
  task type T_Listen is
    entry start(c: in stream_access);
  end T_Listen;

  address      : sock_addr_type;
  socket       : socket_type;
  channel      : stream_access;
  est_connecte : boolean := false;

  listen : T_Listen;

  pseudoClient : string(1..20);

  fenetreDeJeu: TR_Fenetre;
  jeuOuvert: boolean := false;

  procedure initialiserSocket;
  -- {} => {Un socket de connexion a été créé}

  function connexion(addr: in string; port: in integer) return boolean;
  -- {} => {résultat = vrai si le client se connecte au serveur}

  procedure deconnexion;
  -- {} => {Le client se déconnecte du serveur}

  procedure traiterMessage(c: in stream_access; m: in string);
  -- {} => {Gère un message reçu par le serveur}

  procedure authentification(c: in stream_access);
  -- {} => {Authentifie le joueur}
end p_client;
