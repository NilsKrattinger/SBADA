with p_fenbase, p_combinaisons, text_io, Forms, sequential_IO;
use  p_fenbase, p_combinaisons, text_io, Forms;

package p_vue_graph is
  type TR_Score is record
    pseudo: string(1..20);
    score: integer;
  end record;

  package p_score_io is new sequential_IO(TR_Score); use p_score_io;

  nbCasesSolution : integer;
  nbCombinaisons : integer;
  fichierSolution : text_io.file_type;
  combinaisonAct : integer;
  contigue : boolean;

  dernier : string(1..14);
  fichierJeu : text_io.file_type;
  pseudo: string(1..20);


  procedure afficherGrille(fen: in out TR_Fenetre; x,y: in natural);
  -- {} => {Affiche la grille avec le bord gauche à la position (x,y)}

  procedure fenetreaccueil;
  --{} => {Affiche la fenetre d'Accueil}

  procedure appuiBoutonAccueil (Elem : in string; fenetre : in out TR_Fenetre);
  --{} => {Affiche la fenetre Solutions}

  procedure appuiBoutonSolution (Elem : in string; fenetre : in out TR_Fenetre);

  procedure appuiBoutonJeu (Elem : in string; fenetre : in out TR_Fenetre);

  procedure actualisationInfos(fen: in out TR_Fenetre; combinaisonOld: integer);
  -- {} => {Actualisation des informations pour la solution nbSol}

  procedure debutJeu;
  -- {} => {Lance le jeu}

  function compterPoints return integer;
  -- {fichierJeu ouvert} => {résultat = nombre de points du joueur}

  procedure enregistrerScore(score: in TR_Score);
  -- {} => {le score a été enregistré dans le fichier de scores}

  procedure finJeu(fen: in out TR_Fenetre; abandon: in boolean);
  -- {} => {Finit le jeu}

  procedure affichageSol(fen: in out TR_Fenetre; combinaison: in string; coul: in FL_Color);
  -- {} => {Actualisation de la grille avec la solution de couleur coul}

  procedure verifSol(fen: in out TR_Fenetre; solution: in string);
  -- {} => {Vérifie si la solution est correcte}

end p_vue_graph;
