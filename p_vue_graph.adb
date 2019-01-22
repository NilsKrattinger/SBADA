with p_fenbase; use p_fenbase;

package body p_vue_graph is

  procedure accueil is
    fenetre : TR_Fenetre;
  begin
    initialiserFenetres;
    fenetre:= DebutFenetre("Acceuil",500,500);
    for i in 3..7 loop
      ajouterBouton(fenetre, integer'image(i)(2..2),integer'image(i)(2..2), 75+(75*(i-3)) , 300, 50, 50);
    end loop;
    ajouterBouton(fenetre, "Contigue", "Solutions contigue", 35 , 375 , 200 , 50);
    ajouterBouton(fenetre, "Normal", "Toutes les solutions", 265 , 375 , 200 , 50);
    ajouterBouton(fenetre, "Fermer", "Quitter", 200 , 450 , 100 , 50);
    finFenetre(fenetre);
    montrerFenetre(fenetre);
    appuiBouton(attendreBouton(fenetre),fenetre);
  end accueil;

  procedure appuiBoutonAccueil (Elem : in string, fenetre : in TR_Fenetre) is

  begin --
    if Elem in "3" | "4" | "5" | "6" | "7" then
      for i in 3..7 loop
          changerCouleurTexte(fenetre,integer'image(i)(2..2), FL_BLACK);
          nbCasesSolution := integer'image(i)(2..2);
          appuiBoutonAccueil(Elem,fenetre);
      end loop;
      changerCouleurTexte(fenetre,Elem , FL_DOGERBLUE);
    else if Elem in "Contigue" | "Normal" then
      --fenetreJeu(Elem,fenetre)
      Null;
    else if Elem = "Fermer" then
      CacherFenetre(fenetre);
    else
      appuiBoutonAccueil(Elem,fenetre);
    end if;

  end appuiBoutonAccueil;


end p_vue_graph;
