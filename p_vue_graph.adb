with p_fenbase, Forms, p_combinaisons, Ada.Strings, Ada.Strings.Fixed;
use  p_fenbase, Forms, p_combinaisons, Ada.Strings, Ada.Strings.Fixed;

package body p_vue_graph is

  function GetElement (
        Pliste     : TA_Element;
        NomElement : String      )
    return TA_Element is
  begin
    if Pliste=null or else Pliste.NomElement.all>NomElement then
      return null;
    elsif Pliste.NomElement.all=NomElement then
      return Pliste;
    else
      return GetElement(Pliste.Suivant,NomElement);
    end if;
  end GetElement;

  procedure afficherGrille(fen: in out TR_Fenetre; x,y: in natural; V: in TV_Gaudi) is
  -- {} => {Affiche la grille avec le bord gauche à la position (x,y)}
    textX, textY: natural;
    P : TA_Element;
  begin
    ajouterTexte(fen, "fond_grille", "", x, y, 400, 400);
    changerCouleurFond(fen, "fond_grille", FL_BLACK);

    for i in V'range loop
      textX := x + 5 + (99 * ((i-1) / 4));
      textY := y + 5 + (99 * ((i-1) mod 4));
      ajouterTexte(fen, V(i).nom, trim(Integer'image(V(i).valeur), BOTH), textX, textY, 92, 92);
      changerTailleTexte(fen, V(i).nom, FL_HUGE_SIZE);
      P := GetElement(fen.PElements, V(i).nom);
      fl_set_object_align(P.Pelement, FL_ALIGN_CENTER);
    end loop;
  end afficherGrille;

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
    ajouterBouton(fenetre, "Contigue", "Solutions contigue", 35 , 375 , 200 , 50);
    ajouterBouton(fenetre, "Normal", "Toutes les solutions", 265 , 375 , 200 , 50);
    ajouterBouton(fenetre, "Fermer", "Quitter", 200 , 450 , 100 , 50);
    ajouterTexte(fenetre, "Textintro", "Lorem ipsum dolor sit amet, tempor incididu labore et dolor ", 50,100,400,20);
    ajouterTexte(fenetre, "Textintro2", "Lorem ipsum dolor sit amet, tempor incididu labore et dolor ", 50,112,400,20);
    ajouterTexte(fenetre, "Textintro3", "Lorem ipsum dolor sit amet, tempor incididu labore et dolor ", 50,124,400,20);
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
