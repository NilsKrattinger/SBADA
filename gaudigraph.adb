with p_combinaisons, p_fenbase, p_vue_graph, p_client;
use  p_combinaisons, p_fenbase, p_vue_graph, p_client;

procedure gaudigraph is
  V: TV_Gaudi(1..16);
begin
  fichiersInit(V);
  initialiserFenetres;
  initialiserSocket;
  fenetreAccueil;
end gaudigraph;
