with text_io, p_combinaisons;
use text_io, p_combinaisons, p_combinaisons.p_int_io;

package body p_vue_text is

  procedure afficheLigne(carAngle,carLigne: in character) is
  -- {} => {Une nouvelle ligne de la grille est affichée}
  begin
    for i in 1..4 loop
      put(carAngle);
      for i in 1..taille loop
        put(carLigne);
      end loop;
    end loop;
    put(carAngle);
    new_line;
  end afficheLigne;

  procedure afficheValeur(V : in TV_Gaudi; ind : in integer) is
  -- {} => {La valeur à l'indice ind a été affichée avec sa bordure gauche}
    nbchar : integer := 0;
  begin
    put(colonne);
    for i in 1..taille/2 loop
      put(' ');
      nbchar := nbchar + 1;
    end loop;

    put(V(ind).valeur, 1);
    nbchar := nbchar + (if V(ind).valeur >= 10 then 2 else 1);

    while nbchar < taille loop
      put(' ');
      nbchar := nbchar + 1;
    end loop;
  end afficheValeur;

  procedure afficheGrille(V : TV_Gaudi) is
  -- {V'length = 16} => {La grille est affichée dans la console}
  begin
    for i in 0..3 loop
      afficheLigne(angle, ligne);
      afficheLigne(colonne, ' '); afficheLigne(colonne, ' ');

      for j in 1..4 loop -- Affichage ligne avec valeurs
        afficheValeur(V, i * 4 + j);
      end loop;
      put(colonne); new_line;

      afficheLigne(colonne, ' '); afficheLigne(colonne, ' ');
    end loop;
    afficheLigne(angle, ligne);
  end afficheGrille;


end p_vue_text;
