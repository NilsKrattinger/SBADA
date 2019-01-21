with text_io, p_vue_text, p_combinaisons;
use  text_io, p_vue_text, p_combinaisons, p_combinaisons.p_cases_io;

procedure gauditext is
  f: p_cases_io.file_type;
  V: TV_Gaudi(1..16);

begin
  open(f, IN_FILE, "CarreGaudi");
  CreeVectGaudi(f, V);
  triVectGaudi(V);

  afficheGrille(V);
  close(f);
end gauditext;
