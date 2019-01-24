with text_io, sequential_IO;
use  text_io;

package p_jeu is
  type TR_Score is record
    pseudo: string(1..20);
    score: integer;
  end record;

  task type T_Chrono is
    entry start(temps: in duration);
    entry fermer;
    entry stop;
  end T_Chrono;

  package p_score_io is new sequential_IO(TR_Score); use p_score_io;
  type TV_Score is array (positive range <>) of TR_Score;

  FREQUENCE_MAJ : constant duration := 1.0;
  SOLUTION_CORRECTE : constant integer := 0;
  SOLUTION_DOUBLON : constant integer := 1;
  SOLUTION_INCORRECTE : constant integer := 2;
  SOLUTION_INVALIDE : constant integer := 3;

  fichierJeu : text_io.file_type;
  fichierSolution : text_io.file_type;
  tailleSolution : integer;

  dernier : string(1..14);
  pseudo: string(1..20);

  tempsRestant : duration := 0.0;
  jeuEnCours : boolean := false;
  chrono : T_Chrono;

  procedure debutJeu(contigue: in boolean);
  -- {} => {Lance le jeu}

  function compterPoints return integer;
  -- {fichierJeu ouvert} => {résultat = nombre de points du joueur}

  procedure enregistrerScore(score: in TR_Score);
  -- {} => {le score a été enregistré dans le fichier de scores}

  procedure finJeu(abandon: in boolean);
  -- {} => {Finit le jeu}

  procedure verifSol(solution: in string; result: out integer);
  -- {} => {Vérifie si la solution est correcte}

  function nbScores(f : in p_score_io.file_type) return integer;
  --{f ouvert et f- = <>} => {compte le nombre de score dans le fichier}

  procedure copieFichierScore(f : in out p_score_io.file_type ;  V : out TV_Score);
  --{f ouvert, V de taille suffisante} => {Copie les elements vers v}

  procedure permut(a, b: in out  TR_Score) ;
  -- {} => {les valeurs de a et b ont été échangées}

  procedure triBullesScores(V : in out TV_Score);
  -- {} => {V trié par ordre croissant}

end p_jeu;
