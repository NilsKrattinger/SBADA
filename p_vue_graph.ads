with p_fenbase, p_combinaisons, text_io;
use  p_fenbase, p_combinaisons, text_io;

package p_vue_graph is
  nbCasesSolution : integer;
  fichierSolution : text_io.file_type;

  procedure afficherGrille(fen: in out TR_Fenetre; x,y: in natural);
  -- {} => {Affiche la grille avec le bord gauche à la position (x,y)}

  procedure fenetreaccueil;

  procedure appuiBoutonAccueil (Elem : in string; fenetre : in out TR_Fenetre);

end p_vue_graph;
