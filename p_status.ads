package p_status is

  ERROR_DECODING:           constant integer := -1;
  AUTHENTIFICATION_NEEDED:  constant integer := 0;
  AUTHENTIFICATION_REUSSIE: constant integer := 1;
  SEND_NAME:                constant integer := 2;
  PSEUDO_INCORRECT:         constant integer := 3;

  function getStatusMessage(msg: in string; statut: in integer) return string;
  -- {msg est le message à envoyer, statut le code représentant un statut}
  -- => {résultat=le message résultant de la concaténation du code et du message}

  function getStatusNumber(msg: in string) return integer;
  -- {msg est le message concaténé reçu} => {résultat=le code de statut correspondant}

  function getMessage(msg: in string) return string;
  -- {msg est le message concaténé reçu} => {résultat=le message après le code de statut}

  procedure decode(msg: in string; code: out integer; msgOut: out string; msgSize: out integer);
  -- {msg est le message concaténé reçu} =>
  --   {code est le code de statut correspondant et msgOut le message reçu}

end p_status;
