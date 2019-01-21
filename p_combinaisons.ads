with sequential_IO;
with text_io; use text_io;


package p_combinaisons is

	---- TYPES pour les cases de la grille --------------------------------------------------------------------------
	subtype T_Col is character range 'A'..'D';
	subtype T_Lig is integer range 1..4;
	subtype T_nbcases is positive range 3..7;
	type TR_Case is record
		nom	:	string(1..2); -- nom de la case (ex : "A1")
		valeur	:	positive;  -- nombre porté par la case (ex : 14)
	end record;


	---- Instanciation de sequential_IO pour le fichier de description de la grille ---------------------------------
	package p_cases_io is new sequential_IO (TR_Case); use p_Cases_IO;

	---- Instanciations de integer_io pour manipuler des entiers dans des fichiers texte ----------------------------
	package p_int_io is new integer_io(integer); use p_int_io;

	---- Type pour le vecteur de "travail" --------------------------------------------------------------------------
	type TV_Gaudi is array (positive range <>) of TR_Case;
	type TV_Ent is array(integer range <>) of integer;

	---- Recherche et affichage des combinaisons --------------------------------------------------------------------

	procedure creeVectGaudi(f : in out p_cases_IO.file_type; V : out TV_Gaudi);
	-- {f ouvert, V de taille suffisante} => {le contenu de f a été copié dans V}

	procedure triVectGaudi(V : in out TV_Gaudi);
		-- {} => {V est trié par nom de case}

	procedure trouveSol(V : in TV_Gaudi; Vcompte : in out TV_Ent);
	-- {} => {trouve les solutions et les stocke dans des fichiers temporaires}

	procedure creeFicsol(V : in TV_Gaudi; fsol : in out text_io.file_type);
	-- {f ouvert en écriture, V Trié par nom de case}
	--	=> 	{fsol contient toutes les combinaisons gagnantes et est structuré selon le format défini (cf. sujet)}

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
