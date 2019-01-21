with text_io, p_combinaisons;
use text_io, p_combinaisons, p_combinaisons.p_int_io;

package body p_vue_text is

  procedure afficheLigne(carAngle,carLigne: in character) is
  -- {} => {Une nouvelle ligne de la grille est affichée}
  begin
    put(' ');
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
    put(' ');
    for c in character range 'A'..'D' loop
      for i in 1..3 loop
        put(' ');
      end loop;
      put(c);
      for i in 1..2 loop
        put(' ');
      end loop;
    end loop;
    new_line;

    for i in 1..4 loop
      afficheLigne(angle, ligne);
      afficheLigne(colonne, ' '); afficheLigne(colonne, ' ');

      put(i, 1);
      for j in 0..3 loop -- Affichage ligne avec valeurs
        afficheValeur(V, j * 4 + i);
      end loop;
      put(colonne); new_line;

      afficheLigne(colonne, ' '); afficheLigne(colonne, ' ');
    end loop;
    afficheLigne(angle, ligne);
  end afficheGrille;


  procedure afficheSolution (nb : in integer; fsol : in out text_io.file_type) is
  --{fsol ouvert } => {Les solution de fsol a Nb elements sont affichées}
    Nbchar,nbsol : integer;
    tmp : string(1..15);
    Categorie : boolean := true;
    i : integer := 0;
  begin
    reset(fsol, IN_FILE);
    nbsol := (nbCombi(fsol,nb));
    put(" * "); put(nbsol,1); put(" solutions en" & integer'image(nb)& " cases");
    new_line;
    put("--------------------------");
    new_line;

    skip_line(fsol);
    while not end_of_file(fsol) and Categorie loop
      get_line(fsol,tmp,Nbchar);
      if tmp(1) in T_col'range then
        i := i + 1;
        put("solution" & integer'image(i) & '/' & integer'image(nbsol) & " : ");
        for j in 1..Nbchar/2  loop
          put(tmp(j*2-1)&tmp(j*2));
          if j*2 /= Nbchar then
            put(',');
          end if;
        end loop;
        new_line;
      else
        Categorie := false;
      end if;
    end loop;
  end afficheSolution;


end p_vue_text;
