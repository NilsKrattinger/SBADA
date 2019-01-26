with GNAT.Sockets, Ada.Exceptions, Ada.Strings, Ada.Strings.Fixed, p_status, Text_IO, p_common, p_vue_graph, p_jeu, p_fenbase;
use  GNAT.Sockets, Ada.Exceptions, Ada.Strings, Ada.Strings.Fixed, p_status, Text_IO, p_common, p_vue_graph, p_jeu, p_fenbase;

package body p_client is

  task body T_Listen is
    channel: stream_access;
  begin
    loop
      if not est_connecte then
        select
          accept start(c: in stream_access) do
            channel := c;
          end start;
        or
          terminate;
        end select;
      else
        while est_connecte loop
          declare
            message : string := String'input (channel);
          begin
            if message'length > 0 then
              traiterMessage(channel, message);
            end if;
          end;
        end loop;
      end if;
    end loop;
  end T_Listen;

  procedure initialiserSocket is
  -- {} => {Un socket de connexion a été créé}
  begin
    --create_socket (socket);
    --set_socket_option (socket, SOCKET_LEVEL, (REUSE_ADDRESS, true));
    null;
  end initialiserSocket;

  function connexion(addr: in string; port: in integer) return boolean is
  -- {} => {résultat = vrai si le client se connecte au serveur}
  begin
    address.addr := inet_addr(addr);
    address.port := Port_Type(port);

    create_socket (socket);
    set_socket_option (socket, SOCKET_LEVEL, (REUSE_ADDRESS, true));

    connect_socket (socket, address);

    channel := stream (socket);
    est_connecte := true;
    listen.start(channel);

    return true;

    exception
      when E : others =>
        put_line(exception_name (E) & ": " & exception_message (E));
        return false;
  end connexion;

  procedure deconnexion is
  -- {} => {Le client se déconnecte du serveur}
  begin
    est_connecte := false;
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
        effacerGrille(fenetreDeJeu);
        actualisationEssai(fenetreDeJeu, msg(2..tailleMsg), Integer'value(msg(1..1)));
      when ACTUALISATION_SCORE =>
        decoderMessage(m, code, msg, tailleMsg);
        changerTexte(fenetreDeJeu, "Score", trim(msg(1..tailleMsg), BOTH) &
                (if Integer'value(msg(1..tailleMsg)) >= 2 then " Points" else " Point"));
      when DEBUT_JEU =>
        decoderMessage(m, code, msg, tailleMsg);

        while not jeuOuvert loop
          delay 0.1;
        end loop;

        chrono.start(Duration'value(msg(1..tailleMsg)));
        jeuEnCours := true;
        chronoJeu.start(fenetreDeJeu);
        tailleSolution := 0;
      when FIN_JEU =>
        jeuEnCours := false;
        cacherElem(fenetreDeJeu, "valider");
        cacherElem(fenetreDeJeu, "abandon");
        montrerElem(fenetreDeJeu, "finjeu");
        deconnexion;
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
