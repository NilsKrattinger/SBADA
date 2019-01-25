with GNAT.Sockets, p_status, Text_IO, p_common;
use  GNAT.Sockets, p_status, Text_IO, p_common;

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

  procedure traiterMessage(c: in stream_access; m: in string) is
  -- {} => {Handles a message received by the server}
    code : integer;
  begin
    code := statutMessage(m);
    case code is
      when AUTHENTIFICATION_NEEDED => authentification(c);
      when AUTHENTIFICATION_REUSSIE => put_line("Connexion réussie !");
      when PSEUDO_INCORRECT =>
        put_line("Le pseudo est déjà utilisé, ou vide.");
        authentification(c);
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
