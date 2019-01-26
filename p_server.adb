with GNAT.Sockets, Text_IO, Ada.Exceptions, Ada.Strings, Ada.Strings.Fixed, p_status, p_common, p_jeu;
use  GNAT.Sockets, Text_IO, Ada.Exceptions, Ada.Strings, Ada.Strings.Fixed, p_status, p_common, p_jeu;

package body p_server is

  task body T_Listen is
    channel: stream_access;
    playerId: integer;
  begin
    accept start(c: in stream_access; pid: in integer) do
      channel := c;
      playerId := pid;
    end start;

    loop
      declare
        message : string := String'input (channel);
      begin
        traiterMessage(channel, message, playerId);
      end;
    end loop;
  end T_Listen;

  procedure traiterMessage(c: in stream_access; m: in string; pid: in integer) is
  -- {} => {Gère un message reçu par le serveur}
    code : integer;

    pseudo : string(1..20);
    taillePseudo : integer;

    solution : string(1..14);
    tailleSolution : integer;
    resultatSolution : integer;
  begin
    code := statutMessage(m);
    case code is
      when SEND_NAME =>
        decoderMessage(m, code, pseudo, taillePseudo);
        if verificationPseudo(pid, pseudo) then
          joueurs(pid).name := pseudo;
          joueurs(pid).nameLen := taillePseudo;
          put_line("Le joueur " & joueurs(pid).name(1..joueurs(pid).nameLen) & " vient de se connecter.");
          envoyerMessage(c, creerMessageStatut("", AUTHENTIFICATION_REUSSIE));
        else
          envoyerMessage(c, creerMessageStatut("", PSEUDO_INCORRECT));
        end if;
      when SOLUTION_ESSAI =>
        decoderMessage(m, code, solution, tailleSolution);
        if tailleSolution >= 6 then
          verifSol(solution(1..tailleSolution), resultatSolution);
        else
          resultatSolution := SOLUTION_INVALIDE;
        end if;
        envoyerMessage(c, creerMessageStatut(trim(Integer'image(resultatSolution) & solution(1..tailleSolution), BOTH), SOLUTION_RESULTAT));
        if resultatSolution = SOLUTION_CORRECTE then
          envoyerMessageGlobal(ACTUALISATION_SCORE, trim(Integer'image(compterPoints), BOTH));
        end if;
      when others => null;
    end case;

  end traiterMessage;

  function verificationPseudo(pid: in integer; pseudo: in string) return boolean is
  -- {} => {Vérifie que le joueur à l'id pid a un pseudo correct (non vide et pas de doublon)}
    i : integer := joueurs'first;
  begin
    if pseudo = EMPTY_NAME then return false; end if;
    while i = pid or else (i <= joueurs'last and then pseudo /= joueurs(i).name) loop
      i := i + 1;
    end loop;
    return i > joueurs'last;
  end verificationPseudo;

  procedure envoyerMessageGlobal(code: in integer; m: in string) is
  -- {} => {Le message m a été envoyé à tous les joueurs connectés}
  begin
    for i in joueurs'range loop
      if joueurs(i).connecte then
        if not envoyerMessage(joueurs(i).channel, creerMessageStatut(m, code)) then
          joueurs(i).connecte := false;
        end if;
      end if;
    end loop;
  end envoyerMessageGlobal;

end p_server;
