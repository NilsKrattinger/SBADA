with GNAT.Sockets, Text_IO, Ada.Exceptions, Ada.Strings, Ada.Strings.Fixed, Ada.Characters.Handling, p_status, p_common, p_jeu, p_server;
use  GNAT.Sockets, Text_IO, Ada.Exceptions, Ada.Strings, Ada.Strings.Fixed, Ada.Characters.Handling, p_status, p_common, p_jeu;

procedure server is
  function getUserBool return boolean is
    entree: string(1..5);
    taille: integer range 1..5;
    resultat: boolean;
    correct: boolean := false;
  begin
    while not correct loop
      get_line(entree, taille);
      if taille = 5 then skip_line; end if;
      if to_lower(entree(1..taille)) in "oui" | "yes" | "o" | "y" | "1" | "vrai" | "true" then
        resultat := true;
        correct := true;
      elsif to_lower(entree(1..taille)) in "non" | "no" | "n" | "0" | "faux" | "false" then
        resultat := false;
        correct := true;
      else
        put_line("Cette valeur est incorrecte, réessayez.");
      end if;
    end loop;

    return resultat;
  end getUserBool;

  package p_pos_io is new integer_io(positive); use p_pos_io;

  address  : sock_addr_type;
  server   : socket_type;

  nbJoueurs : positive;

  contigu : boolean;
  temps : positive;
begin
  Initialize (Process_Blocking_IO => False);
  address.addr := addresses (get_host_by_name (HOST_NAME), 1); -- Get 1st address of host
  address.port := 5432;

  put("Entrez le nombre de joueurs : "); get(nbJoueurs); skip_line;
  put("Entrez la durée de la partie, en secondes : "); get(temps); skip_line;
  put("Faut-il se limiter aux solutions contigües ? (o/n) "); contigu := getUserBool;

  put_line("Start listening on address " & image(address.addr) & " and port" & Port_Type'image(address.port));

  declare
    package p_serverJoueurs is new p_server(nbJoueurs); use p_serverJoueurs;
  begin
    create_socket (server);
    set_socket_option (server, SOCKET_LEVEL, (reuse_address, true));

    bind_socket (server, address);

    listen_socket (server); -- Start listening to connect events

    for i in joueurs'range loop
      accept_socket (server, joueurs(i).socket, address); -- Incoming connect events are being accepted
      joueurs(i).channel := stream (joueurs(i).socket);

      joueurs(i).listen.start(joueurs(i).channel, i);
      envoyerMessage(joueurs(i).channel, creerMessageStatut("", AUTHENTIFICATION_NEEDED));

      joueurs(i).name := (others => ' ');
      while joueurs(i).name = EMPTY_NAME loop
        delay 0.5;
      end loop;
    end loop;

    coteServeur := true;
    envoyerMessageGlobal(DEBUT_JEU, trim(Integer'image(temps), BOTH));
    debutJeu(contigu, duration(temps));

    while jeuEnCours loop
      delay 0.5;
    end loop;

    envoyerMessageGlobal(FIN_JEU, "");

    for i in joueurs'range loop
      close_socket (joueurs(i).socket);
    end loop;

    close_socket (server);
  end;

exception
  when E : others => put_line(exception_name (E) & ": " & exception_message (E));
end server;
