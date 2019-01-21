with sequential_IO;
with text_io; use text_io;


package body p_combinaisons is

  ---- Recherche et affichage des combinaisons --------------------------------------------------------------------

	procedure CreeVectGaudi(f : in out p_cases_IO.file_type; V : out TV_Gaudi) is
	-- {f ouvert, V de taille suffisante} => {le contenu de f a été copié dans V}
		i : integer;
		tmp := TR_Case;
		begin
			reset(f, IN_FILE);
			i := 0;
			while not end_of_file(f) loop
				read(f,Tmp)
				v(i) := Tmp
				i := i+1
			end loop;

	end CreeVectGaudi;

  procedure triVectGaudi(V : in out TV_Gaudi) is
  -- {} => {V trié par nom de case}
    procedure permut(a, b: in out TR_Case) is
    -- {} => {les valeurs de a et b ont été échangées}
      temp: TR_Case;
    begin
      temp := a;
      a := b;
      b := temp;
    end permut;

    i : integer := V'first;
    permutation: boolean := true;

  begin
    while permutation loop
      permutation := false;
      for j in reverse i+1..V'last loop
        if V(j).nom < V(j-1).nom then
          permut(V(j), V(j-1));
          permutation := true;
        end if;
      end loop;
      i := i+1;
    end loop;
  end triVectGaudi;

	procedure trouveSol(V : in TV_Gaudi) is
		-- {} => {trouve les solutions et les stocke dans des fichiers temporaires}

		function somme(V : in TV_Gaudi; Vind : in TV_Ent) return integer is
		-- {Vind contient des indices présents dans V}
		-- => {résultat = somme des éléments de V aux indices contenus dans Vind}
			resultat : integer := 0;
		begin
			for i in Vind'range loop
				resultat := resultat + V(Vind(i)).valeur;
			end loop;
			return resultat;
		end somme;

	begin
		for i in 3..7 loop
			declare
				Vind : TV_Ent(0..i-1);
				f : text_io.file_type;
			begin
				create(f, OUT_FILE, "resultat" & Integer'image(i)(2));

				for j in Vind loop -- initialisation d'un sous-vecteur d'indices de V
					Vind(j) := V'first+j;
				end loop;

				loop
					if somme(V, Vind) = 33 then
						write(f, V(Vind).nom) -- ajouter boucle pour prendre tous les noms 
					end if;
				end loop;

				close(f);
			end;
		end loop;
	end trouveSol;

	procedure creeFicsol(V : in TV_Gaudi; fsol : in out text_io.file_type) is
	-- {f ouvert en écriture, V Trié par nom de case}
	--	=> 	{fsol contient toutes les combinaisons gagnantes et est structuré selon le format défini (cf. sujet)}
	begin
	end creeFicsol;

	function nbCombi(fsol : in text_io.file_type; nbcases : in T_nbcases) return natural;
	-- {fsol ouvert, f- = <>} => {résultat = nombre de combinaisons en nbcases dans fsol}

	function combi(fsol : in text_io.file_type; nbcases : in T_nbcases; numsol : in positive) return string;
	-- {fsol ouvert, f- = <>}
	-- => {résultat = chaîne représentant la solution numsol lue dans fsol pour une combinaison de nbcases}

	function est_contigue(sol : in string) return boolean;
		--{sol représente une solution} => {résultat = vrai si sol est une solution contigüe}

	procedure creeFicsolcont(fsol, fcont : in out text_io.file_type) ;
	-- {fsol ouvert} => {fcont contient les combinaisons contigües de fsol et est structuré de la même façon}

end p_combinaisons;
