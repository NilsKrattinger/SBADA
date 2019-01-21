with sequential_IO;
with text_io; use text_io;


package body p_combinaisons is

  ---- Recherche et affichage des combinaisons --------------------------------------------------------------------

	procedure CreeVectGaudi(f : in out p_cases_IO.file_type; V : out TV_Gaudi);
	-- {f ouvert, V de taille suffisante} => {le contenu de f a �t� copi� dans V}

	procedure TriVectGaudi(V : in out TV_Gaudi);
	-- {} => {V est tri� par nom de case}

	procedure CreeFicsol(V : in TV_Gaudi; fsol : in out text_io.file_type);
	-- {f ouvert en �criture, V Tri� par nom de case}
	--	=> 	{fsol contient toutes les combinaisons gagnantes et est structuré selon le format défini (cf. sujet)}

	function nbCombi(fsol : in text_io.file_type; nbcases : in T_nbcases) return natural;
	-- {fsol ouvert, f- = <>} => {r�sultat = nombre de combinaisons en nbcases dans fsol}

	function Combi(fsol : in text_io.file_type; nbcases : in T_nbcases; numsol : in positive) return string;
	-- {fsol ouvert, f- = <>}
	-- => {r�sultat = cha�ne repr�sentant la solution numsol lue dans fsol pour une combinaison de nbcases}

	function est_contigue(sol : in string) return boolean;
		--{sol repr�sente une solution} => {r�sultat = vrai si sol est une solution contig�e}

	procedure CreeFicsolcont(fsol, fcont : in out text_io.file_type) ;
	-- {fsol ouvert} => {fcont contient les combinaisons contig�es de fsol et est structur� de la m�me fa�on}

end p_combinaisons;
