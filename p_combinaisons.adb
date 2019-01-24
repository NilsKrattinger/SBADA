with sequential_IO, p_jeu;
with text_io; use text_io, p_jeu, p_jeu.p_score_io;


package body p_combinaisons is

  ---- Recherche et affichage des combinaisons --------------------------------------------------------------------

	procedure CreeVectGaudi(f : in out p_cases_IO.file_type; V : out TV_Gaudi) is
	-- {f ouvert, V de taille suffisante} => {le contenu de f a été copié dans V}
		i : integer;
		tmp : TR_Case;
		begin
			reset(f, IN_FILE);
			i := V'first;
			while not end_of_file(f) loop  --On écrit chauque élément de F dans V
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
			for i in Vind'range loop --on parcourt Vind
				resultat := resultat + V(Vind(i)).valeur;  --on somme les éléments de v d'indice vind(i)
			end loop;
			return resultat;
		end somme;


	begin
		Vcompte := (others => 0);
		for i in 3..7 loop
			declare
				Vind : TV_Ent(0..i-1); -- Déclaration d'un vecteur de i cases qui stocke les indices
				g : text_io.file_type;
				ind : integer;
				termine : boolean := false;
			begin
				create(g, OUT_FILE, "resultat" & Integer'image(i)(2)); --Création d'un fichier de solutions pour i cases

				for j in Vind'range loop -- initialisation d'un sous-vecteur d'indices de V
					Vind(j) := V'first+j;
				end loop;


				loop
					if somme(V, Vind) = 33 then  --Si la somme = 33 on écrit notre vecteur d'indices dans notre fichier de solutions
						Vcompte(i) := Vcompte(i) + 1;
						for j in Vind'range loop
							put(g, V(Vind(j)).nom);
						end loop;
						new_line(g);
					end if;

					Vind(Vind'last) := Vind(Vind'last) + 1;  --On incrémente le vecteur d'indices
					ind := Vind'last;
					while ind >= Vind'first and not termine loop -- on vérifie la validité de tous les indices, de droite à gauche
						if Vind(ind) >= V'last + 1 - (Vind'last - ind) then -- condition de validité d'un indice
							if ind = Vind'first then
								termine := true;  -- si le dernier indice est à la position vect'last - indice alors on a fini
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
		while nbSkip > 0 loop  -- comme nous avons 1 page pa X cases
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

	function verifContig(C1, C2: in string) return boolean is
	-- {C1'length = C2'length = 2} => {résultat = vrai si les cases C1 et C2 sont contigües}
		L1, L2: character;
		N1, N2: character;
	begin
		L1 := C1(C1'first);
		N1 := C1(C1'first+1);
		L2 := C2(C2'first);
		N2 := C2(C2'first+1);

		return (L1 = L2 or L1 = Character'pred(L2) or L1 = Character'succ(L2)) and
				(N1 = N2 or N1 = Character'pred(N2) or N1 = Character'succ(N2));
	end verifContig;

	procedure contigueRecur(sol : in string; ind : in integer; contigus : in out TV_Bool; estContig: out boolean) is
	--{sol représente une solution} => {estContig est vrai si sol est une solution contigüe}
	begin
		for i in contigus'range loop
			 -- on ne vérifie la contiguité qu'avec des éléments pour lesquels on n'a pas trouvé d'élément contigu
			if not contigus(i) and verifContig(sol(ind*2-1..ind*2), sol(i*2-1..i*2)) then
				contigus(i) := true;
				contigueRecur(sol, i, contigus, estContig);
			end if;
		end loop;

		if ind = 1 then -- on ne change estContig que si on est au début de la pile de récursion
			estContig := true;
			for i in contigus'range loop
				if contigus(i) = false then
					estContig := false;
				end if;
			end loop;
		end if;
	end contigueRecur;


	function est_contigue(sol : in string) return boolean is
	--{sol représente une solution} => {résultat = vrai si sol est une solution contigüe}
		nbelem: constant integer := sol'length/2;
		contig: TV_Bool(1..nbelem) := (true, others => false);
		resultat: boolean;
	begin
		contigueRecur(sol, 1, contig, resultat);
		return resultat;
	end est_contigue;

	procedure creeFicsolcont(fsol, fcont : in out text_io.file_type) is
	-- {fsol ouvert} => {fcont contient les combinaisons contigües de fsol et est structuré de la même façon}
		ftmp : text_io.file_type;
		tmp : string(1..15);
		nb : integer;

		taille : integer := 3;
		nblignesCat : integer := 0;

		procedure copieFichTemp is
		begin
			reset(ftmp, IN_FILE);
			while not end_of_file(ftmp) loop
				skip_line(ftmp);
				nblignesCat := nblignesCat + 1;
			end loop;

			put(fcont, taille, 1);
			put(fcont, ' ');
			put(fcont, nblignesCat, 1);
			new_line(fcont);

			reset(ftmp, IN_FILE);
			while not end_of_file(ftmp) loop
				get_line(ftmp, tmp, nb);
				put(fcont, tmp(1..nb));
				new_line(fcont);
			end loop;

			new_page(fcont);
			reset(ftmp, OUT_FILE);
			taille := taille + 1;
			nblignesCat := 0;
		end copieFichTemp;

	begin
		reset(fsol,IN_FILE);
		reset(fcont,OUT_FILE);
		create(ftmp, OUT_FILE, "fconttemp.txt");
		skip_line(fsol);
		while not end_of_file(fsol) loop
			get_line(fsol,tmp,nb);
			if tmp(1) in T_col'range then
				if est_contigue(tmp(1..nb)) then
					put_line(ftmp,tmp(1..nb));
				end if;
			else
				copieFichTemp;
			end if;
		end loop;

		copieFichTemp;
		delete(ftmp);
	end creeFicsolcont;

	procedure fichiersInit (V: out TV_Gaudi) is
		-- {V est de taille 16} =>
		--   {Génère Fout.txt et foutcont.txt contenant respectivement toutes les solutions et les solutions contigües}
    f: p_cases_io.file_type;
    fout, foutcont: text_io.file_type;
		fscore : p_score_io.file_type;
  begin
		begin
			open(fscore, IN_FILE,"score");
		exception
			when others => create(fscore, IN_FILE, "score");
		end;
		close(fscore);
    open(f, IN_FILE, "CarreGaudi");
    CreeVectGaudi(f, V);
    triVectGaudi(V);

    create(fout, OUT_FILE, "fout.txt");
    creeFicsol(V, fout);
    reset(fout, IN_FILE);

    create(foutcont, OUT_FILE, "foutcont.txt");
    creeFicsolcont(fout, foutcont);
    close(f);
    close(fout);
    close(foutcont);
  end fichiersInit;

	procedure resultatExiste(fsol: in out text_io.file_type; sol: in string; resultat: out boolean) is
	-- {fsol ouvert} => {resultat = true si sol est présent dans fsol}
		tmp : string(1..15) := (others => ' ');
		nb: integer := 1;
	begin
		reset(fsol, IN_FILE);
		while not end_of_file(fsol) and tmp(1..nb) /= sol loop
			get_line(fsol, tmp, nb);
		end loop;

		resultat := tmp(1..nb) = sol;
	end resultatExiste;

	procedure permut(a, b: in out string) is
	-- {a'range = b'range = 1..2} => {les valeurs de a et b ont été échangées}
		temp: string(1..2);
	begin
		temp := a;
		a := b;
		b := temp;
	end permut;

	procedure ordonne(sol: in out string) is
	-- {} => {trie la solution par ordre alphabétique}
	  i : integer := sol'first;
		j : integer;
	  permutation: boolean := true;
	begin
	  while permutation loop
	    permutation := false;
			j := sol'last - 1;
	    while j >= i+2 loop
	      if sol(j..j+1) < sol(j-2..j-1) then
	        permut(sol(j..j+1), sol(j-2..j-1));
	        permutation := true;
	      end if;
				j := j - 2;
	    end loop;
	    i := i + 2;
	  end loop;
	end ordonne;

end p_combinaisons;
