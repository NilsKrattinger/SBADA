with p_fenbase, Forms;
use  p_fenbase, Forms;

package body p_vue_graph is

  procedure accueil is
    fenetre : TR_Fenetre;
  begin
    initialiserFenetres;
    fenetre:= DebutFenetre("Acceuil",500,500);
    for i in 3..7 loop
      ajouterBouton(fenetre, integer'image(i)(2..2),integer'image(i)(2..2), 75+(75*(i-3)) , 300, 50, 50);
      changerTailleTexte(fenetre, integer'image(i)(2..2),FL_MEDIUM_SIZE);
      changerStyleTexte(fenetre, integer'image(i)(2..2), FL_BOLD_STYLE);
    end loop;
    nbCasesSolution := 3;
    changerCouleurTexte(fenetre,"3" , FL_DOGERBLUE);
    ajouterBouton(fenetre, "Contigue", "Solutions contigue", 35 , 375 , 200 , 50);
    ajouterBouton(fenetre, "Normal", "Toutes les solutions", 265 , 375 , 200 , 50);
    ajouterBouton(fenetre, "Fermer", "Quitter", 200 , 450 , 100 , 50);
    ajouterTexte(fenetre, "Textintro", "Lorem ipsum dolor sit amet, tempor incididu labore et dolor ", 50,100,400,20);
    ajouterTexte(fenetre, "Textintro2", "Lorem ipsum dolor sit amet, tempor incididu labore et dolor ", 50,120,400,20);
    ajouterTexte(fenetre, "Textintro3", "Lorem ipsum dolor sit amet, tempor incididu labore et dolor ", 50,140,400,20);
    finFenetre(fenetre);
    montrerFenetre(fenetre);
    appuiBoutonAccueil(attendreBouton(fenetre),fenetre);
  end accueil;

  procedure appuiBoutonAccueil (Elem : in string; fenetre : in out TR_Fenetre) is

  begin --
    if Elem in "3" | "4" | "5" | "6" | "7" then
      for i in 3..7 loop
          changerCouleurTexte(fenetre,integer'image(i)(2..2), FL_BLACK);
      end loop;
      changerCouleurTexte(fenetre,Elem , FL_DOGERBLUE);
      nbCasesSolution := integer'value(elem);
      appuiBoutonAccueil(attendreBouton(fenetre),fenetre);
    elsif Elem in "Contigue" | "Normal" then
      --fenetreJeu(Elem,fenetre)
      Null;
    elsif Elem = "Fermer" then
      CacherFenetre(fenetre);
    else
      appuiBoutonAccueil(attendreBouton(fenetre),fenetre);
    end if;

  end appuiBoutonAccueil;


end p_vue_graph;
