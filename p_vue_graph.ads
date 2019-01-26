with p_fenbase, p_combinaisons, text_io, Forms;
use  p_fenbase, p_combinaisons, text_io, Forms;

package p_vue_graph is

  task type T_ActualisationJeu is
    entry start(fenetre: in out TR_Fenetre);
    entry fermer;
    entry stop;
  end T_ActualisationJeu;

  nbCasesSolution : integer;
  nbCombinaisons : integer;
  fichierSolution : text_io.file_type;
  combinaisonAct : integer;
  contigue : boolean;

  casesClic: string(1..14);
  ancienneCoul: FL_Color := FL_COL1;
  chronoJeu: T_ActualisationJeu;

  procedure ajouterBoutonInvisible (f: in out TR_Fenetre; nomElement : in String;
        x, y : in Natural; largeur, hauteur : in Positive);
  -- {} => {Ajoute un bouton qui n'est pas visible mais est cliquable à l'écran}

  procedure changerAlignementTexte(f: in out TR_Fenetre; nomElement : in String; alignement : in FL_ALIGN);
  -- {} => {Change l'alignement d'un texte}

  procedure afficherGrille(fen: in out TR_Fenetre; x,y: in natural);
  -- {} => {Affiche la grille avec le bord gauche à la position (x,y)}

  procedure fenetreAccueil;
  --{} => {Affiche la fenêtre d'accueil}

  procedure fenetreSolutions;
  --{} => {Affiche la fenêtre de solutions}

  procedure fenetreJeu;
  --{} => {Affiche la fenêtre de jeu}

  procedure fenetreRegles;
  --{} => {Affiche la fenêtre de règles}

  procedure fenetreScores;
  --{} => {Affiche la fenêtre des scores}

  procedure fenetreInfo;
  --{} => {Affiche la fenêtre des informations}

  procedure fenetreConnexion;
  --{} => {Affiche la fenêtre de connexion}

  procedure appuiBoutonAccueil (elem : in string; fenetre : in out TR_Fenetre);
  -- {} => {Traite l'appui d'un bouton sur la fenêtre d'accueil}

  procedure appuiBoutonSolution (elem : in string; fenetre : in out TR_Fenetre);
  -- {} => {Traite l'appui d'un bouton sur la fenêtre affichant les solutions}

  procedure appuiBoutonRegles (elem : in string; fenetre : in out TR_Fenetre);
  -- {} => {Traite l'appui d'un bouton sur la fenêtre affichant les règles}

  procedure appuiBoutonJeu (elem : in string; fenetre : in out TR_Fenetre);
  -- {} => {Traite l'appui d'un bouton sur la fenêtre de jeu}

  procedure actualisationInfos(fen: in out TR_Fenetre; combinaisonOld: integer);
  -- {} => {Actualisation des informations pour la solution nbSol}

  procedure affichageSol(fen: in out TR_Fenetre; combinaison: in string; coul: in FL_Color);
  -- {} => {Actualisation de la grille avec la solution de couleur coul}

  procedure effacerGrille(fen: in out TR_Fenetre);
  -- {} => {Les solutions affichées sur la grille sont effacées}

  procedure actualisationEssai(fen: in out TR_Fenetre; solution: in string; resultat: in integer);
  -- {} => {Met à jour la grille avec la solution colorée après un essai dans le jeu}

end p_vue_graph;
