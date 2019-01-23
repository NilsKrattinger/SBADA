with p_combinaisons ;
use  p_combinaisons ;

package body p_jeu is
  procedure debutJeu(contigue: in boolean) is
  -- {} => {Lance le jeu}
  begin
    tailleSolution := 0;
    create(fichierJeu, IN_FILE, "solutionsTrouvees");
    open(fichierSolution, IN_FILE, (if contigue then "foutcont.txt" else "fout.txt"));
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
    create(f, APPEND_FILE, "score");
    write(f, score);
    close(f);
  end enregistrerScore;

  procedure finJeu(abandon: in boolean) is
  -- {} => {Finit le jeu}
  begin
    if not abandon then enregistrerScore((pseudo, compterPoints)); end if;
    delete(fichierJeu);
    close(fichierSolution);
  end finJeu;

  procedure verifSol(solution: in string; result: out integer) is
  -- {} => {result contient le statut de la solution (correcte, doublon, incorrecte)}
    estValide, dejaTrouve: boolean;
    combinaison: string := solution;
  begin
    if combinaison'length > 0 and combinaison'length <= 14 then
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
end p_jeu;
