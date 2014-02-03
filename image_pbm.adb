-- manipulation d'image noir & blanc
-- compilation
--   gnatmake image_pbm.adb

with ada.text_io,geom2d;
use ada.text_io,geom2d;
with ada.integer_text_io;
use ada.integer_text_io;

package body image_pbm is

	-- creation d'une image de dimensions LxH avec tous les pixels 0
	function creer_image(L,H : positive) return image is
	
		I : image;
	
	begin
		I.L := L;
		I.H := H;
		-- allocation de la memoire necessaire et 
		-- recuperation de l'exception systeme STORAGE_ERROR
		-- si la memoire ne peut pas etre allouee
		-- et lever de l'exception ALLOCATION_TABLEAU_PIXELS_IMPOSSIBLE
		begin
			I.pixels := new tableau(1..L,1..H);
		exception
			when STORAGE_ERROR => raise ALLOCATION_TABLEAU_PIXELS_IMPOSSIBLE;
		end;
		I.pixels.all := (others=>(others=>0));
		return I;
	end creer_image;
	
	-- placer le pixel p en position (i,j) dans l'image M
	procedure set_pixel(M : in out image; i,j : in positive; p : in pixel) is
	
	begin
		-- si (i,j) ne sont pas dans les bornes de l'image
		-- lever l'exception INDICES_PIXEL_HORS_BORNES
		if i>M.L or j>M.H then
			raise INDICES_PIXEL_HORS_BORNES;
		end if;
		M.pixels.all(i,j) := p;
	end set_pixel;
	
	-- recupere le pixel p en position (i,j) dans l'image M
	-- renvoie 0 si (i,j) est hors bornes de l'image
	function get_pixel(M : in image; i,j : in positive) return pixel is
	
	begin
		-- si (i,j) ne sont pas dans les bornes de l'image
		-- lever l'exception INDICES_PIXEL_HORS_BORNES
		if i>M.L or j>M.H then
			raise INDICES_PIXEL_HORS_BORNES;
		end if;
		return M.pixels.all(i,j);
	end get_pixel;
	
	-- lecture d'une image PBM ASCII
	function lire_image(nom_f : in string) return image is
	
		f : file_type;
		c : character;
		H,L : positive;
		s : string(1..1000);
		ls : natural;
		M : image;
		
	begin
		
		-- ouverture du fichier
		open(f, in_file, nom_f);
		
		-- lecture de la ligne 1 - en-tete
		-- la ligne doit etre composee des 2 seuls caracteres 'P' et '1'
		get_line(f, s, ls);
		
		
			if not(s(1) = 'P') then 
				close(f); 
				raise PREMIER_CARACTERE_FAUX ;
		
			elsif not(s(2) = '1') then 
				close(f); 
				raise DEUXIEME_CARACTERE_FAUX;					
			
			elsif ls /= 2 then
				close(f);
				raise TROP_DE_CARACTERES ;
			end if;
		
		
		-- lecture de la ligne 2 - commentaire
		-- la ligne doit commencer par le caractere '#'
		get_line(f, s, ls);
		
		if not(s(1) = '#') then 
			close(f);
				raise NON_DIESE ;
		end if ; 
		

		-- lecture des dimensions
		
		get(f, L); 
		get(f, H) ;
		
		-- initialisation de la variable M : image LxH
	
		M := creer_image(L,H);
								
		-- lecture des pixels et stockage dans l'image M
		-- lecture caractere par caractere
		-- et dans un premier temps ne prendre en compte 
		-- que les caracteres '0' ou '1' 
		for i in 1..H loop 
			for j in 1..L loop 
				get(f,c); 
				while c = character'val(10) loop 
					get(f,c);
				end loop ; 
				 
				if (c = '1')then
					M.pixels(j,i) :=1 ; 
				elsif (c = '0') then 
					M.pixels(j,i) := 0 ; 
				else 
				close(f) ;
					raise ERREUR_FORMAT_CARACTERE ; 
					 
				end if;
				
			end loop;
		end loop ; 			
					
		-- fermeture du fichier
		close(f);
		
		return M;
	end lire_image;
		
	-- ecrire l'image � l'ecran
	procedure put(M : image) is
	
	begin
		
		for i in 1..M.H loop 
			for j in 1..M.L loop 
				put(M.pixels(j,i),2);
			end loop;
			New_line;
		end loop ; 
	
	end put;
	
	--récupère la largeur de l'image
	function largeur(M : in image) return positive is
	begin 
		return M.L;
	end largeur;
	
	--recupère la hauteur de l'image
	function hauteur(M : in image) return positive is
	begin
		return M.H;
	end hauteur;
   
   --calcul d'une image auxiliaire a partir de l'image de depart
   function image_auxiliaire(M: image) return image is
   
   A: image;
   i,j: positive;
   H,L : positive ;

   begin
   H := hauteur(M);   L := largeur(M);
   i:=1;
   j:=1;
   A := creer_image(L,H);
   
   
   while i<=largeur(M) loop   --creation de la premiere ligne pour eviter le probleme de j-1
   
         if get_pixel(M,i,j)=1 then
               set_pixel(A,i,j,1);
         else
               set_pixel(A,i,j,0);
         end if;
         i:=i+1;
   end loop;
   
   j:=j+1;


   while j<=hauteur(M) loop
      i:=1;
      while i<=largeur(M) loop
         if get_pixel(M,i,j)=1 and get_pixel(M,i,j-1)=0 then
               set_pixel(A,i,j,1);
         else
               set_pixel(A,i,j,0);
         end if;
         i:=i+1;
      end loop;
      j:=j+1;   
   end loop;
   
   return A;
   
   end image_auxiliaire;   
   
   
	
end image_pbm;
