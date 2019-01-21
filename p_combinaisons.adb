with sequential_IO;
with text_io; use text_io;


package body p_combinaisons is

  ---- Recherche et affichage des combinaisons --------------------------------------------------------------------

	procedure CreeVectGaudi(f : in out p_cases_IO.file_type; V : out TV_Gaudi) is
	-- {f ouvert, V de taille suffisante} => {le contenu de f a été copié dans V}
		i : integer;
		tmp : TR_Case;
		begin
			reset(f, IN_FILE);
			i := V'first;
			while not end_of_file(f) loop
				read(f,tmp);
				V(i) := tmp;
				i := i+1;
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

	procedure trouveSol(V : in TV_Gaudi; Vcompte : in out TV_Ent) is
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
		Vcompte := (others => 0);
		for i in 3..7 loop
			declare
				Vind : TV_Ent(0..i-1);
				g : text_io.file_type;
				ind : integer;
				termine : boolean := false;
			begin
				create(g, OUT_FILE, "resultat" & Integer'image(i)(2));

				for j in Vind'range loop -- initialisation d'un sous-vecteur d'indices de V
					Vind(j) := V'first+j;
				end loop;
				loop
					if somme(V, Vind) = 33 then
						Vcompte(i) := Vcompte(i) + 1;
						for j in Vind'range loop
							put(g, V(Vind(j)).nom);
						end loop;
						new_line(g);
					end if;

					Vind(Vind'last) := Vind(Vind'last) + 1;
					ind := Vind'last;
					while ind >= Vind'first and not termine loop
						if Vind(ind) >= V'last + 1 - (Vind'last - ind) then
							if ind = Vind'first then
								termine := true;
							else
								Vind(ind-1) := Vind(ind-1) + 1;
								for k in ind..Vind'last loop
									Vind(k) := Vind(k-1) + 1;
								end loop;
							end if;
						end if;
						ind := ind - 1;
					end loop;
					exit when termine;
				end loop;

				close(g);
			end;
		end loop;
	end trouveSol;

	procedure creeFicsol(V : in TV_Gaudi; fsol : in out text_io.file_type) is
	-- {f ouvert en écriture, V Trié par nom de case}
	--	=> 	{fsol contient toutes les combinaisons gagnantes et est structuré selon le format défini (cf. sujet)}
		Vcompte : TV_Ent(3..7);
		sol : string(1..15);
		nb: integer;

		g : text_io.file_type;
	begin
		reset(fsol, OUT_FILE);
		trouveSol(V, Vcompte);
		for i in 3..7 loop
			put(fsol, i, 1);
			put(fsol, ' ');
			put(fsol, Vcompte(i), 1);
			new_line(fsol);
			open(g, IN_FILE, "resultat" & Integer'image(i)(2));
			while not end_of_file(g) loop
				get_line(g, sol, nb);
				put_line(fsol, sol(1..nb));
			end loop;
			delete(g);
			new_page(fsol);
		end loop;
	end creeFicsol;

	function nbCombi(fsol : in text_io.file_type; nbcases : in T_nbcases) return natural is
	-- {fsol ouvert, f- = <>} => {résultat = nombre de combinaisons en nbcases dans fsol}
		nbSkip : integer := nbcases - 3;
		val : integer;
	begin
		while nbSkip > 0 loop
			skip_page(fsol);
			nbSkip := nbSkip - 1;
		end loop;

		get(fsol, val);
		get(fsol, val);
		return val;
	end nbCombi;

	function combi(fsol : in text_io.file_type; nbcases : in T_nbcases; numsol : in positive) return string is
	-- {fsol ouvert, f- = <>}
	-- => {résultat = chaîne représentant la solution numsol lue dans fsol pour une combinaison de nbcases}
		nbSkip : integer := nbcases - 3;
		val, nb : integer;
		str : string(1..14);
	begin
		while nbSkip > 0 loop
			skip_page(fsol);
			nbSkip := nbSkip - 1;
		end loop;

		get(fsol, val);
		get(fsol, val);

		if numsol > val then
			return "Pas de sol n°" & Integer'image(numsol);
		else
			nbSkip := numsol;
			while nbSkip > 0 loop
				skip_line(fsol);
				nbSkip := nbSkip - 1;
			end loop;
			get_line(fsol, str, nb);
			return str(1..nb);
		end if;

	end combi;

	function est_contigue(sol : in string) return boolean is
	--{sol représente une solution} => {résultat = vrai si sol est une solution contigüe}
		nbelems: constant integer := sol'length/2;
		contig: array(1..nbelems) of boolean;

		function verifContig(C1, C2: in string) return boolean is
			L1, L2: character;
			N1, N2: character;
		begin
			L1 := C1(1); N1 := C1(2);
			L2 := C2(1); N2 := C2(2);

			return (L1 = L2 or L1 = Character'pred(L2) or L1 = Character'succ(L2)) and
					(N1 = N2 or N1 = N2 - 1 or N1 = N2 + 1);
		end verifContig;

		result : boolean := true;
	begin
		contig := (others => false);
		for i in 1..nbelems loop
			if not contig(i) then
				for j in i+1..nbelems loop
					if verifContig(sol(i..i+1), sol(j..j+1)) then
						contig(i) := true;
						contig(j) := true;
					end if;
				end loop;
			end if;
		end loop;

		for i in contig loop
			if not contig(i) then
				result := false;
			end if;
		end loop;
		return result;
	end est_contigue;

	--procedure creeFicsolcont(fsol, fcont : in out text_io.file_type) ;
	-- {fsol ouvert} => {fcont contient les combinaisons contigües de fsol et est structuré de la même façon}

end p_combinaisons;
