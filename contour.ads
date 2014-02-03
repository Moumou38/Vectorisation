with image_pbm, geom2d;
use image_pbm, geom2d;
with ada.containers.doubly_linked_lists;


package contour is


   package liste_point is new ada.containers.doubly_linked_lists(Point);
   subtype polygone is liste_point.list;
   subtype curseur_point is liste_point.cursor;
   use liste_point;
   
   package liste_contour is new ada.containers.doubly_linked_lists(Polygone);
   subtype contours is liste_contour.list;
   subtype curseur_contour is liste_contour.cursor;

   use liste_contour;
   
	type Robot is private;
	
	type Orientation is (Nord, Sud, Est, West);
   
   -- recupere l'état du pixel au nord-est
	function get_pixel_voisin_NE(M : in image; i,j : in integer) return pixel;
	
	-- recupere l'état du pixel au nord-ouest
	function get_pixel_voisin_NW(M : in image; i,j : in integer) return pixel;
	
	
	-- recupere l'état du pixel au sud-est
	function get_pixel_voisin_SE(M : in image; i,j : in integer) return pixel;
	
	-- recupere l'état du pixel au sud-ouest
	function get_pixel_voisin_SW(M : in image; i,j : in integer) return pixel;
   
   -- faire avancer le robot d'une case
	procedure avancer(r : in out Robot);
   
   -- faire tourner le robot `a gauche
	procedure changer_direction(M: in image; r : in out Robot);
   
   --calcul du point initial
	function point_initial(M : in image) return point;
	
	--memorisation de la position
	procedure memoriser(r: in robot; L: in out polygone);
	
	--automate d'extraction du contour
	procedure calcul_contour(M: in image ;A: in out image; p: in point; C: in out contours);
   
   --ecrit la liste dans un fichier 
   procedure ecrire_contour(F : in string; L : in polygone);
   
   --ecrit de l'ensemble des contours dans un fichier 
   procedure ecrire_ensemble_contour(F : in string; C : in contours; M : in image);
   
   --recherche d'un eventuel pixel egale a 1
   procedure recherche_pixel(M : in image; i,j: out integer; B: out boolean);
   
   --extraction de tous les contours
   procedure calcul_ensemble_contour(M: in image; p: in out point; C: out contours) ;
   
   --procedure d'ecriture du nombre de contours et de la somme des nombres de segments de chaque contour
   procedure ecrire_info(C: in contours);
   
   private
	type Robot is record
		x,y : integer;
		o : orientation;
	end record;

end contour ;
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
