with ada.text_io;
use ada.text_io;
with ada.integer_text_io;
use ada.integer_text_io;
with ada.Numerics.generic_Elementary_Functions, ada.numerics;
with ada.containers.doubly_linked_lists;

package geom2d is 
	
	--déclaration des exceptions
	DIVISION_PAR_ZERO,
	MATRICE_NON_INVERSIBLE: exception;

	subtype Reel is long_float;

	type vecteur is array(1..2) of Reel;
	subtype point is vecteur;

	type Matrice is array(1..2,1..2) of Reel;
   
   type Bezier2 is array(0..2) of point;
   
   type Bezier3 is array(0..3) of point;

--liste de bezier2  
   package liste_Bezier2 is new ada.containers.doubly_linked_lists(Bezier2);
   subtype ensemble_Bezier2 is liste_Bezier2.list;
   subtype curseur_Bezier2 is liste_Bezier2.cursor;
   use liste_Bezier2;

--liste de liste de bezier2
   package liste_contour_Bezier2 is new ada.containers.doubly_linked_lists(ensemble_Bezier2);
   subtype contour_Bezier2 is liste_contour_Bezier2.list;
   subtype curseur_contour_Bezier2 is liste_contour_Bezier2.cursor;
   use liste_contour_Bezier2;
   
--liste de bezier3
   package liste_Bezier3 is new ada.containers.doubly_linked_lists(Bezier3);
   subtype ensemble_Bezier3 is liste_Bezier3.list;
   subtype curseur_Bezier3 is liste_Bezier3.cursor;
   use liste_Bezier3;

--liste de liste de bezier3
   package liste_contour_Bezier3 is new ada.containers.doubly_linked_lists(ensemble_Bezier3);
   subtype contour_Bezier3 is liste_contour_Bezier3.list;
   subtype curseur_contour_Bezier3 is liste_contour_Bezier3.cursor;
   use liste_contour_Bezier3;
   
	
	package ES_T is new ada.text_io.float_io(Reel);
	use ES_T;
	package Fct_Reel is new ada.numerics.generic_elementary_functions(Reel);
   use Fct_Reel;
	
	
	--fonction de calcul de la norme d'un vecteur
	function norme(v : vecteur ) return Reel;
	
	--fonction d'addition de vecteurs
	function "+"(u,v : vecteur) return vecteur;
   
   --fonction de soustraction de vecteurs
	function "-"(u,v : vecteur) return vecteur;
	
	--fonction de multiplication droite d'un vecteur par un reel
	function "*"(v : vecteur; a : Reel) return vecteur;
	
	--fonction de multiplication gauche d'un vecteur par un reel
	function "*"(a : Reel ; v : vecteur) return vecteur;
	
	--fonction de multiplication gauche d'un matrice par un vecteur
	function "*"(M : Matrice; v : vecteur) return vecteur;
	
   --fonction de calcul de determinant
	function det(M : Matrice ) return Reel;
	
	--fonction de division d'une matrice par un reel
	function "/"(v : vecteur; a : Reel) return vecteur;
	
	--fonction d'inversion d'une matrice
	function inv(M :Matrice) return Matrice;
   
   --fonction de calcul de la distance d'un point a une droite
   function distance(P,A,B: point) return Reel;
	
   --fonction de calcul de la distance d'un point a une droite
   function distance_point_bezier2(P: point; B: Bezier2; k: reel) return Reel;
   
   --fonction de calcul de la distance d'un point a une droite
   function distance_point_bezier3(P: point; B: Bezier3; k: reel) return Reel;
   
   --calcul des fonctions de base de Bernstein2
   function bernstein2(k: integer; t: reel) return reel;
   
     --calcul des fonctions de base de Bernstein2
   function bernstein3(k: integer; t: reel) return reel;
   
   --evaluation d'une Bezier de degre 2
   function evaluation_bezier2(B2: bezier2; t: reel) return point; 
   
   --evaluation d'une Bezier de degre 3
   function evaluation_bezier3(B3: bezier3; t: reel) return point;
   
   --conversion d'une bezier de degre 2 en bezier de degre 3
   function conversion(B2: bezier2) return bezier3;
	
end geom2d;

