with text_io; use text_io;
with p_combinaisons; use p_combinaisons;


package p_vue_text is
  angle : constant character := '+';
  ligne : constant character := '-';
  colonne : constant character := '|';
  taille : constant integer := 5;

  procedure afficheLigne(carAngle,carLigne: in character);
  -- {} => {Une nouvelle ligne de la grille est affichée}

  procedure afficheValeur(V : in TV_Gaudi; ind : in integer);
  -- {} => {La valeur à l'indice ind a été affichée avec sa bordure gauche}

  procedure afficheGrille(V : TV_Gaudi);
  -- {V'length = 16} => {La grille est affichée dans la console}

  procedure afficheSolution(nb : in integer; fsol : in out text_io.file_type);
  --{fsol ouvert } => {Les solution de fsol a Nb elements sont affichées}

end p_vue_text;
