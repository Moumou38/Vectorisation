with ada.text_io;
use ada.text_io;
with ada.integer_text_io;
use ada.integer_text_io;
with ada.Numerics.generic_Elementary_Functions, ada.numerics;
with ada.containers.doubly_linked_lists;
with geom2d, contour ;
use geom2d, contour ;

package simplification is 

   type segment is array(1..2) of point;
   
   package liste_segments is new ada.containers.doubly_linked_lists(segment);
      subtype segments is liste_segments.list;
      subtype curseur_segments is liste_segments.cursor;
      use liste_segments;
   
   package liste_contour_segments is new ada.containers.doubly_linked_lists(segments);
      subtype contour_segments is liste_contour_segments.list;
      subtype curseur_contour_segments is liste_contour_segments.cursor;
      use liste_contour_segments;   
      use liste_contour;
      use liste_point;

--simplification d'un polygone en liste de segments
   function simplification_Douglas_Peuker (C : polygone; i1,i2 : curseur_point; d: Reel) return    segments;
   
   --simplification douglas peuker appliquee au bezier2
   function simplification_Douglas_Peuker_bezier2 (C : polygone; i1,i2 : integer; d: Reel) return   ensemble_bezier2;
 
  --simplification douglas peuker appliquee au bezier2
   function simplification_Douglas_Peuker_bezier3 (C : polygone; i1,i2 : integer; d: Reel) return   ensemble_bezier3;
 
   --simplification d'un ensemble de contour en liste de liste de segments 
   function simplification_Douglas_Peuker_ensemble (C : contours; d: Reel) return contour_segments;
   
   --simplification douglas peuker bezier2 appliquee a un ensemble de contour
   function simplification_Douglas_Peuker_bezier2_contour (C : contours; d: Reel) return   contour_bezier2;
 
   --simplification douglas peuker bezier3 appliquee a un ensemble de contour
   function simplification_Douglas_Peuker_bezier3_contour (C : contours; d: Reel) return   contour_bezier3;

   --nombre de points se trouvant entre les indice i1 et i2
   function nb_points(C: polygone; i1,i2 : integer) return integer;

   --point d'indice i se trouvant dans le polygone C
   function point_indice(C: polygone; i: integer) return point;
   
   --procedure qui met le curseur au point d'indice i1
   procedure curseur_indice(C: in polygone; i1: in integer; cc: out curseur_point);
   
   --creer un fichier eps correspondant a un contour segment
   procedure creer_fichier_eps_segments(fichier: in string; L,H: positive; C: in contour_segments);
   
   --creer un fichier eps correspondant a un contour en bezier3
   procedure creer_fichier_eps_bezier3(fichier: in string; L,H: positive; C: in contour_Bezier3);
   
   --creer un fichier eps correspondant a un contour en bezier2
   procedure creer_fichier_eps_bezier2(fichier: in string; L,H: positive; C: in contour_Bezier2);
   
   --ecrit les informations sur le nombre de segments d'un contour
   procedure ecrire_info_segments(C: in contours; ES1: in contour_segments; fichier: in string);
   
   --procedure d'ecriture du nombre de contours et de bezier2
procedure ecrire_info_bezier2(C: in contours; ES1: contour_bezier2; fichier: in string);

   --procedure d'ecriture du nombre de contours et de bezier3
   procedure ecrire_info_bezier3(C: in contours; ES1: contour_bezier3; fichier: in string);
   

   --calcul de la Bezier de degre2 B(C0,C1,C2) approchant un contour polygonal
   function approx_bezier2(C: polygone; i1,i2: integer; n: integer) return bezier2;
   
   --calcul de la bezier de degre3 B(C0,C1,C2,C3) approchant un contour polygonal
   function approx_bezier3(C: polygone; i1,i2: integer; n: integer) return bezier3;

end simplification ;
