with p_vue_graph, p_fenbase, Forms, p_combinaisons;
use  p_vue_graph, p_fenbase, Forms, p_combinaisons, p_combinaisons.p_cases_io;

procedure gaudigraph is
  fen: TR_Fenetre;

  f: p_cases_io.file_type;
  V: TV_Gaudi(1..16);
begin
  open(f, IN_FILE, "CarreGaudi");
  CreeVectGaudi(f, V);
  triVectGaudi(V);
  close(f);

  accueil;
  fen := debutFenetre("Test", 500, 500);
  afficherGrille(fen, 50, 50, V);
  ajouterBouton(fen, "continuer", "Next", 225, 470, 50, 50);
  finFenetre(fen);

  montrerFenetre(fen);

  if attendreBouton(fen) /= "MDR" then null; end if;
  cacherFenetre(fen);
  delay 1.0;

end gaudigraph;
