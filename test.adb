with text_io, p_combinaisons ;
use  text_io, p_combinaisons, p_combinaisons.p_cases_io, p_combinaisons.p_int_io ;

procedure test is
  f: p_cases_io.file_type;
  V: TV_Gaudi(1..16);

  fout: text_io.file_type;
  nbcases: T_nbcases;
  numcomb: integer;

begin
  open(f, IN_FILE, "CarreGaudi");

  CreeVectGaudi(f, V);
  triVectGaudi(V);

  create(fout, OUT_FILE, "fout.txt");
  creeFicsol(V, fout);
  reset(fout, IN_FILE);

  put("Entrez le nb de cases : ");
  get(nbcases);
  put(nbCombi(fout, nbcases));

  reset(fout, IN_FILE);
  new_line;
  put("Entrez le numéro de combinaison : ");
  get(numcomb);
  put(combi(fout, nbcases, numcomb));
  put_line(" solutions.");

  close(fout);

  close(f);

end test;
