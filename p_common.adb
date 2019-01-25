package body p_common is
  procedure sendMessage(c: in stream_access; m: in string) is
  -- {} => {Envoie un message m à travers c}
  begin
    String'output (c, m);
  end sendMessage;
end p_common;
