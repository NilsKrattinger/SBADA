with p_fenbase; use p_fenbase;

package body p_vue_graph is

  procedure Acceuil is
    fenetre : TR_Fenetre;
  begin
    initialiserFenetres;
    fenetre:= DebutFenetre("Acceuil",500,500);
    for i in 3..7 loop
      AjouterBouton(fenetre, integer'image(i)(2..2),integer'image(i)(2..2), 50+(75*(i-3)) , 300, 50, 50);
    end loop;
    AjouterBouton(fenetre, "Contigue", "Solutions contigüe", 35 , 375 , 200 , 50);
    AjouterBouton(fenetre, "Normal", "Toutes les solutions", 265 , 375 , 200 , 50);
    AjouterBouton(fenetre, "Fermer", "Quitter", 200 , 450 , 100 , 50);
    FinFenetre(fenetre);
    MontrerFenetre(fenetre);
    if (attendreBouton(fenetre) /= "MDR") then null; end if;
  end Acceuil;



end p_vue_graph;
