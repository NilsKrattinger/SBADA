with p_fenbase; use p_fenbase;

package body p_vue_graph is

  procedure Acceuil is
    Fenetre1 := TR_Fenetre;
  begin
    Fenetre1:= DebutFenetre("Acceuil",800,500);
    AttendreBouton(Fenetre1); 
  end Acceuil;



end p_vue_graph;
