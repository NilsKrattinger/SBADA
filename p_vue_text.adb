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
    put(COLONNE);
    if ind not in V'range then
      for i in 1..TAILLE loop
        put(' ');
      end loop;
    else
      for i in 1..TAILLE/2 loop
        put(' ');
        nbchar := nbchar + 1;
      end loop;

      put(V(ind).valeur, 1);
      nbchar := nbchar + (if V(ind).valeur >= 10 then 2 else 1);

      while nbchar < TAILLE loop
        put(' ');
        nbchar := nbchar + 1;
      end loop;
    end if;
  end afficheValeur;

  procedure afficheGrille(V : TV_Gaudi; S: String) is
  -- {V'length = 16} => {La grille est affichée dans la console}
    function valeurCorrecte(i,j: integer) return boolean is
      currCase : string(1..2);
      ind : integer := 1;
    begin
      if S'length = 0 then return true; end if;
      case j is
        when 1 => currCase(1) := 'A';
        when 2 => currCase(1) := 'B';
        when 3 => currCase(1) := 'C';
        when 4 => currCase(1) := 'D';
        when others => null;
      end case;
      currCase(2) := Integer'image(i)(2);

      while ind <= S'length/2 and then S(ind*2-1..ind*2) /= currCase loop
        ind := ind + 1;
      end loop;
      return ind <= S'length / 2;
    end valeurCorrecte;
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
      afficheLigne(ANGLE, LIGNE);
      afficheLigne(COLONNE, ' '); afficheLigne(COLONNE, ' ');

      put(i, 1);
      for j in 0..3 loop -- Affichage ligne avec valeurs
        if valeurCorrecte(i,j+1) then
          afficheValeur(V, j * 4 + i);
        else
          afficheValeur(V, V'first-1);
        end if;
      end loop;
      put(COLONNE); new_line;

      afficheLigne(COLONNE, ' '); afficheLigne(COLONNE, ' ');
    end loop;
    afficheLigne(ANGLE, LIGNE);
  end afficheGrille;


  procedure afficheSolution (nb : in integer; fsol : in out text_io.file_type) is
  --{fsol ouvert} => {Les solution de fsol à nb elements sont affichées}
    nbChar, nbSol : integer;
    tmp : string(1..15);
    categorie : boolean := true;
    i : integer := 0;
  begin
    reset(fsol, IN_FILE);
    nbsol := (nbCombi(fsol, nb));
    put(" * "); put(nbSol, 1); put(" solutions en" & Integer'image(nb) & " cases");
    new_line;
    put("--------------------------");
    new_line;

    skip_line(fsol);
    while not end_of_file(fsol) and Categorie loop
      get_line(fsol, tmp, nbChar);
      if tmp(1) in T_col'range then
        i := i + 1;
        put("solution" & Integer'image(i) & '/' & Integer'image(nbSol) & " : ");
        for j in 1..nbChar/2  loop
          put(tmp(j*2-1)&tmp(j*2));
          if j*2 /= nbChar then
            put(',');
          end if;
        end loop;
        new_line;
      else
        categorie := false;
      end if;
    end loop;
  end afficheSolution;
end p_vue_text;
