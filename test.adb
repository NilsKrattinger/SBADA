with text_io, p_combinaisons ;
use  text_io, p_combinaisons, p_combinaisons.p_cases_io ;

procedure test is
  f: p_cases_io.file_type;
  V: TV_Gaudi(1..16);
begin
  open(f, IN_FILE, "CarreGaudi");

  CreeVectGaudi(f, V);
  triVectGaudi(V);
  trouveSol(V);

  close(f);
end test;
