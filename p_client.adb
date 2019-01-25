with GNAT.Sockets, Ada.Strings, Ada.Strings.Fixed, p_status, Text_IO, p_common, p_vue_graph, p_jeu;
use  GNAT.Sockets, Ada.Strings, Ada.Strings.Fixed, p_status, Text_IO, p_common, p_vue_graph, p_jeu;

package body p_client is

  task body T_Listen is
    channel: stream_access;
  begin
    accept start(c: in stream_access) do
      channel := c;
    end start;

    loop
      declare
        message : string := String'input (channel);
      begin
        put_line(message);
        traiterMessage(channel, message);
      end;
    end loop;
  end T_Listen;

  function connexion(addr: in string; port: in integer) return boolean is
  -- {} => {résultat = vrai si le client se connecte au serveur}
  begin
    address.addr := inet_addr(addr);
    address.port := Port_Type(port);

    create_socket (socket);
    set_socket_option (socket, socket_Level, (reuse_address, true));

    connect_socket (socket, address);

    channel := stream (socket);
    listen.start(channel);

    return true;

    exception
      when E : others =>
        put_Line(exception_name (E) & ": " & exception_message (E));
        return false;
  end connexion;

  procedure deconnexion is
  -- {} => {Le client se déconnecte du serveur}
  begin
    close_socket (socket);
  end deconnexion;

  procedure traiterMessage(c: in stream_access; m: in string) is
  -- {} => {Gère un message reçu par le serveur}
    code : integer;
    msg : string(1..15);
    tailleMsg : integer;
  begin
    code := statutMessage(m);
    case code is
      when AUTHENTIFICATION_NEEDED => envoyerMessage(c, creerMessageStatut(trim(pseudoClient, BOTH), SEND_NAME));
      when AUTHENTIFICATION_REUSSIE => put_line("Connexion réussie !");
      when PSEUDO_INCORRECT =>
        put_line("Le pseudo est déjà utilisé, ou vide.");
        authentification(c);
      when SOLUTION_RESULTAT =>
        decoderMessage(m, code, msg, tailleMsg);
        actualisationEssai(fenetreJeu, msg(2..tailleMsg), Integer'value(msg(1..1)));
      when ACTUALISATION_SCORE =>
        decoderMessage(m, code, msg, tailleMsg);
        changerTexte(fenetreJeu, "Score", trim(Integer'image(msg(1..tailleMsg)), BOTH) &
                (if Integer'value(msg(1..tailleMsg)) >= 2 then " Points" else " Point"));
      when FIN_JEU =>
        chronoJeu.stop;
        chrono.stop;
        cacherElem(fenetreJeu, "valider");
        changerEtatBouton(fenetreJeu, "valider", ARRET);
        cacherElem(fenetreJeu, "abandon");
        changerEtatBouton(fenetreJeu, "abandon", ARRET);
        montrerElem(fenetreJeu, "finjeu");
        changerEtatBouton(fenetreJeu, "finjeu", MARCHE);
      when others => null;
    end case;

  end traiterMessage;

  procedure authentification(c: in stream_access) is
  -- {} => {Authentifie le joueur}
    pseudo : string(1..NAME_SIZE);
    nb: integer;
  begin
    put("Entrez votre pseudo : ");
    get_line(pseudo, nb);
    envoyerMessage(c, creerMessageStatut(pseudo(1..nb), SEND_NAME));
  end authentification;

end p_client;
