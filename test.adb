with text_io, p_combinaisons ;
use  text_io, p_combinaisons, p_combinaisons.p_cases_io, p_combinaisons.p_int_io ;

procedure test is
  f: p_cases_io.file_type;
  V: TV_Gaudi(1..16);

  fout, foutcont: text_io.file_type;

begin
  open(f, IN_FILE, "CarreGaudi");

  CreeVectGaudi(f, V);
  triVectGaudi(V);

  create(fout, OUT_FILE, "fout.txt");
  creeFicsol(V, fout);
  reset(fout, IN_FILE);

  create(foutcont, OUT_FILE, "foutcont.txt");
  creeFicsolcont(fout, foutcont);

  close(foutcont);
  close(fout);

  close(f);

end test;
