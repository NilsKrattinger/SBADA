with p_combinaisons, Ada.Characters.Handling, Ada.Calendar;
use  p_combinaisons, Ada.Characters.Handling, Ada.Calendar;

package body p_jeu is
  task body T_Chrono is
    actif, fin: boolean := false;

    prochaine_maj, datefin : Ada.Calendar.Time;
  begin
    while not fin loop
      if not actif then -- Quand le chrono n'est pas actif
        select
          accept start(temps: in duration) do -- On démarre le chrono
            actif := true;
            datefin := Ada.Calendar.Clock + temps;
            prochaine_maj := Ada.Calendar.Clock + FREQUENCE_MAJ;
            tempsRestant := datefin - Ada.Calendar.Clock;
          end start;
        or
          accept fermer do -- On rend le chrono inutilisable
            fin := true;
          end fermer;
        end select;
      else
        select
          accept stop do -- On stoppe le chrono, il peut être à nouveau relancé via start, ou supprimé via fermer
            actif := false;
          end stop;
        or
          delay until prochaine_maj; -- S'il n'y a pas de stop, on attend la prochaine mise à jour du timer
        end select;

        if actif then -- Si on a appelé le stop, actif = false, donc on vérifie l'activité
          if datefin < Ada.Calendar.Clock then
            actif := false;
            tempsRestant := 0.0;
            finJeu(false); -- fin du jeu sans abandon
          else
            tempsRestant := datefin - Ada.Calendar.Clock;
            prochaine_maj := prochaine_maj + FREQUENCE_MAJ;
          end if;
        end if;
      end if;
    end loop;
  end T_Chrono;

  procedure debutJeu(contigue: in boolean) is
  -- {} => {Lance le jeu}
  begin
    tailleSolution := 0;
    create(fichierJeu, IN_FILE, "solutionsTrouvees");
    open(fichierSolution, IN_FILE, (if contigue then "foutcont.txt" else "fout.txt"));
    jeuEnCours := true;
    chrono.start(30.0);
  end debutJeu;

  function compterPoints return integer is
  -- {fichierJeu ouvert} => {résultat = nombre de points du joueur}
    sol: string(1..15);
    nb: integer;
    score : integer := 0;
  begin
    reset(fichierJeu, IN_FILE);
    while not end_of_file(fichierJeu) loop
      get_line(fichierJeu, sol, nb);
      case nb/2 is
        when 3 => score := score + 2;
        when 4 => score := score + 1;
        when 5 => score := score + 2;
        when 6 => score := score + 3;
        when 7 => score := score + 5;
        when others => null;
      end case;
    end loop;

    return score;
  end compterPoints;

  procedure enregistrerScore(score: in TR_Score) is
  -- {} => {le score a été enregistré dans le fichier de scores}
  f: p_score_io.file_type;
  begin
    open(f, APPEND_FILE, "score");
    write(f, score);
    close(f);
  end enregistrerScore;

  procedure finJeu(abandon: in boolean) is
  -- {} => {Finit le jeu}
  begin
    if not abandon then enregistrerScore((pseudo, compterPoints));
    else chrono.stop; -- Si c'est un abandon, le chrono n'a pas été arrêté
    end if;

    delete(fichierJeu); -- On supprime le fichier utilisé pour vérifier les doublons
    close(fichierSolution);
    jeuEnCours := false;
  end finJeu;

  procedure verifSol(solution: in string; result: out integer) is
  -- {} => {result contient le statut de la solution (correcte, doublon, incorrecte)}
    estValide, dejaTrouve: boolean;
    combinaison: string := to_upper(solution);
  begin
    if combinaison'length > 0 and combinaison'length <= 14 and jeuEnCours then -- Si le jeu est en cours, et que la combinaison est de taille correcte
      ordonne(combinaison);

      dernier := (others => ' ');
      dernier(combinaison'range) := combinaison;
      tailleSolution := combinaison'length;

      resultatExiste(fichierSolution, combinaison, estValide);
      if estValide then -- la solution existe
        resultatExiste(fichierJeu, combinaison, dejaTrouve);
        if not dejaTrouve then -- la solution n'a pas encore été découverte
          result := SOLUTION_CORRECTE;
          reset(fichierJeu, APPEND_FILE);
          put_line(fichierJeu, combinaison);
        else
          result := SOLUTION_DOUBLON;
        end if;
      else
        result := SOLUTION_INCORRECTE;
      end if;
    else
      result := SOLUTION_INVALIDE;
    end if;
  end verifSol;

  function nbScores(f : in p_score_io.file_type) return integer is
  --{f ouvert et f- = <>} => {compte le nombre de score dans le fichier}
  tmp : TR_Score;
  i: integer := 0;
  begin
    while not end_of_file(f) loop
      read(f,Tmp);
      i := i+1;
    end loop;
    return i;
  end nbScores;

  procedure copieFichierScore(f : in out p_score_io.file_type ; V : out TV_Score) is
  -- {f ouvert, V de taille suffisante} => {Copie les elements vers v}
    tmp : TR_Score;
    i: integer;
  begin
    i := V'first;
    reset(f,IN_FILE);
    while not end_of_file(f)  loop
      read(f,tmp);
      V(i) := tmp;
      i := i+1;
    end loop;
  end copieFichierScore;

  procedure permut(a, b: in out TR_Score) is
  -- {} => {les valeurs de a et b ont été échangées}
    temp: TR_Score;
  begin
    temp := a;
    a := b;
    b := temp;
  end permut;

  procedure triBullesScores(V : in out TV_Score) is
  -- {} => {V trié par ordre croissant}
    i : integer := V'first;
    permutation: boolean := true;
  begin
    while permutation loop
      permutation := false;
      for j in reverse i+1..V'last loop
        if V(j).score > V(j-1).score then
          permut(V(j), V(j-1));
          permutation := true;
        end if;
      end loop;
      i := i+1;
    end loop;
  end triBullesScores;


end p_jeu;
