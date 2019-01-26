with Ada.Exceptions, Text_IO;
use  Ada.Exceptions, Text_IO;

package body p_common is
  procedure envoyerMessage(c: in stream_access; m: in string) is
  -- {} => {Envoie un message m à travers c}
  begin
    if envoyerMessage(c, m) then null; end if;
  end envoyerMessage;

  function envoyerMessage(c: in stream_access; m: in string) return boolean is
  -- {} => {résultat = true si le message a été envoyé à travers c}
  begin
    String'output (c, m);
    return true;
  exception
    when E : others =>
      put_line("Une erreur " & exception_name(E) & " est survenue lors de l'envoi du message.");
      return false;
  end envoyerMessage;
end p_common;
