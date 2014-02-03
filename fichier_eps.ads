with image_pbm, contour, geom2d, ada.command_line, ada.integer_text_io;
with ada.text_io;
with ada.Numerics.generic_Elementary_Functions, ada.numerics;
use image_pbm, contour, geom2d, ada.command_line, ada.integer_text_io;
use ada.text_io;

package fichier_eps is

      package ES_T is new ada.text_io.float_io(Reel);
	   use ES_T;
	   package Fct_Reel is new ada.numerics.generic_elementary_functions(Reel);
      use Fct_Reel;

      procedure creer_fichier_eps(fichier: in string);

      procedure creer_fichier_eps_ensemble(fichier: in string);
      
      --ecriture de la commande moveto
      procedure moveto(F: out file_type; r1,r2: reel);

      --ecriture de la commande lineto
      procedure lineto(F: out file_type; r1,r2: reel);
      
      --ecriture d'une bezier de degre 3
      procedure curveto(F: out file_type; B3: bezier3);
      
end fichier_eps;
