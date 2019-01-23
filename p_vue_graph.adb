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
    fenetre:= DebutFenetre("Accueil",500,600);
    for i in 3..7 loop
      ajouterBouton(fenetre, integer'image(i)(2..2),integer'image(i)(2..2), 75+(75*(i-3)) , 300, 50, 50);
      changerTailleTexte(fenetre, integer'image(i)(2..2),FL_MEDIUM_SIZE);
      changerStyleTexte(fenetre, integer'image(i)(2..2), FL_BOLD_STYLE);
    end loop;
    contigue := false;
    nbCasesSolution := 3;
    changerCouleurTexte(fenetre,"3" , FL_DOGERBLUE);
    ajouterBouton(fenetre, "jeu", "Jouer au jeu", 35 , 430, 200 , 50);
    ajouterBouton(fenetre, "Solution", "Afficher Solutions", 265 , 430 , 200 , 50);
    ajouterBouton(fenetre, "Fermer", "Quitter", 200 , 505 , 100 , 50);
    ajouterBouton(fenetre, "Contigue", "Non", 200 , 375 , 50 , 30);
    ajouterTexte(fenetre, "TexTContigue : ", "Seulement contigue : ", 50,375,150,30);
    ajouterTexte(fenetre, "Textintro", "Bienvenue dans le programme du carre de Subirachs", 50,100,400,30);
    ajouterTexte(fenetre, "Textintro2", "Sur cet ecran, vous pouvez choisir le nombre d'elements d'une", 50,130,400,30);
    ajouterTexte(fenetre, "Textintro3", "solution, et choisir de ne consulter que les solutions contigues. ", 50,160,400,30);
    ajouterTexte(fenetre, "Textintro4", "Bon jeu ! ", 220,210,120,30);
    changerStyleTexte(fenetre,"Contigue", FL_BOLD_STYLE);
    finFenetre(fenetre);
    montrerFenetre(fenetre);
    appuiBoutonAccueil(attendreBouton(fenetre),fenetre);
  end fenetreaccueil;

  procedure fenetreSolutions is
    --{} => {Affiche la fenetre de Solutions}
   fenetre : TR_Fenetre;
  begin
    fenetre:= DebutFenetre("Solutions",500,650);
    afficherGrille(fenetre, 50,50);
    ajouterTexte(fenetre,"Solution","Solution",50,500,120,30);
    AjouterChamp(fenetre,"ChampNum","","131",140,500,40,30);
    ajouterTexte(fenetre,"Y","/ 131",180,500,50,30);
    ajouterTexte(fenetre,"ZoneSolution","AXBXCXDXBXCXDX",250,500,200,30);
    ajouterBouton(fenetre, "prec", "Precedente", 50 , 550 , 100 , 30);
    ajouterBouton(fenetre, "suiv", "Suivante", 350 , 550 , 100 , 30);
    ajouterBouton(fenetre, "retour", "Retour", 200 , 600 , 100 , 30);
    ajouterBouton(fenetre, "aller", "Aller A", 200 , 550 , 100 , 30);
    changerTailleTexte(fenetre, "Solution" ,FL_MEDIUM_SIZE);
    changerStyleTexte(fenetre, "Solution", FL_BOLD_STYLE);
    changerTailleTexte(fenetre, "ZoneSolution" ,FL_MEDIUM_SIZE);
    changerStyleTexte(fenetre, "ZoneSolution", FL_BOLD_STYLE);
    changerTailleTexte(fenetre, "ChampNum" ,FL_MEDIUM_SIZE);
    changerStyleTexte(fenetre, "ChampNum", FL_BOLD_STYLE);
    changerTailleTexte(fenetre, "Y" ,FL_MEDIUM_SIZE);
    changerStyleTexte(fenetre, "Y", FL_BOLD_STYLE);
    finFenetre(fenetre);
    montrerFenetre(fenetre);
    combinaisonAct := 1;
    actualisationInfos(fenetre, 1);
    appuiBoutonSolution(attendreBouton(fenetre), fenetre);

  end fenetreSolutions;


  procedure fenetreJeu is
    fenetre : TR_Fenetre;
  begin
    fenetre:= DebutFenetre("Jeu",500,650);
    afficherGrille(fenetre, 50,100);
    ajouterTexte(fenetre,"Txt1","Score : ",50,50,120,30);
    ajouterTexte(fenetre,"Score","0 Point",170,50,120,30);
    AjouterChamp(fenetre,"SolutionProp","","A1B3C4D5",100,520,300,30);
    ajouterBouton(fenetre, "valider", "Valider", 200 , 560 , 100 , 30);
    ajouterBouton(fenetre, "abandon", "Abandonner", 200 , 650 , 100 , 30);
    changerStyleTexte(fenetre,"Score", FL_BOLD_STYLE);
    changerStyleTexte(fenetre,"SolutionProp", FL_BOLD_STYLE);
    changerStyleTexte(fenetre,"valider", FL_BOLD_STYLE);
    changerStyleTexte(fenetre,"Txt1", FL_BOLD_STYLE);
    changerTailleTexte(fenetre, "Score" ,FL_MEDIUM_SIZE);
    changerTailleTexte(fenetre, "SolutionProp" ,FL_MEDIUM_SIZE);
    changerTailleTexte(fenetre, "valider" ,FL_MEDIUM_SIZE);
    changerTailleTexte(fenetre, "Txt1" ,FL_MEDIUM_SIZE);

    finFenetre(fenetre);
    montrerFenetre(fenetre);
    appuiBoutonJeu(attendreBouton(fenetre), fenetre);

  end fenetreJeu;

  procedure fenetreRegles is
    fenetre: TR_Fenetre;
  begin
    fenetre:= DebutFenetre("Regles",500,300);
    ajouterTexte(fenetre, "Text1 : ", "Saisir votre pseudo : ", 50,50,150,30);
    AjouterChamp(fenetre,"pseudo","","Pseudo",200,50,160,30);
    ajouterTexte(fenetre,"Txt2","Juste",50,90,60,50);
    ajouterTexte(fenetre,"Txt3","Double",50,150,60,50);
    ajouterTexte(fenetre,"Txt4","Faux",50,210,60,50);
    ajouterTexte(fenetre, "Regles1", "Bienvenue dans le programme du carre de Subira", 130,90,320,30);
    ajouterTexte(fenetre, "Regles2", "Bienvenue dans le programme du carre de Subira", 130,120,320,30);
    ajouterTexte(fenetre, "Regles3", "Bienvenue dans le programme du carre de Subira", 130,150,320,30);
    ajouterTexte(fenetre, "Regles4", "Bienvenue dans le programme du carre de Subira", 130,180,320,30);
    ajouterTexte(fenetre, "Regles5", "Bienvenue dans le programme du carre de Subira", 130,210,320,30);
    ajouterTexte(fenetre, "Regles6", "Bienvenue dans le programme du carre de Subira", 130,240,320,30);
    ajouterBouton(fenetre, "valider", "Valider", 200 , 300 , 100 , 30);
    changerStyleTexte(fenetre,"Txt2", FL_BOLD_STYLE);
    changerStyleTexte(fenetre,"Txt3", FL_BOLD_STYLE);
    changerStyleTexte(fenetre,"Txt4", FL_BOLD_STYLE);
    changerCouleurFond(fenetre,"Txt2", FL_CHARTREUSE);
    changerCouleurFond(fenetre,"Txt3", FL_WHEAT);
    changerCouleurFond(fenetre,"Txt4", FL_TOMATO);
    finFenetre(fenetre);
    montrerFenetre(fenetre);
    appuiBoutonRegles(attendreBouton(fenetre), fenetre);
  end fenetreRegles;

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
      if contigue then
        contigue := false;
        changerTexte(fenetre,"Contigue","Non");
        changerCouleurTexte(fenetre,"Contigue" , FL_BLACK);
      else
        contigue := true;
        changerTexte(fenetre,"Contigue","Oui");
        changerCouleurTexte(fenetre,"Contigue" , FL_DOGERBLUE);
      end if;
      appuiBoutonAccueil(attendreBouton(fenetre),fenetre);
    elsif Elem = "Solution" then
      if contigue then
        ouvreFenetreSolutions("foutcont.txt", fenetre);
      else
        ouvreFenetreSolutions("fout.txt", fenetre);
      end if;
    elsif Elem = "jeu" then
      cacherFenetre(fenetre);
      debutJeu;
    elsif Elem = "Fermer" then
      CacherFenetre(fenetre);
    else
      appuiBoutonAccueil(attendreBouton(fenetre),fenetre);
    end if;

  end appuiBoutonAccueil;

  procedure appuiBoutonSolution (Elem : in string; fenetre : in out TR_Fenetre) is
    combinaisonVoulue : integer;
    combinaisonOld : integer;
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
    elsif  Elem = "aller" or Elem = "ChampNum" then
      begin
        combinaisonVoulue := integer'value(ConsulterContenu(fenetre,"ChampNum"));
        exception
        when others =>
          actualisationInfos(fenetre,combinaisonAct);
          appuiBoutonSolution(attendreBouton(fenetre),fenetre);
      end;
      combinaisonOld := combinaisonAct;
      if combinaisonVoulue > nbCombinaisons or combinaisonVoulue < 1 then
        actualisationInfos(fenetre,combinaisonAct);
        appuiBoutonSolution(attendreBouton(fenetre),fenetre);
      else
        combinaisonAct := combinaisonVoulue;
        actualisationInfos(fenetre, combinaisonOld);
        appuiBoutonSolution(attendreBouton(fenetre),fenetre);
      end if;
    else
      appuiBoutonSolution(attendreBouton(fenetre),fenetre);
    end if;




  end appuiBoutonSolution;

  procedure appuiBoutonRegles (Elem : in string; fenetre : in out TR_Fenetre) is
    begin -- appuiBoutonRegles
      if Elem = "pseudo" or Elem ="valider" then
      begin
        if ConsulterContenu(fenetre,"pseudo") /= "Pseudo" then
          pseudo(ConsulterContenu(fenetre,"pseudo")'range) := ConsulterContenu(fenetre,"pseudo");
        else
            appuiBoutonRegles(attendreBouton(fenetre),fenetre);
          end if;
          exception
          when others =>
            ChangerContenu(fenetre, "pseudo", "Pseudo");
            appuiBoutonRegles(attendreBouton(fenetre),fenetre);
          end;
          cacherFenetre(fenetre);
    else
      appuiBoutonRegles(attendreBouton(fenetre),fenetre);
    end if;
  end appuiBoutonRegles;

  procedure appuiBoutonJeu (Elem : in string; fenetre : in out TR_Fenetre) is
    pts : integer;
  begin --
    if Elem = "SolutionProp" or Elem ="valider" then
      verifSol(fenetre, consulterContenu(fenetre, "SolutionProp"));
      pts := compterPoints;
      changerTexte(fenetre, "Score", trim(Integer'image(pts), BOTH) & (if pts >= 2 then " Points" else " Point"));
      appuiBoutonJeu(attendreBouton(fenetre),fenetre);
    elsif Elem = "abandon" then
      finJeu(fenetre, true);
    else
      appuiBoutonJeu(attendreBouton(fenetre),fenetre);
  end if;
  end appuiBoutonJeu;

  procedure actualisationInfos(fen: in out TR_Fenetre; combinaisonOld: integer) is
      -- {} => {Actualisation des informations pour la solution nbSol}
      ancienneSolution, nouvelleSolution: string(1..nbCasesSolution*2);
  begin
    reset(fichierSolution, IN_FILE);
    ancienneSolution := combi(fichierSolution, nbCasesSolution, combinaisonOld);
    reset(fichierSolution, IN_FILE);
    nouvelleSolution := combi(fichierSolution, nbCasesSolution, combinaisonAct);
    ChangerContenu(fen, "ChampNum",  trim(Integer'image(combinaisonAct),BOTH));
    changerTexte(fen, "Y", '/' & Integer'image(nbCombinaisons));
    changerTexte(fen, "ZoneSolution", nouvelleSolution);
    affichageSol(fen, ancienneSolution, FL_COL1);
    affichageSol(fen, nouvelleSolution, FL_WHEAT);
  end actualisationInfos;

  procedure affichageSol(fen: in out TR_Fenetre; combinaison: in string; coul: in FL_Color) is
    -- {} => {Actualisation de la grille avec la solution de couleur coul}
  begin
    for i in 1..combinaison'length/2 loop
      changerCouleurFond(fen, combinaison(i*2-1..i*2), coul);
    end loop;
  end affichageSol;

  procedure debutJeu is
  -- {} => {Lance le jeu}
  begin
    nbCasesSolution := 0;
    create(fichierJeu, IN_FILE, "solutionsTrouvees");
    open(fichierSolution, IN_FILE, (if contigue then "foutcont.txt" else "fout.txt"));
    pseudo := (others => ' ');
    fenetreRegles;
    fenetreJeu;
  end debutJeu;

  function compterPoints return integer is
  -- {fichierJeu ouvert} => {résultat = nombre de points du joueur}
    sol: string(1..15);
    nb: integer;
    score : integer := 0;
  begin
    reset(fichierJeu, IN_FILE);
    while not end_of_file(fichierJeu) loop
      get_line(fichierJeu, sol, nb);
      case nb/2 is
        when 3 => score := score + 2;
        when 4 => score := score + 1;
        when 5 => score := score + 2;
        when 6 => score := score + 3;
        when 7 => score := score + 5;
        when others => null;
      end case;
    end loop;

    return score;
  end compterPoints;

  procedure enregistrerScore(score: in TR_Score) is
  -- {} => {le score a été enregistré dans le fichier de scores}
    f: p_score_io.file_type;
  begin
    create(f, APPEND_FILE, "score");
    write(f, score);
    close(f);
  end enregistrerScore;

  procedure finJeu(fen: in out TR_Fenetre; abandon: in boolean) is
  -- {} => {Finit le jeu}
  begin
    if not abandon then enregistrerScore((pseudo, compterPoints)); end if;
    delete(fichierJeu);
    close(fichierSolution);
    cacherFenetre(fen);
    fenetreAccueil;
  end finJeu;

  procedure verifSol(fen: in out TR_Fenetre; solution: in string) is
  -- {} => {Vérifie si la solution est correcte}
    estValide, dejaTrouve: boolean;
    combinaison: string := solution;
  begin

    if combinaison'length > 0 then
      ordonne(combinaison);
      if nbCasesSolution > 0 then
        affichageSol(fen, dernier(1..nbCasesSolution*2), FL_COL1);
      end if;
      begin
        dernier := (others => ' ');
        dernier(combinaison'range) := combinaison;
        nbCasesSolution := combinaison'length / 2;
        changerContenu(fen, "SolutionProp", "");

        resultatExiste(fichierSolution, combinaison, estValide);
        if estValide then -- la solution existe
          resultatExiste(fichierJeu, combinaison, dejaTrouve);
          if not dejaTrouve then -- la solution n'a pas encore été découverte
            affichageSol(fen, combinaison, FL_CHARTREUSE);
            reset(fichierJeu, APPEND_FILE);
            put_line(fichierJeu, combinaison);
          else
            affichageSol(fen, combinaison, FL_WHEAT);
          end if;
        else
          affichageSol(fen, combinaison, FL_TOMATO);
        end if;
        exception
        when others =>
          appuiBoutonJeu(attendreBouton(fen),fen);
        end;
      end if;
  end verifSol;

end p_vue_graph;
