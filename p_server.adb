with GNAT.Sockets, Text_IO, Ada.Exceptions, p_status, p_common;
use  GNAT.Sockets, Text_IO, Ada.Exceptions, p_status, p_common;

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
        handleMessage(channel, message, playerId);
      end;
    end loop;
  end T_Listen;

  procedure handleMessage(c: in stream_access; m: in string; pid: in integer) is
  -- {} => {Gère un message reçu par le serveur}
    code : integer;
  begin
    code := getStatusNumber(m);
    case code is
      when SEND_NAME =>
        decode(m, code, players(pid).name, players(pid).nameLen);
        if verificationPseudo(pid) then
          put_line("Le joueur " & players(pid).name(1..players(pid).nameLen) & " vient de se connecter.");
          sendMessage(c, getStatusMessage("", AUTHENTIFICATION_REUSSIE));
        else
          sendMessage(c, getStatusMessage("", PSEUDO_INCORRECT));
        end if;
      when others => null;
    end case;

  end handleMessage;

  function verificationPseudo(pid: in integer) return boolean is
  -- {} => {Vérifie que le joueur à l'id pid a un pseudo correct (non vide et pas de doublon)}
    i : integer := players'first;
  begin
    if players(pid).name = EMPTY_NAME then return false; end if;
    while i = pid or (i <= players'last and then
            players(i).name(players(i).nameLen) /= players(pid).name(players(pid).nameLen)) loop
      i := i + 1;
    end loop;
    return i > players'last;
  end verificationPseudo;

end p_server;
