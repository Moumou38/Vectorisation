with image_pbm, contour, geom2d, ada.command_line, ada.integer_text_io;
with ada.text_io;
use image_pbm, contour, geom2d, ada.command_line, ada.integer_text_io;
use ada.text_io;

package body fichier_eps is


   procedure creer_fichier_eps(fichier: in string) is
   
      f: file_type;
      f_out:file_type;
      nbp:natural;   --nombre de point
      n: natural;    --recuperation de la largeur et de la hauteur de l'image
      r: reel;
      
   begin
   
      open(f,in_file,fichier);
      
      create(f_out,out_file,fichier&".eps");
   
      put(f_out,"%!PS-Adobe-3.0 EPSF-3.0");
      new_line(f_out);
      
      put(f_out,"%%BoundingBox:");
      put(f_out,"0 0 ");
      get(f, n); --recuperation largeur
      put(f_out,n,2); put(f_out," ");
      get(f, n); --recuperation hauteur
      put(f_out,n,2);
      new_line(f_out);
      
      get(f,nbp);   --recuperation du nombre de point de ce contour
         
      get(f,r);
      put(f_out,r,5,1,0); put(f_out," ");
      get(f,r);
      put(f_out,r,5,1,0); put(f_out," ");
      put_line(f_out,"moveto");
      
      for i in 1..nbp-1 loop
      
         get(f,r);
         put(f_out,r,5,1,0); put(f_out," ");
         get(f,r);
         put(f_out,r,5,1,0); put(f_out," ");
         put_line(f_out,"lineto");
         
      end loop;
      
      put_line(f_out,"stroke");
      
      put_line(f_out,"showpage");
      
      close(f);
      close(f_out);
      
   end creer_fichier_eps;
   
   
   procedure creer_fichier_eps_ensemble(fichier: in string) is
   
      f: file_type;
      f_out:file_type;
      nbp:natural;   --nombre de point
      n: natural;    --recuperation de la largeur et de la hauteur de l'image
      nbc: natural;  --nombre de contours
      r1,r2: reel;
      
   begin
   
      open(f,in_file,fichier);
      
      create(f_out,out_file,fichier&".eps");
   
      put(f_out,"%!PS-Adobe-3.0 EPSF-3.0");
      new_line(f_out);
      
      get(f,nbc);  --recupertaion du nombre de contour
      put(f_out,"%%BoundingBox:");
      put(f_out,"0 0 ");
      get(f, n); --recuperation largeur
      put(f_out,n,2); put(f_out," ");
      get(f, n); --recuperation hauteur
      put(f_out,n,2);
      new_line(f_out);

      
      for i in 1..nbc loop

         get(f,nbp);   --recuperation du nombre de point de ce contour
         
         get(f,r1);
         get(f,r2);
         moveto(f_out,r1,r2);

         for i in 1..nbp-1 loop
      
            get(f,r1);
            get(f,r2);
            lineto(f_out,r1,r2);                       
            
         end loop;
      
         put_line(f_out,"stroke");
         new_line(f_out);
         
      end loop;
      
      put_line(f_out,"showpage");
      
      close(f);
      close(f_out);
      
   end creer_fichier_eps_ensemble;
   
   procedure moveto(F: out file_type; r1,r2: reel) is
   
   begin
   
         put(F,r1,5,1,0); put(F," ");
         put(F,r2,5,1,0); put(F," ");
         put_line(F,"moveto");
   
   end moveto;
   
   procedure lineto(F: out file_type; r1,r2: reel) is
   
   begin
   
            put(F,r1,5,1,0); put(F," ");
            put(F,r2,5,1,0); put(F," ");
            put_line(F,"lineto");           
  
   end lineto;
   
   --ecriture d'une bezier de degre 3
   procedure curveto(F: out file_type; B3: bezier3) is
   
   C0, C1, C2, C3: point;
   
   begin 
   
      C0:= B3(0);
      C1:= B3(1);
      C2:= B3(2);
      C3:= B3(3);
   
      --affichage du premier point
      put(F,C0(1),5,1,0); put(F," ");
      put(F,C0(2),5,1,0); put(F," ");
      put(F,"moveto"); put(F," ");
   
      --affichage du deuxieme point
      put(F,C1(1),5,1,0); put(F," ");
      put(F,C1(2),5,1,0); put(F," ");
  
      --affichage du troisieme point
      put(F,C2(1),5,1,0); put(F," ");
      put(F,C2(2),5,1,0); put(F," ");

      --affichage du quatrieme
      put(F,C3(1),5,1,0); put(F," ");
      put(F,C3(2),5,1,0); put(F," ");
      put_line(F,"curveto");
   
   end curveto;
   
end fichier_eps;
