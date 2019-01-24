with text_io, sequential_IO;
use  text_io;

package p_jeu is
  type TR_Score is record
    pseudo: string(1..20);
    score: integer;
  end record;

  package p_score_io is new sequential_IO(TR_Score); use p_score_io;

  SOLUTION_CORRECTE : constant integer := 0;
  SOLUTION_DOUBLON : constant integer := 1;
  SOLUTION_INCORRECTE : constant integer := 2;
  SOLUTION_INVALIDE : constant integer := 3;

  tailleSolution : integer;
  fichierSolution : text_io.file_type;
  dernier : string(1..14);
  fichierJeu : text_io.file_type;
  pseudo: string(1..20);

  type TV_Score is array (positive range <>) of TR_Score;

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

  function Nbscores(f : in p_score_io.file_type) return integer;
  --{} => {copmpte de le Nb de score du fichier}

  procedure CopieFicherScore(f : in out p_score_io.file_type ;  V : out TV_Score);
  --{f ouvert, V de taille suffisante} => {Copie les elements vers v}

  procedure permut(a, b: in out  TR_Score) ;
  -- {} => {les valeurs de a et b ont été échangées}

  procedure triBullesScores(V : in out TV_Score);
  -- {} => {V trié par ordre croissant}

end p_jeu;
