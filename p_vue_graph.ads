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

  procedure AjouterBoutonInvisible (F : in out TR_Fenetre; NomElement : in String; X, Y : in Natural; Largeur, Hauteur : in Positive);

  procedure fenetreRegles ;

  procedure appuiBoutonRegles (Elem : in string; fenetre : in out TR_Fenetre);
  --{} => {Affiche la fenetre d'Accueil}

  procedure afficherGrille(fen: in out TR_Fenetre; x,y: in natural);
  -- {} => {Affiche la grille avec le bord gauche à la position (x,y)}

  procedure fenetreaccueil;
  --{} => {Affiche la fenetre d'Accueil}

  procedure appuiBoutonAccueil (Elem : in string; fenetre : in out TR_Fenetre);
  --{} => {Affiche la fenetre Solutions}

  procedure appuiBoutonSolution (Elem : in string; fenetre : in out TR_Fenetre);

  procedure appuiBoutonJeu (Elem : in string; fenetre : in out TR_Fenetre);

  procedure actualisationInfos(fen: in out TR_Fenetre; combinaisonOld: integer);
  -- {} => {Actualisation des informations pour la solution nbSol}

  procedure affichageSol(fen: in out TR_Fenetre; combinaison: in string; coul: in FL_Color);
  -- {} => {Actualisation de la grille avec la solution de couleur coul}

  procedure effacerGrille(fen: in out TR_Fenetre);
  -- {} => {Les solutions affichées sur la grille sont effacées}

  procedure actualisationEssai(fen: in out TR_Fenetre; solution: in string; resultat: in integer);
  -- {} => {Met à jour la grille avec la solution colorée après un essai dans le jeu}

end p_vue_graph;
