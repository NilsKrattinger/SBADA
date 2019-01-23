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

  procedure getAction(resultat: out character; nb: out integer) is
    entree: string(1..7);
    taille: integer range 1..7;
    correct: boolean := false;
  begin
    nb := 0;
    while not correct loop
      put_line("Que voulez-vous faire ?");
      put_line("  + : Solution suivante");
      put_line("  - : Solution précédente");
      put_line("  Entrez un nombre pour aller à la solution correspondante");
      put_line("  q : Quitter");
      get_line(entree, taille);
      if taille = 7 then skip_line; end if;
      if To_Lower(entree(1..taille)) in "+" | "suiv" | "suivant" | "next" then
        resultat := '+';
        correct := true;
      elsif To_Lower(entree(1..taille)) in "-" | "prec" | "pred" | "précédent" | "precedent" then
        resultat := '-';
        correct := true;
      elsif To_Lower(entree(1..taille)) in "q" | "quit" | "quitter" then
        resultat := 'q';
        correct := true;
      else
        begin
          nb := Integer'value(entree(1..taille));
          resultat := 'n';
          correct := true;
        exception
          when others =>
            put_line("Cette valeur est incorrecte, réessayez.");
        end;
      end if;
    end loop;
  end getAction;

  f: p_cases_io.file_type;
  V: TV_Gaudi(1..16);
  nbelem: integer range 3..7 := 3;
  fout: text_io.file_type;

  continue, contigu : boolean;

  nbSol, currSol: integer;
  action: character;
  newSol: integer;
begin
  fichiersInit(V);
  open(f, IN_FILE, "CarreGaudi");
  loop
    loop
      begin
        put("Entrez le nombre d'éléments de la solution : ");
        get(nbelem); skip_line;
        exit;
      exception
        when others =>
          put_line("Veuillez entrer un entier entre 3 et 7.");
          skip_line;
      end;
    end loop;

    put("Voulez-vous n'afficher que les solutions contigües ? (o/n) ");
    contigu := getUserBool;

    if contigu then
      open(fout, IN_FILE, "foutcont.txt");
    else
      open(fout, IN_FILE, "fout.txt");
    end if;

    afficheGrille(V, "");
    nbSol := nbCombi(fout, nbelem);
    reset(fout, IN_FILE);
    currSol := 1;

    loop
      put("Solution "); put(currSol, 1); put("/"); put(nbSol, 1); new_line;
      afficheGrille(V, combi(fout, nbelem, currSol));
      reset(fout, IN_FILE);

      -- Récupération de l'action
      getAction(action, newSol);
      case action is
        when '+' =>
          currSol := currSol + 1;
          if currSol > nbSol then currSol := nbSol;
          end if;
        when '-' =>
          currSol := currSol - 1;
          if currSol < 1 then currSol := 1;
          end if;
        when 'n' =>
          currSol := newSol;
          if currSol > nbSol then currSol := nbSol;
          elsif currSol < 1 then currSol := 1;
          end if;
        when others => null;
      end case;
    exit when action = 'q';
    end loop;

    afficheSolution(nbelem, fout);

    new_line;
    put("Voulez-vous continuer ? (o/n) ");
    continue := getUserBool;
    close(fout);
    exit when not continue;
  end loop;

  close(f);
end gauditext;
