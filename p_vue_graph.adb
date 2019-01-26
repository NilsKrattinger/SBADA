with p_fenbase, Forms, p_combinaisons, p_jeu, p_client, p_common, p_status, Ada.Strings, Ada.Strings.Fixed, text_io, Ada.Characters.Handling, X.Strings;
use  p_fenbase, Forms, p_combinaisons, p_jeu, p_client, p_common, p_status, Ada.Strings, Ada.Strings.Fixed, text_io, Ada.Characters.Handling, p_combinaisons.p_cases_io, p_jeu.p_score_io;

package body p_vue_graph is

  task body T_ActualisationJeu is
    actif, fin: boolean := false;
    fen: TR_Fenetre;
  begin
    while not fin loop
      if not actif then
        select
          accept start(fenetre: in out TR_Fenetre) do
            actif := true;
            fen := fenetre;
            changerTexte(fen, "Timer", Integer'image(Integer(Float'rounding(Float(tempsRestant)))));
          end start;
        or
          accept fermer do
            fin := true;
          end fermer;
        or
          terminate;
        end select;
      else
        select
          accept stop do
            actif := false;
          end stop;
        or
          delay FREQUENCE_MAJ;
        end select;

        if actif then
          changerTexte(fen, "Timer", Integer'image(Integer(Float'rounding(Float(tempsRestant)))));
          if not jeuEnCours and not enLigne then
            actif := false;
            cacherElem(fen, "valider");
            cacherElem(fen, "abandon");
            montrerElem(fen, "finjeu");
          end if;
        end if;
      end if;
    end loop;
  end T_ActualisationJeu;

  procedure ajoutElement (Pliste : in out TA_Element; typeElement : T_TypeElement;
        nomElement : string; texte : string; contenu : string; PElement : FL_OBJECT_Access ) is
  begin -- Copie de la procédure de fenbase pour l'utiliser dans AjouterBoutonInvisible
    if Pliste=null or else Pliste.nomElement.all>nomElement then
      Pliste:=new TR_Element'(typeElement, new String'(nomElement),         new String'(texte), new String'(contenu), PElement, Pliste);
    elsif Pliste.nomElement.all<nomElement then
      ajoutElement(Pliste.suivant, typeElement, nomElement, texte, contenu,         PElement);
    end if;
  end ajoutElement;

  function getElement (Pliste : TA_Element; nomElement : string)
    return TA_Element is
  begin -- Copie de la procédure de fenbase pour l'utiliser dans ajouterBoutonInvisible et afficherGrille
    if Pliste=null or else Pliste.nomElement.all>nomElement then
      return null;
    elsif Pliste.nomElement.all=nomElement then
      return Pliste;
    else
      return GetElement(Pliste.suivant, nomElement);
    end if;
  end getElement;

  procedure ajouterBoutonInvisible (f: in out TR_Fenetre; nomElement : in String;
        x, y : in Natural; largeur, hauteur : in Positive) is
  -- {} => {Ajoute un bouton qui n'est pas visible mais est cliquable à l'écran}
    obj : FL_OBJECT_Access;
  begin
    if getElement(F.PElements, nomElement)=null then
      obj := fl_Add_Button(FL_HIDDEN_BUTTON, FL_Coord(x), FL_Coord(y), FL_Coord(largeur), FL_Coord(hauteur), X11.Strings.new_string(""));
      ajoutElement(F.PElements, roundBouton, nomElement, "", "", obj);
    end if;
  end ajouterBoutonInvisible;

  procedure changerAlignementTexte(f: in out TR_Fenetre; nomElement : in String; alignement : in FL_ALIGN) is
  -- {} => {Change l'alignement d'un texte}
    P : TA_Element;
  begin
    P := GetElement(f.PElements, nomElement);
    fl_set_object_align(P.Pelement, alignement);
  end changerAlignementTexte;

  procedure afficherGrille(fen: in out TR_Fenetre; x, y: in natural) is
  -- {} => {Affiche la grille avec le bord gauche à la position (x, y)}
    textX, textY: natural;
    f: p_cases_io.file_type;
    V: TV_Gaudi(1..16);
  begin
    -- Récupération des informations du carré
    open(f, IN_FILE, "CarreGaudi");
    CreeVectGaudi(f, V);
    triVectGaudi(V);
    close(f);

    -- Affichage d'un fond noir pour la grille
    ajouterTexte(fen, "fond_grille", "", x, y, 400, 400);
    changerCouleurFond(fen, "fond_grille", FL_BLACK);

    for i in V'range loop -- Ajout des boutons de la grille affichant les nombres
      textX := x + 5 + (99 * ((i-1) / 4));
      textY := y + 5 + (99 * ((i-1) mod 4));
      ajouterTexte(fen, V(i).nom, trim(Integer'image(V(i).valeur), BOTH), textX, textY, 92, 92);
      AjouterBoutonInvisible(fen, 'B' & V(i).nom, textX, textY, 92, 92); -- Rend les nombres cliquables, sans voir de bouton
      changerTailleTexte(fen, V(i).nom, FL_HUGE_SIZE);
      changerAlignementTexte(fen, V(i).nom, FL_ALIGN_CENTER);
    end loop;
  end afficherGrille;

  procedure fenetreAccueil is
  -- {} => {affiche la fenêtre d'accueil}
    fenetre : TR_Fenetre;
  begin
    while not fermerFenetre loop
      fenetre := debutFenetre("Accueil", 500, 600);
      for i in 3..7 loop
        ajouterBouton(fenetre, Integer'image(i)(2..2), Integer'image(i)(2..2), 75+(75*(i-3)), 300, 50, 50);
        changerTailleTexte(fenetre, Integer'image(i)(2..2), FL_MEDIUM_SIZE);
        changerStyleTexte(fenetre, Integer'image(i)(2..2), FL_BOLD_STYLE);
      end loop;
      contigue := false;
      nbCasesSolution := 3;
      changerCouleurTexte(fenetre, "3", FL_DOGERBLUE);
      ajouterBouton(fenetre, "jeu", "Jouer au jeu", 35, 430, 200, 50);
      ajouterBouton(fenetre, "Solution", "Afficher Solutions", 265, 430, 200, 50);
      ajouterBouton(fenetre, "Fermer", "Quitter", 200, 580, 100, 50);
      ajouterBouton(fenetre, "Contigue", "Non", 200, 375, 50, 30);
      ajouterBouton(fenetre, "Info", "Informations", 335, 505, 130, 50);
      ajouterBouton(fenetre, "Scoreboard", "Scoreboard", 185, 505, 130, 50);
      ajouterBouton(fenetre, "Online", "En ligne", 35, 505, 130, 50);
      ajouterTexte(fenetre, "TexTContigue : ", "Seulement contigue : ", 50, 375, 150, 30);
      ajouterTexte(fenetre, "Textintro", "Bienvenue dans le programme du carre de Subirachs", 50, 100, 400, 30);
      ajouterTexte(fenetre, "Textintro2", "Sur cet ecran, vous pouvez choisir le nombre d'elements d'une", 50, 130, 400, 30);
      ajouterTexte(fenetre, "Textintro3", "solution, et choisir de ne consulter que les solutions contigues. ", 50, 160, 400, 30);
      ajouterTexte(fenetre, "Textintro4", "Bon jeu ! ", 220, 210, 120, 30);
      changerStyleTexte(fenetre, "Contigue", FL_BOLD_STYLE);
      finFenetre(fenetre);
      montrerFenetre(fenetre);
      appuiBoutonAccueil(attendreBouton(fenetre), fenetre);
    end loop;
  end fenetreAccueil;

  procedure ouvreFenetreSolutions(nomFichier: in string; fenetre: TR_Fenetre) is
  -- {nomFichier représente un fichier existant} => {Ouvre la fenêtre des solutions}
  begin
    open(fichierSolution, IN_FILE, nomFichier);
    nbCombinaisons := nbCombi(fichierSolution, nbCasesSolution);
    reset(fichierSolution, IN_FILE);
    cacherFenetre(fenetre);
    fenetreSolutions;
  end ouvreFenetreSolutions;

  procedure fenetreSolutions is
  -- {} => {Affiche la fenêtre de solutions}
    fenetre : TR_Fenetre;
  begin
    fenetre := debutFenetre("Solutions", 500, 650);
    afficherGrille(fenetre, 50, 50);
    ajouterTexte(fenetre, "Solution", "Solution", 50, 500, 120, 30);
    AjouterChamp(fenetre, "ChampNum", "", "131", 140, 500, 40, 30);
    ajouterTexte(fenetre, "Y", "/ 131", 180, 500, 50, 30);
    ajouterTexte(fenetre, "ZoneSolution", "AXBXCXDXBXCXDX", 250, 500, 200, 30);
    ajouterBouton(fenetre, "prec", "Precedente", 50, 550, 100, 30);
    ajouterBouton(fenetre, "suiv", "Suivante", 350, 550, 100, 30);
    ajouterBouton(fenetre, "retour", "Retour", 200, 600, 100, 30);
    ajouterBouton(fenetre, "aller", "Aller A", 200, 550, 100, 30);
    changerTailleTexte(fenetre, "Solution", FL_MEDIUM_SIZE);
    changerStyleTexte(fenetre, "Solution", FL_BOLD_STYLE);
    changerTailleTexte(fenetre, "ZoneSolution", FL_MEDIUM_SIZE);
    changerStyleTexte(fenetre, "ZoneSolution", FL_BOLD_STYLE);
    changerTailleTexte(fenetre, "ChampNum", FL_MEDIUM_SIZE);
    changerStyleTexte(fenetre, "ChampNum", FL_BOLD_STYLE);
    changerTailleTexte(fenetre, "Y", FL_MEDIUM_SIZE);
    changerStyleTexte(fenetre, "Y", FL_BOLD_STYLE);
    finFenetre(fenetre);
    montrerFenetre(fenetre);
    combinaisonAct := 1;
    actualisationInfos(fenetre, 1);
    appuiBoutonSolution(attendreBouton(fenetre), fenetre);
  end fenetreSolutions;


  procedure fenetreJeu is
  --{} => {Affiche la fenêtre de jeu}
    fenetre : TR_Fenetre;
  begin
    fenetre := debutFenetre("Jeu", 500, 650);
    afficherGrille(fenetre, 50, 100);
    ajouterTexte(fenetre, "Txt1", "Score : ", 50, 50, 120, 30);
    ajouterTexte(fenetre, "Score", "0 Point", 170, 50, 120, 30);
    ajouterTexte(fenetre, "Txt2", "Temps : ", 300, 50, 80, 30);
    ajouterTexte(fenetre, "Timer", Integer'image(Integer(Float'rounding(Float(tempsRestant)))), 380, 50, 80, 30);
    ajouterTexte(fenetre, "erreur", "", 50, 640, 400, 30);
    ajouterChamp(fenetre, "SolutionProp", "", "", 100, 520, 300, 30);
    ajouterBouton(fenetre, "valider", "Valider", 200, 560, 100, 30);
    ajouterBouton(fenetre, "finjeu", "Fin Jeu", 200, 600, 100, 30);
    ajouterBouton(fenetre, "abandon", "Abandonner", 200, 650, 100, 30);
    changerCouleurTexte(fenetre, "erreur", FL_INDIANRED);
    changerStyleTexte(fenetre, "erreur", FL_BOLD_STYLE);
    changerStyleTexte(fenetre, "SolutionProp", FL_BOLD_STYLE);
    changerStyleTexte(fenetre, "valider", FL_BOLD_STYLE);
    changerStyleTexte(fenetre, "finjeu", FL_BOLD_STYLE);
    changerStyleTexte(fenetre, "Txt1", FL_BOLD_STYLE);
    changerStyleTexte(fenetre, "Txt2", FL_BOLD_STYLE);
    changerTailleTexte(fenetre, "Score", FL_MEDIUM_SIZE);
    changerTailleTexte(fenetre, "Timer", FL_MEDIUM_SIZE);
    changerTailleTexte(fenetre, "SolutionProp", FL_MEDIUM_SIZE);
    changerTailleTexte(fenetre, "valider", FL_MEDIUM_SIZE);
    changerTailleTexte(fenetre, "finjeu", FL_MEDIUM_SIZE);
    changerTailleTexte(fenetre, "Txt1", FL_MEDIUM_SIZE);
    changerTailleTexte(fenetre, "Txt2", FL_MEDIUM_SIZE);
    changerTailleTexte(fenetre, "erreur", FL_MEDIUM_SIZE);
    changerAlignementTexte(fenetre, "erreur", FL_ALIGN_CENTER);

    cacherElem(fenetre, "finjeu");

    finFenetre(fenetre);
    montrerFenetre(fenetre);

    if enLigne then
      fenetreDeJeu := fenetre;
      jeuOuvert := true;
    else
      chronoJeu.start(fenetre);
    end if;

    appuiBoutonJeu(attendreBouton(fenetre), fenetre);

  end fenetreJeu;

  procedure fenetreRegles is
  --{} => {Affiche la fenêtre de règles}
    fenetre: TR_Fenetre;
  begin
    fenetre := debutFenetre("Regles", 500, 300);
    ajouterTexte(fenetre, "Text1 : ", "Saisir votre pseudo : ", 50, 50, 150, 30);
    ajouterChamp(fenetre, "pseudo", "", "Pseudo", 200, 50, 160, 30);
    ajouterTexte(fenetre, "Txt2", "Juste", 50, 90, 60, 50);
    ajouterTexte(fenetre, "Txt3", "Double", 50, 150, 60, 50);
    ajouterTexte(fenetre, "Txt4", "Faux", 50, 210, 60, 50);
    ajouterTexte(fenetre, "Regles1", "Bienvenue dans le jeu du carre de Subira", 130, 90, 320, 30);
    ajouterTexte(fenetre, "Regles2", "Vous devez trouver des combinaisons de", 130, 120, 320, 30);
    ajouterTexte(fenetre, "Regles3", "3 a 7 cases ayant une somme egale a 33.", 130, 150, 320, 30);
    ajouterTexte(fenetre, "Regles4", "Votre score augmentera pour chaque combinaison", 130, 180, 330, 30);
    ajouterTexte(fenetre, "Regles5", "trouvee. Vous ne pouvez pas valider deux fois", 130, 210, 320, 30);
    ajouterTexte(fenetre, "Regles6", "la meme combinaison. Bonne chance !", 130, 240, 320, 30);
    ajouterBouton(fenetre, "valider", "Valider", 200, 300, 100, 30);
    changerStyleTexte(fenetre, "Txt2", FL_BOLD_STYLE);
    changerStyleTexte(fenetre, "Txt3", FL_BOLD_STYLE);
    changerStyleTexte(fenetre, "Txt4", FL_BOLD_STYLE);
    changerCouleurFond(fenetre, "Txt2", FL_PALEGREEN);
    changerCouleurFond(fenetre, "Txt3", FL_WHEAT);
    changerCouleurFond(fenetre, "Txt4", FL_INDIANRED);
    finFenetre(fenetre);
    montrerFenetre(fenetre);
    appuiBoutonRegles(attendreBouton(fenetre), fenetre);
  end fenetreRegles;

  procedure fenetreScores is
  --{} => {Affiche la fenêtre des scores}
    fenetre: TR_Fenetre;
    fscore : p_score_io.file_type;
    i : integer;
  begin
    open(fscore, IN_FILE, "score");
    i := 1;
    fenetre := debutFenetre("Scoreboard", 500, 600);
    if nbScores(fscore) > 0 then
      reset(fscore, IN_FILE);
      declare
        VScore : TV_Score(1..nbScores(fscore));
      begin
        reset(fscore, IN_FILE);
        copieFichierScore(fscore, VScore);
        triBullesScores(VScore);
        while  i  <= 10 and i <= VScore'last  loop --On Crée une zone de text par joueur pour les 10prmeir au maximum
          ajouterTexte(fenetre, "Joueurs" & Integer'image(i),  " Joueur : " & VScore(i).pseudo, 50, (50*i), 220, 30);
          ajouterTexte(fenetre, "Score" & Integer'image(i), "Points : " & Integer'image(VScore(i).Score), 270, (50*i), 100, 30);
          i := i+1;
        end loop;
      end;
    else
      ajouterTexte(fenetre, "PasJoueur",  "Il n'y a aucun score pour l'instant.", 50, 50, 350, 30);
    end if;
      close(fscore);
    ajouterBouton(fenetre, "valider", "Valider", 200, 560, 100, 30);
    finFenetre(fenetre);
    montrerFenetre(fenetre);
    if attendreBouton(fenetre) = "valider" then
      cacherFenetre(fenetre);
    end if;
  end fenetreScores;

  procedure fenetreInfo is
  --{} => {Affiche la fenêtre des informations}
    fenetre : TR_Fenetre;
  begin
    fenetre := debutFenetre("informations", 800, 450);
    ajouterBoutonImage(fenetre, "Info", "", 0, 0, 800, 500);
    changerImageBouton(fenetre, "Info", "info.xpm");
    finFenetre(fenetre);
    montrerFenetre(fenetre);
    if attendreBouton(fenetre) /= "00" then
      cacherFenetre(fenetre);
    end if;
  end fenetreInfo;

  procedure fenetreConnexion is
  --{} => {Affiche la fenêtre de connexion}
    fenetre: TR_Fenetre;
    nbEssai : integer := 1;
  begin
    fenetre := debutFenetre("Connexion", 500, 300);

    ajouterTexte(fenetre, "Text1 : ", "Saisir votre pseudo : ", 50, 50, 150, 30);
    ajouterChamp(fenetre, "pseudo", "", "", 200, 50, 160, 30);

    ajouterTexte(fenetre, "Text2 : ", "Adresse serveur : ", 50, 100, 150, 30);
    ajouterChamp(fenetre, "serveur", "", "", 200, 100, 160, 30);

    ajouterTexte(fenetre, "Text3 : ", "Port serveur : ", 50, 150, 150, 30);
    ajouterChamp(fenetre, "port", "", "", 200, 150, 160, 30);

    ajouterTexte(fenetre, "erreur", "", 50, 200, 400, 30);
    changerCouleurTexte(fenetre, "erreur", FL_INDIANRED);
    changerStyleTexte(fenetre, "erreur", FL_BOLD_STYLE);

    ajouterBouton(fenetre, "valider", "Valider", 200, 300, 100, 30);
    finFenetre(fenetre);
    montrerFenetre(fenetre);

    loop
      loop
        declare
          nomBouton : string := attendreBouton(fenetre);
          pseudo : string := consulterContenu(fenetre, "pseudo");
          adresse : string := consulterContenu(fenetre, "serveur");
          port : string := consulterContenu(fenetre, "port");
        begin
          if pseudo'length > 20 then
            changerContenu(fenetre, "pseudo", "");
          elsif port'length > 5 then
            changerContenu(fenetre, "port", "");
          elsif pseudo'length = 0 or adresse'length = 0 or port'length = 0 then null;
          else
            pseudoClient := (others => ' ');
            pseudoClient(1..pseudo'length) := pseudo;
            exit;
          end if;
        end;
      end loop;

      if est_connecte then
        statutErreur := -1;
        if not envoyerMessage(channel, creerMessageStatut(trim(pseudoClient, BOTH), SEND_NAME)) then
          cacherFenetre(fenetre);
          return;
        end if;
      end if;

      while (nbEssai <= 10 and not est_connecte)
              and then not connexion(consulterContenu(fenetre, "serveur"), Integer'value(consulterContenu(fenetre, "port"))) loop
        nbEssai := nbEssai + 1;
        if nbEssai = 10 then
          cacherFenetre(fenetre);
          return;
        end if;
      end loop;

      while statutErreur = -1 and not authenth loop
        delay 0.1;
      end loop;

      if statutErreur = PSEUDO_INCORRECT then
          changerTexte(fenetre, "erreur", "Le pseudo est incorrect.");
      end if;

      exit when statutErreur = -1;
    end loop;

    cacherFenetre(fenetre);
    enLigne := true;
    fenetreJeu;
  end fenetreConnexion;

  procedure appuiBoutonAccueil (elem : in string; fenetre : in out TR_Fenetre) is
  -- {} => {Traite l'appui d'un bouton sur la fenêtre d'accueil}
  begin
    if elem in "3" | "4" | "5" | "6" | "7" then -- choix de la taille des solutions à afficher
      for i in 3..7 loop
          changerCouleurTexte(fenetre, Integer'image(i)(2..2), FL_BLACK);
      end loop;
      changerCouleurTexte(fenetre, elem, FL_DOGERBLUE);
      nbCasesSolution := Integer'value(elem);
      appuiBoutonAccueil(attendreBouton(fenetre), fenetre);
    elsif elem = "Contigue" then -- choix d'afficher des solutions contigües ou non
      if contigue then
        contigue := false;
        changerTexte(fenetre, "Contigue", "Non");
        changerCouleurTexte(fenetre, "Contigue", FL_BLACK);
      else
        contigue := true;
        changerTexte(fenetre, "Contigue", "Oui");
        changerCouleurTexte(fenetre, "Contigue", FL_DOGERBLUE);
      end if;
      appuiBoutonAccueil(attendreBouton(fenetre), fenetre);
    elsif elem = "Solution" then -- ouvre la fenêtre des solutions
      if contigue then
        ouvreFenetreSolutions("foutcont.txt", fenetre);
      else
        ouvreFenetreSolutions("fout.txt", fenetre);
      end if;
    elsif elem = "jeu" then -- ouvre la fenêtre de jeu
      cacherFenetre(fenetre);
      casesClic := (others => ' ');
      fenetreRegles;
      enLigne := false;
      debutJeu(contigue, 60.0);
      fenetreJeu;
    elsif elem = "Fermer" then -- ferme le programme
      fermerFenetre := true;
      cacherFenetre(fenetre);
      chrono.fermer;
      chronoJeu.fermer;
    elsif elem = "Scoreboard" then -- ouvre la fenêtre des scores
      cacherFenetre(fenetre);
      fenetreScores;
    elsif elem = "Online" then -- ouvre la fenêtre de connexion
      cacherFenetre(fenetre);
      casesClic := (others => ' ');
      fenetreConnexion;
    elsif elem = "Info" then -- ouvre la fenêtre des infos
      cacherFenetre(fenetre);
      fenetreInfo;
    else
      appuiBoutonAccueil(attendreBouton(fenetre), fenetre); -- l'action est invalide, on attend une nouvelle action valide
    end if;
  end appuiBoutonAccueil;

  procedure appuiBoutonSolution (elem : in string; fenetre : in out TR_Fenetre) is
  -- {} => {Traite l'appui d'un bouton sur la fenêtre affichant les solutions}
    combinaisonVoulue : integer;
    combinaisonOld : integer;
  begin
    if elem = "prec" then -- affichage de la solution précédente
      if combinaisonAct = 1 then
        appuiBoutonSolution(attendreBouton(fenetre), fenetre);
      else
        combinaisonAct := combinaisonAct - 1;
        actualisationInfos(fenetre, combinaisonAct + 1);
        appuiBoutonSolution(attendreBouton(fenetre), fenetre);
      end if;
    elsif elem = "suiv" then -- affichage de la solution suivante
      if combinaisonAct = nbCombinaisons then
        appuiBoutonSolution(attendreBouton(fenetre), fenetre);
      else
        combinaisonAct := combinaisonAct + 1;
        actualisationInfos(fenetre, combinaisonAct - 1);
        appuiBoutonSolution(attendreBouton(fenetre), fenetre);
      end if;
    elsif elem = "retour" then -- retour à l'accueil
      cacherFenetre(fenetre);
      close(fichierSolution);
    elsif elem = "aller" or elem = "ChampNum" then -- saut à une solution via son numéro
      begin
        combinaisonVoulue := Integer'value(ConsulterContenu(fenetre, "ChampNum"));
        combinaisonOld := combinaisonAct;
        if combinaisonVoulue > nbCombinaisons or combinaisonVoulue < 1 then
          actualisationInfos(fenetre, combinaisonAct);
          appuiBoutonSolution(attendreBouton(fenetre), fenetre);
        else
          combinaisonAct := combinaisonVoulue;
          actualisationInfos(fenetre, combinaisonOld);
          appuiBoutonSolution(attendreBouton(fenetre), fenetre);
        end if;
      exception
        when others =>
          actualisationInfos(fenetre, combinaisonAct);
          appuiBoutonSolution(attendreBouton(fenetre), fenetre);
      end;
    else
      appuiBoutonSolution(attendreBouton(fenetre), fenetre);
    end if;
  end appuiBoutonSolution;

  procedure appuiBoutonRegles (elem : in string; fenetre : in out TR_Fenetre) is
  -- {} => {Traite l'appui d'un bouton sur la fenêtre affichant les règles}
  begin
    if elem = "pseudo" or elem = "valider" then -- choix du pseudo
      begin
        if ConsulterContenu(fenetre, "pseudo") /= "Pseudo" then
          pseudo := (others => ' ');
          pseudo(ConsulterContenu(fenetre, "pseudo")'range) := ConsulterContenu(fenetre, "pseudo");
          cacherFenetre(fenetre);
        else
          appuiBoutonRegles(attendreBouton(fenetre), fenetre);
        end if;
      exception
        when others =>
          changerContenu(fenetre, "pseudo", "Pseudo");
          appuiBoutonRegles(attendreBouton(fenetre), fenetre);
      end;
    else
      appuiBoutonRegles(attendreBouton(fenetre), fenetre);
    end if;
  end appuiBoutonRegles;

  function ajoutCase(coord: in string) return boolean is
  -- {} => {Traite le clic sur une case dans le jeu}
    i : integer := 1;
    j : integer;
  begin
    -- On parcourt le vecteur d'éléments cliqués jusqu'à trouver l'élément recherché ou un espace libre (caractère espace)
    while i < casesClic'last and then (casesClic(i) /= ' ' and casesClic(i..i+1) /= coord) loop
      i := i + 2;
    end loop;
    if i >= casesClic'last then return false; end if; -- Si on est à la fin du string, on a déjà sélectionné 7 cases (maximum)
    if casesClic(i) = ' ' then -- On insère la nouvelle case
      casesClic(i..i+1) := coord;
      return true;
    else -- La case est déjà présente, on la retire et on replace la suite pour ne pas avoir de vide
      casesClic(i..i+1) := "  ";
      j := i+2;
      while j < casesClic'last and then casesClic(j) /= ' ' loop
        j := j + 1;
      end loop;
      if j /= i+2 then
        casesClic(i..j-2) := casesClic(i+2..j);
        casesClic(j-1..j) := "  ";
      end if;
      return false;
    end if;
  end ajoutCase;

  procedure appuiBoutonJeu (elem : in string; fenetre : in out TR_Fenetre) is
  -- {} => {Traite l'appui d'un bouton sur la fenêtre de jeu}
    solutionCorrecte : integer;
    caseClic : string(1..2);
  begin --
    if jeuEnCours then -- Si le jeu est en cours
      if elem = "SolutionProp" or elem = "valider" then -- Validation d'une solution
        declare
          solution : string := trim(consulterContenu(fenetre, "SolutionProp") & casesClic, BOTH);
        begin
          changerContenu(fenetre, "SolutionProp", "");
          if enLigne then
            if solution'length <= 14 and solution'length >= 6 then
              if not envoyerMessage(channel, creerMessageStatut(solution, SOLUTION_ESSAI)) then
                changerTexte(fenetre, "erreur", "La communication avec le serveur a ete interrompue");
                deconnexion;
              end if;
              appuiBoutonJeu(attendreBouton(fenetre), fenetre);
            else
              appuiBoutonJeu(attendreBouton(fenetre), fenetre);
            end if;
          else
            effacerGrille(fenetre); -- On efface la dernière solution colorée
            verifSol(solution, solutionCorrecte); -- On vérifie la validité de la solution (entrée clavier + boutons validés)
            actualisationEssai(fenetre, solution, solutionCorrecte); -- On met en avant la solution, ou on réaffiche l'ancienne solution si l'actuelle est invalide
            appuiBoutonJeu(attendreBouton(fenetre), fenetre);
          end if;
        end;
      elsif elem = "abandon" then -- Fin prématurée du jeu
        if enLigne then
          deconnexion;
          chronoJeu.stop;
          chrono.stop;
          cacherFenetre(fenetre);
          jeuOuvert := false;
        else
          chronoJeu.stop;
          finJeu(true);
          cacherFenetre(fenetre);
        end if;
      elsif elem'length = 3 -- Appui sur un bouton de la grille BXX, avec XX la valeur de la case
            and elem(elem'first) = 'B'
            and elem(elem'first + 1) in T_Col'range
            and Integer'value(elem(elem'first + 2..elem'first + 2)) in T_Lig'range then
        caseClic := elem(elem'first + 1..elem'first + 2);
        if ajoutCase(caseClic) then
          affichageSol(fenetre, caseClic, FL_DARKCYAN);
        else
          affichageSol(fenetre, caseClic, FL_COL1);
        end if;
        appuiBoutonJeu(attendreBouton(fenetre), fenetre);
      else
        appuiBoutonJeu(attendreBouton(fenetre), fenetre);
      end if;
    elsif elem = "finjeu" then -- Le jeu n'est pas en cours et on appuie sur "Fin jeu"
      cacherFenetre(fenetre);
      if enLigne then
        jeuOuvert := false;
        chronoJeu.stop;
      end if;
    else -- Action invalide
      appuiBoutonJeu(attendreBouton(fenetre), fenetre);
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
    ChangerContenu(fen, "ChampNum", trim(Integer'image(combinaisonAct), BOTH));
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

  procedure effacerGrille(fen: in out TR_Fenetre) is
  -- {} => {Les solutions affichées sur la grille sont effacées}
  begin
    if tailleSolution > 0 then
      affichageSol(fen, dernier(1..tailleSolution), FL_COL1);
    end if;

    if casesClic(1) /= ' ' then
      affichageSol(fen, trim(casesClic, BOTH), FL_COL1);
    end if;
  end effacerGrille;

  procedure actualisationEssai(fen: in out TR_Fenetre; solution: in string; resultat: in integer) is
  -- {} => {Met à jour la grille avec la solution colorée après un essai dans le jeu}
    coul: FL_Color;
    pts: integer;
    combinaison : string(1..14) := (others => ' ');
  begin
    if solution'length <= combinaison'length then -- On vérifie la taille de la solution
      combinaison(1..solution'length) := to_upper(solution);
    end if;

    case resultat is
      when SOLUTION_CORRECTE => coul := FL_PALEGREEN;
      when SOLUTION_DOUBLON => coul := FL_WHEAT;
      when SOLUTION_INCORRECTE => coul := FL_INDIANRED;
      when SOLUTION_INVALIDE =>
        coul := ancienneCoul;
        combinaison := (others => ' ');
        combinaison(1..tailleSolution) := dernier(1..tailleSolution); -- On reprend l'ancienne solution valide
      when others => null;
    end case;
    ancienneCoul := coul;

    affichageSol(fen, trim(combinaison, BOTH), coul);
    changerContenu(fen, "SolutionProp", "");
    if not enLigne then
      pts := compterPoints;
      changerTexte(fen, "Score", trim(Integer'image(pts), BOTH) & (if pts >= 2 then " Points" else " Point"));
    elsif resultat /= SOLUTION_INVALIDE then
      dernier := (others => ' ');
      dernier := combinaison;
      tailleSolution := solution'length;
    end if;

    casesClic := (others => ' '); -- On retire toutes les cases cliquées
  end actualisationEssai;

end p_vue_graph;
