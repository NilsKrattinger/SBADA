with text_io, p_vue_text, p_combinaisons, Ada.Characters.Handling;
use  text_io, p_vue_text, p_combinaisons, Ada.Characters.Handling, p_combinaisons.p_cases_io, p_combinaisons.p_int_io;

procedure gauditext is
  function getUserBool return boolean is
    entree: string(1..5);
    taille: integer range 1..5;
    resultat: boolean;
    correct: boolean := false;
  begin
    while not correct loop
      skip_line;
      get_line(entree, taille);
    if taille = 5 then skip_line; end if;
      if To_Lower(entree(1..taille)) in "oui" | "yes" | "o" | "y" | "1" | "vrai" | "true" then
        resultat := true;
        correct := true;
      elsif To_Lower(entree(1..taille)) in "non" | "no" | "n" | "0" | "faux" | "false" then
        resultat := false;
        correct := true;
      else
        put_line("Cette valeur est incorrecte, réessayez.");
      end if;
    end loop;

    return resultat;
  end getUserBool;

  f: p_cases_io.file_type;
  V: TV_Gaudi(1..16);

  nbelem: integer;
  fout: text_io.file_type;

  continue : boolean;
begin
  loop
    open(f, IN_FILE, "CarreGaudi");
    open(fout, IN_FILE, "fout.txt");

    CreeVectGaudi(f, V);
    triVectGaudi(V);

    put("Entrez le nombre d'éléments de la solution : ");
    get(nbelem);

    afficheGrille(V);
    afficheSolution(nbelem, fout);
    close(fout);
    close(f);

    new_line;
    put("Voulez-vous continuer ? ");
    continue := getUserBool;
    exit when not continue;
  end loop;
end gauditext;
