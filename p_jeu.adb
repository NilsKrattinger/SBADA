with p_combinaisons, Ada.Characters.Handling;
use  p_combinaisons, Ada.Characters.Handling;

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
  f :p_score_io.file_type;
  begin
    open(f, APPEND_FILE, "score");
    write(f, score);
    close(f);
  end enregistrerScore;

  procedure finJeu(abandon: in boolean) is
  -- {} => {Finit le jeu}
  begin
--   if not abandon then
enregistrerScore((pseudo, compterPoints));-- end if;
    delete(fichierJeu);
    close(fichierSolution);
  end finJeu;

  procedure verifSol(solution: in string; result: out integer) is
  -- {} => {result contient le statut de la solution (correcte, doublon, incorrecte)}
    estValide, dejaTrouve: boolean;
    combinaison: string := to_upper(solution);
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

  function Nbscores(f : in p_score_io.file_type) return integer is
  --{f ouvert et f- = <>} => {copmpte de le Nb de score du fichier}
  tmp : TR_Score;
  i: integer := 0;
begin
    while not end_of_file(f) loop
    read(f,Tmp);
      i := i+1;
  end loop;
  return i;
end Nbscores;


  procedure CopieFicherScore(f : in out p_score_io.file_type ;  V : out TV_Score) is
  -- {f ouvert, V de taille suffisante} => {Copie les elements vers v}
    tmp : TR_Score;
    i: integer;
  begin
    i := v'first;
    reset(f,IN_FILE);
    while not end_of_file(f)  loop
      read(f,tmp);
      v(i) := tmp;
      i := i+1;
    end loop;
    close(f);
  end CopieFicherScore;

  procedure permut(a, b: in out  TR_Score) is -- type des valeurs du vecteur
  -- {} => {les valeurs de a et b ont été échangées}
    temp: TR_Score ;
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
