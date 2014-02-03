with geom2d, simplification, contour, image_pbm;
use geom2d, simplification, contour, image_pbm;
with ada.text_io, ada.command_line;
use ada.text_io, ada.command_line;
with ada.integer_text_io;
use ada.integer_text_io;
with ada.float_text_io;
use ada.float_text_io;

procedure test_simplification_bezier2 is

M:image;
p:point;
C:contours;
cc:curseur_contour_segments;
ensemble_bezier2 : contour_bezier2;
L,H: positive;
d: integer;

use liste_segments;
use liste_contour_segments;
use liste_contour;
use liste_point;
use liste_Bezier2 ; 
use liste_contour_Bezier2 ;


begin
   
   
	M:= lire_image(Argument(1));
   p:=point_initial(M);
   L:=largeur(M);
   H:=hauteur(M);
   
    
   --on calcul l'ensemble des contours de l'image   
	calcul_ensemble_contour(M,p,C);
  
   --on simplifie la liste de contours que nous avons obtenue precedement
   put_line("Entrez la distance seuil : ");
   get(d); 
   ensemble_bezier2:=simplification_Douglas_Peuker_bezier2_contour(C,long_float(d));
    
   creer_fichier_eps_bezier2("simplification_bezier2_"&Argument(1),L,H,ensemble_bezier2);   
   
   ecrire_info_bezier2(C,ensemble_bezier2,"simplification_bezier2_"&Argument(1));   
  
	
end test_simplification_bezier2;
