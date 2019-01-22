with p_fenbase, p_combinaisons;
use  p_fenbase, p_combinaisons;

package p_vue_graph is

  procedure afficherGrille(fen: in out TR_Fenetre; x,y: in natural; V: in TV_Gaudi);
  -- {} => {Affiche la grille avec le bord gauche à la position (x,y)}

end p_vue_graph;
