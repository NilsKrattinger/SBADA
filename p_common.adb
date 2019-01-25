package body p_common is
  procedure envoyerMessage(c: in stream_access; m: in string) is
  -- {} => {Envoie un message m à travers c}
  begin
    String'output (c, m);
  end envoyerMessage;
end p_common;
