with GNAT.Sockets ;
use  GNAT.Sockets ;

package p_common is
  NAME_SIZE : constant positive := 20;
  EMPTY_NAME : constant string(1..NAME_SIZE) := (others => ' ');

  procedure sendMessage(c: in stream_access; m: in string);
  -- {} => {Envoie un message m à travers c}
end p_common;
