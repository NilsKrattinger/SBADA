with p_fenbase, p_combinaisons, text_io;
use  p_fenbase, p_combinaisons, text_io;

package p_vue_graph is
  nbCasesSolution : integer;
  nbCombinaisons : integer;
  fichierSolution : text_io.file_type;
  combinaisonAct : integer;

  procedure afficherGrille(fen: in out TR_Fenetre; x,y: in natural);
  -- {} => {Affiche la grille avec le bord gauche à la position (x,y)}

  procedure fenetreaccueil;

  procedure appuiBoutonAccueil (Elem : in string; fenetre : in out TR_Fenetre);

  procedure appuiBoutonSolution (Elem : in string; fenetre : in out TR_Fenetre);

  procedure actualisationInfos(fen: in out TR_Fenetre; combinaisonOld: integer);
  -- {} => {Actualisation des informations pour la solution nbSol}

  procedure actualisationGraph(fen: in out TR_Fenetre; combinaisonOld, combinaisonCurr: in string);
  -- {} => {Actualisation de la grille avec la nouvelle combinaison}

end p_vue_graph;
