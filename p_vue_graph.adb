with p_fenbase, Forms, p_combinaisons, Ada.Strings, Ada.Strings.Fixed, text_io;
use  p_fenbase, Forms, p_combinaisons, Ada.Strings, Ada.Strings.Fixed, text_io, p_combinaisons.p_cases_io;


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

  procedure afficherGrille(fen: in out TR_Fenetre; x,y: in natural) is
  -- {} => {Affiche la grille avec le bord gauche à la position (x,y)}
    textX, textY: natural;
    P : TA_Element;
    f: p_cases_io.file_type;
    V: TV_Gaudi(1..16);
  begin
    open(f, IN_FILE, "CarreGaudi");
    CreeVectGaudi(f, V);
    triVectGaudi(V);
    close(f);

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

  procedure fenetreaccueil is
    fenetre : TR_Fenetre;
  begin
    fenetre:= DebutFenetre("Accueil",500,500);
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
    ajouterTexte(fenetre, "Textintro", "Bienvenue dans le programme du carre de Subirachs", 50,100,400,30);
    ajouterTexte(fenetre, "Textintro2", "Sur cet ecran, vous pouvez choisir le nombre d'elements d'une", 50,130,400,30);
    ajouterTexte(fenetre, "Textintro3", "solution, et choisir de ne consulter que les solutions contigues. ", 50,160,400,30);
    ajouterTexte(fenetre, "Textintro4", "Bon jeu ! ", 220,210,400,30);
    finFenetre(fenetre);
    montrerFenetre(fenetre);
    appuiBoutonAccueil(attendreBouton(fenetre),fenetre);
  end fenetreaccueil;

  procedure fenetreSolutions is
   fenetre : TR_Fenetre;
  begin
    fenetre:= DebutFenetre("Solutions",500,650);
    afficherGrille(fenetre, 50,50);
    ajouterTexte(fenetre,"Solution","Solution X/Y",50,500,200,30);
    ajouterTexte(fenetre,"ZoneSolution","AXBXCXDXBXCXDX",250,500,200,30);
    ajouterBouton(fenetre, "prec", "Precedente", 50 , 550 , 100 , 30);
    ajouterBouton(fenetre, "suiv", "Suivante", 350 , 550 , 100 , 30);
    ajouterBouton(fenetre, "retour", "Retour", 200 , 600 , 100 , 30);
    changerTailleTexte(fenetre, "Solution" ,FL_MEDIUM_SIZE);
    changerStyleTexte(fenetre, "Solution", FL_BOLD_STYLE);
    changerTailleTexte(fenetre, "ZoneSolution" ,FL_MEDIUM_SIZE);
    changerStyleTexte(fenetre, "ZoneSolution", FL_BOLD_STYLE);
    finFenetre(fenetre);
    montrerFenetre(fenetre);
    combinaisonAct := 1;
    actualisationInfos(fenetre, 1);
    appuiBoutonSolution(attendreBouton(fenetre), fenetre);

  end fenetreSolutions;

  procedure ouvreFenetreSolutions(nomFichier: in string; fenetre: TR_Fenetre) is
  begin
    open(fichierSolution, IN_FILE, nomFichier);
    nbCombinaisons := nbCombi(fichierSolution, nbCasesSolution);
    reset(fichierSolution, IN_FILE);
    cacherFenetre(fenetre);
    fenetreSolutions;
  end ouvreFenetreSolutions;

  procedure appuiBoutonAccueil (Elem : in string; fenetre : in out TR_Fenetre) is

  begin --
    if Elem in "3" | "4" | "5" | "6" | "7" then
      for i in 3..7 loop
          changerCouleurTexte(fenetre,integer'image(i)(2..2), FL_BLACK);
      end loop;
      changerCouleurTexte(fenetre,Elem , FL_DOGERBLUE);
      nbCasesSolution := integer'value(elem);
      appuiBoutonAccueil(attendreBouton(fenetre),fenetre);
    elsif Elem = "Contigue" then
      ouvreFenetreSolutions("foutcont.txt", fenetre);
    elsif Elem = "Normal" then
      ouvreFenetreSolutions("fout.txt", fenetre);
    elsif Elem = "Fermer" then
      CacherFenetre(fenetre);
    else
      appuiBoutonAccueil(attendreBouton(fenetre),fenetre);
    end if;

  end appuiBoutonAccueil;

  procedure appuiBoutonSolution (Elem : in string; fenetre : in out TR_Fenetre) is

  begin
    if Elem = "prec" then
      if combinaisonAct = 1 then
        appuiBoutonSolution(attendreBouton(fenetre),fenetre);
      else
        combinaisonAct := combinaisonAct - 1;
        actualisationInfos(fenetre, combinaisonAct + 1);
        appuiBoutonSolution(attendreBouton(fenetre),fenetre);
      end if;
    elsif Elem = "suiv" then
      if combinaisonAct = nbCombinaisons then
        appuiBoutonSolution(attendreBouton(fenetre),fenetre);
      else
        combinaisonAct := combinaisonAct + 1;
        actualisationInfos(fenetre, combinaisonAct - 1);
        appuiBoutonSolution(attendreBouton(fenetre),fenetre);
      end if;
    elsif Elem = "retour" then
      cacherFenetre(fenetre);
      close(fichierSolution);
      fenetreAccueil;
    else
      appuiBoutonSolution(attendreBouton(fenetre),fenetre);
    end if;


  end appuiBoutonSolution;

  procedure actualisationInfos(fen: in out TR_Fenetre; combinaisonOld: integer) is
  -- {} => {Actualisation des informations pour la solution nbSol}
    ancienneSolution, nouvelleSolution: string(1..nbCasesSolution*2);
  begin
    reset(fichierSolution, IN_FILE);
    ancienneSolution := combi(fichierSolution, nbCasesSolution, combinaisonOld);
    reset(fichierSolution, IN_FILE);
    nouvelleSolution := combi(fichierSolution, nbCasesSolution, combinaisonAct);
    changerTexte(fen, "Solution", "Solution" & Integer'image(combinaisonAct) & '/' & Integer'image(nbCombinaisons));
    changerTexte(fen, "ZoneSolution", nouvelleSolution);
    actualisationGraph(fen, ancienneSolution, nouvelleSolution);
  end actualisationInfos;

  procedure actualisationGraph(fen: in out TR_Fenetre; combinaisonOld, combinaisonCurr: in string) is
  -- {} => {Actualisation de la grille avec la nouvelle combinaison}
  begin
    for i in 1..combinaisonOld'length/2 loop
      changerCouleurFond(fen, combinaisonOld(i*2-1..i*2), FL_COL1);
    end loop;

    for i in 1..combinaisonCurr'length/2 loop
      changerCouleurFond(fen, combinaisonCurr(i*2-1..i*2), FL_WHEAT);
    end loop;
  end;

end p_vue_graph;
