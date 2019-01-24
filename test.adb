with text_io, p_combinaisons ;
use  text_io, p_combinaisons, p_combinaisons.p_cases_io, p_combinaisons.p_int_io ;
with  p_combinaisons, p_jeu, Ada.Strings, Ada.Strings.Fixed, text_io, Ada.Characters.Handling;
use   p_combinaisons, p_jeu, Ada.Strings, Ada.Strings.Fixed, text_io, Ada.Characters.Handling, p_combinaisons.p_cases_io, p_jeu.p_score_io;
procedure test is
  f: p_cases_io.file_type;
  V: TV_Gaudi(1..16);
score : TR_Score;
  fout, foutcont: text_io.file_type;
  f2 :p_score_io.file_type;
begin
  -- open(f, IN_FILE, "CarreGaudi");
  --
  -- CreeVectGaudi(f, V);
  -- triVectGaudi(V);
  --
  -- create(fout, OUT_FILE, "fout.txt");
  -- creeFicsol(V, fout);
  -- reset(fout, IN_FILE);
  --
  -- create(foutcont, OUT_FILE, "foutcont.txt");
  -- creeFicsolcont(fout, foutcont);
  --
  -- close(foutcont);
  -- close(fout);
  --
  -- close(f);
    open(f2, APPEND_FILE, "score");
put("1");
for i in 1..20 loop
  put("2");
    score.pseudo := (others => ' ');
    if i >= 10 then
    score.pseudo(1..14) := ("Utilisateur" & integer'image(i) );
  else
    score.pseudo(1..13) := ("Utilisateur" & integer'image(i));
  end if;
     score.score:= (i+2)*3-2*i;
    write(f2, score);
    put("3");
end loop;
  close(f2);
end test;
