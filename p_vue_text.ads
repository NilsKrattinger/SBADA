with text_io; use text_io;
with p_combinaisons; use p_combinaisons;


package p_vue_text is


procedure afficheSolution is (nb : in integer; fsol : in out text_io.file_type);
--{fsol ouvert } => {Les solution de fsol a Nb elements sont affichées}
Nbchar,nbsol : integer;
tmp : string(1..15);
Categorie : boolean := true;
i : integer := 0;
begin
nbsol := (nbCombi(fsol,nb));
put(" * "); put(nbsol); put("solutions en" & integer'image(nb)& " cases");
new_line;
put("-----------------------");

while not end_of_file(f) and Categorie loop
get_line(get_line(fsol,tmp,Nbchar);
  if tmp(1) in T_col'range then
    put("solution " & integer'image(i)(2) &('/') &(nbsol) & (" : "));
    for i in i..Nbchar/2  loop
      put(tmp(i*2-1)&tmp(i*2));
      if i*2 /= Nbchar then
        put(',');
      end if;
      new_line;
    end loop;
  else
    Categorie := false;
  end if;
end loop;
end afficheSolution;







end p_vue_text;
