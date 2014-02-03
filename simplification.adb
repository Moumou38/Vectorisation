with ada.text_io;
use ada.text_io;
with ada.integer_text_io;
use ada.integer_text_io;
with ada.long_float_text_io;
use ada.long_float_text_io;
with ada.Numerics.generic_Elementary_Functions, ada.numerics;
with geom2d, contour, fichier_eps;
use geom2d, contour, fichier_eps ;

package body simplification is


-----------------------------------------------------------------------------------------------
--PARTIE CONCERNANT LA RECUPERATION DE POINTS ET DE CURSEURS
-----------------------------------------------------------------------------------------------

   --calcul du nombre de pints de C entre les indices i1 et i2
   function nb_points(C: polygone; i1,i2 : integer) return integer is

   begin
      
      return i2 - i1 +1;
  
   end nb_points;
   
   --fonction qui retourne le point d'indice i dans le contour
   function point_indice(C: polygone; i: integer) return point is

      cc: curseur_point;
      j: integer;
      use liste_segments;
      use liste_contour;
      use liste_point;
   
      begin 
   
      j:=0;
      cc:=first(C);           
   
      while cc /= liste_point.no_element  and then j /= i loop --parcours de la contour jusqu'a l'indice i1     
            next(cc);
            j:=j+1;         
      end loop;
      
      return element(cc);
    
    end point_indice;
    
    --procedure qui met le curseur au point d'indice i1
    procedure curseur_indice(C: in polygone; i1: in integer; cc: out curseur_point) is
    
      j: integer;
      use liste_segments;
      use liste_contour;
      use liste_point;
   
      begin 
   
      j:=0;
      cc:=first(C);
              
      while cc /= liste_point.no_element  and then j /= i1 loop --parcours du contour jusqu'a l'indice i1     
            next(cc);
            j:=j+1;         
      end loop;
    
    end curseur_indice;
    
-----------------------------------------------------------------------------------------------
--PARTIE CONCERNANT LES APPROXIMATIONS DE BEZIER 
-----------------------------------------------------------------------------------------------
   
   --calcul de la Bezier de degre2 B(C0,C1,C2) approchant un contour polygonal
   function approx_bezier2(C: polygone; i1,i2: integer; n: integer) return bezier2 is
   
   cc: curseur_point;
   C0, C1, C2: point;
   P: point;
   B:bezier2;
   Psomme : point;
   nr : long_float := long_float(n);
   
   begin
            
      --Psomme va permettre de faire la somme des pi 
      Psomme := (0.0,0.0);
        
      --C0 premier element du contour polygonal
      C0:=point_indice(C,i1);

      for i in 1..n-1 loop            
            P:=point_indice(C,i);
            Psomme:= Psomme+P;
      end loop;
                  
      --C2 dernier element de du contour polygonal
      C2:=point_indice(C,i2);
      
      --calcul des coordonnees de C1
      C1:=3.0*nr/(nr*nr-1.0)*Psomme-(2.0*nr-1.0)/(2.0*(nr+1.0))*(C0+C2);   
      B:=(C0,C1,C2);
   
      return B;
   
   end approx_bezier2;
   
   
   --calcul de la Bezier de degre2 B(C0,C1,C2) approchant un contour polygonal
   function approx_bezier2(C: polygone; i1,i2: integer; n: integer; cc: curseur_point) return bezier2 is
   
   cp: curseur_point;
   C0, C1, C2: point;
   P: point;
   B:bezier2;
   Psomme : point;
   nr : long_float := long_float(n);
   
   begin
        
      cp:=cc;
           
      --Psomme va permettre de faire la somme des pi 
      Psomme := (0.0,0.0);
                
      --C0 premier element du contour polygonal
      C0:=element(cp);
      next(cp);
      
      for i in 1..n-1 loop            
            P:=element(cp);
            Psomme:= Psomme+P;
            next(cp);
      end loop;
                        
      --C2 dernier element de du contour polygonal
      C2:=element(cp);
      
      --calcul des coordonnees de C1
      C1:=3.0*nr/(nr*nr-1.0)*Psomme-(2.0*nr-1.0)/(2.0*(nr+1.0))*(C0+C2);   
      B:=(C0,C1,C2);
   
      return B;
   
   end approx_bezier2;
   
   
   --calcul de la bezier de degre3 B(C0,C1,C2,C3) approchant un contour polygonal
   function approx_bezier3(C: polygone; i1,i2: integer; n: integer) return bezier3 is
   
   alpha, beta,lambda: reel;
   i: integer :=0;
   nr, k: long_float;
   cp: curseur_point;
   C0,C1,C2,C3: point;  --point de notre bezier3
   P0,P1,Pn: point;  --point permettant le calcul de la bezier3 quand n=2 
   D1: point;
   S1: point := (0.0,0.0);
   S2: point := (0.0,0.0);
   
   begin
   
   nr:= long_float(n);
   
   --approx_bezier3 ne peut etre appele que dans le cas n>=2, on n'a pas a traiter le cas n=1
   if n=2 then
      P0:= point_indice(C,i1);
      P1:= point_indice(C,i1+1);
      Pn:= point_indice(C,i2);
      
      D1:= 2.0*P1- (P0+Pn)/2.0;
       
      C0:=P0;
      C1:=(P0+2.0*D1)/3.0;   
      C2:=(2.0*D1+Pn)/3.0;
      C3:=Pn;
   
   else
      
      --coefficient necessaires au calcul de C1 et C2
      alpha:= (-15.0*nr*nr*nr + 5.0*nr*nr + 2.0*nr + 4.0) / ((3.0*(nr+2.0)*(3.0*nr*nr+1.0)));
      beta:= (10.0*nr*nr*nr - 15.0*nr*nr + nr + 2.0) / (3.0*(nr+2.0)*(3.0*nr*nr+1.0));
      lambda:= 70.0*nr / (3.0*(nr*nr-1.0)*(nr*nr-4.0)*(3.0*nr*nr+1.0));
      
      cp:= first(C);
      
      while i<i1 loop      --on avance jusqu'au point d'indice i1
         next(cp);
         i:=i+1;
      end loop;
      
      C0:=element(cp);
      next(cp);
      
      for i in 1..n-1 loop
         k:= long_float(i);    --simplifie le calcul de S1 et S2 a suivre
     S1:= S1+(6.0*k*k*k*k-8.0*nr*k*k*k+6.0*k*k-4.0*nr*k + nr*nr*nr*nr - nr*nr)*element(cp);
            S2:= S2+(6.0*(nr-k)*(nr-k)*(nr-k)*(nr-k)-8.0*nr*(nr-k)*(nr-k)*(nr-k)+6.0*(nr-k)*(nr-k)-4.0*nr*(nr-k)+ nr*nr*nr*nr - nr*nr)*element(cp);
         
         next(cp);         
      end loop;
      
      C3:=element(cp);
      
      C1:= alpha*C0 + lambda*S1 + beta*C3;
      C2:= beta*C0 + lambda*S2 + alpha*C3;
      
   end if;
   
   return (C0,C1,C2,C3);
                
   end approx_bezier3;


-----------------------------------------------------------------------------------------------
--PARTIE CONCERNANT LES DIFFERENTS TYPES DE SIMPLIFICATIONS 
-----------------------------------------------------------------------------------------------    
    
    --------------------------------------------
    --simplification par segments
    --------------------------------------------
   function simplification_Douglas_Peuker (C : polygone; i1,i2 : curseur_point; d: Reel) return          segments is

   L1, L2: segments;
   n, j, k: curseur_point;
   dmax, dj: Reel;
   P_j, P_i1, P_i2: point;
   cpj: curseur_point;
   use liste_segments;
   use liste_contour;
   use liste_point;
   
   
   begin
   
   P_i1:= element(i1);
   P_i2:= element(i2);
   
   if i2=next(i1) then

         append(L1,(P_i1,P_i2));
      
   else

         dmax:= 0.0;
         j:= i1;

         while j /= next(i2) loop

            P_j:= element(j);
            dj:= distance(P_j,P_i1,P_i2);
         
            if dmax<dj then
         
               dmax:=dj;
               k:=j;
            
            end if;
            
            j:= next(j);
         end loop;
      
         if dmax<=d then
      
            append(L1,(P_i1,P_i2));
         
         else
      
            L1:= simplification_Douglas_Peuker(C,i1,k,d);
            L2:= simplification_Douglas_Peuker(C,k,i2,d); 
            splice(L1,liste_segments.no_element,L2);
            
         end if;
         
     end if;
      
     return L1;
      
   end simplification_Douglas_Peuker;
   
   
   function simplification_Douglas_Peuker_ensemble (C : contours; d: Reel) return contour_segments is
   
   use liste_segments;
   use liste_contour;
   use liste_point;
   use liste_contour_segments;
   
   cc: curseur_contour;
   L:polygone;
   S:segments;
   ensemble_segments: contour_segments;
     
   begin
   
   cc:=first(C);
     
   while cc/=liste_contour.no_element loop           
            L:=element(cc);
            S:= simplification_Douglas_Peuker(L,first(L),last(L),d);      
            append(ensemble_segments,S);            
            next(cc);                        
   end loop;  
   
   return ensemble_segments;
   
   end simplification_Douglas_Peuker_ensemble;   
   

    --------------------------------------------
    --simplification par bezier2
    -------------------------------------------- 
         
   --simplification douglas peuker appliquee au bezier2  
   function simplification_Douglas_Peuker_bezier2 (C : polygone; i1,i2 : integer; d: Reel) return  ensemble_bezier2 is

   L1, L2 : ensemble_bezier2;
   B : Bezier2;
   n, np, j, k, i: integer;
   dmax, dj: Reel;
   C0, C1, C2, P_j, P_i1, P_i2: point;
   cpj: curseur_point;
   use liste_segments;
   use liste_contour;
   use liste_point;
   use liste_Bezier2;
     
   begin
   
   np:= nb_points(C,i1,i2);
   n := np - 1;
   P_i1:= point_indice(C,i1);
   P_i2:= point_indice(C,i2);
   
   if n=1 then
      C0 := P_i1 ; 
      C2 := P_i2 ;
      C1 := (C0+C2)/2.0;
      B := (C0,C1,C2) ; 
      append(L1,B);
      
   else
      
      curseur_indice(C,i1,cpj);
      B := approx_bezier2(C,i1,i2, n, cpj) ; 
      dmax:= 0.0;
      j:= i1; 
      i:= 0;
            
         while j <= i2 loop
                  
            P_j:= element(cpj);
            dj:= distance_point_bezier2(P_j,B,long_float(i)/long_float(n)); 
         
            if dmax<dj then
         
               dmax:=dj;
               k:=j;
            
            end if;
            
            j:=j+1; 
            i:=i+1 ; 
            next(cpj);
         
         end loop;         
            
         if dmax<=d then
      
            append(L1,B);
         
         else
      
            L1:= simplification_Douglas_Peuker_bezier2(C,i1,k,d);
            L2:= simplification_Douglas_Peuker_bezier2(C,k,i2,d); 
            splice(L1,liste_Bezier2.no_element,L2);
            
         end if;
         
   end if;
      
   return L1;
      
   end simplification_Douglas_Peuker_bezier2;



   --simplification douglas peuker bezier2 appliquee a un ensemble de contour
   function simplification_Douglas_Peuker_bezier2_contour (C : contours; d: Reel) return contour_bezier2 is

   use liste_segments;
   use liste_contour;
   use liste_point;
   use liste_contour_Bezier2;

   CB: contour_bezier2;
   cc: curseur_contour; 
   P: polygone;
   B: ensemble_bezier2;
   
   begin

   cc:=first(C);
   
   while cc /= liste_contour.no_element loop   
         P:=element(cc);
         B:= simplification_Douglas_Peuker_bezier2(P,0,integer(length(P))-1,d);
         append(CB,B);
         next(cc);   
   end loop;

   return CB;
   
   end simplification_Douglas_Peuker_bezier2_contour;


    --------------------------------------------
    --simplification par segments
    --------------------------------------------
  
   --simplification douglas peuker bezier3 appliquee a un ensemble de contour   
   function simplification_Douglas_Peuker_bezier3 (C : polygone; i1,i2 : integer; d: Reel) return ensemble_bezier3 is

   L1, L2 : ensemble_bezier3;
   B : Bezier3;
   n, np, j, k, i: integer;
   dmax, dj: Reel;
   C0, C1, C2, C3, P_j, P_i1, P_i2: point;
   cpj: curseur_point;
   use liste_segments;
   use liste_contour;
   use liste_point;
   use liste_Bezier3;
      
   begin
   
   np:= nb_points(C,i1,i2);
   n := np - 1;
   P_i1:= point_indice(C,i1);
   P_i2:= point_indice(C,i2);
   
   if n=1 then
      C0 := P_i1 ; 
      C3 := P_i2 ;
      C1 := (2.0*C0+C3)/3.0;
      C2 := (C0+2.0*C3)/3.0;
      B := (C0,C1,C2,C3) ; 
      append(L1,B);
      
   else
   
      curseur_indice(C,i1,cpj);   
      B := approx_bezier3(C,i1,i2,n) ;
      
      dmax:= 0.0;
      j:= i1; 
      i:= 0;
      
         while j /= i2+1 loop
         
            P_j:= element(cpj);
            dj:= distance_point_bezier3(P_j,B,long_float(i)/long_float(n)); 
         
            if dmax<dj then
         
               dmax:=dj;
               k:=j;
            
            end if;
            
            j:=j+1; i:=i+1 ; 
            next(cpj);
         end loop;
         
            
         if dmax<=d then
      
            append(L1,B);
         
         else
      
            L1:= simplification_Douglas_Peuker_bezier3(C,i1,k,d);
            L2:= simplification_Douglas_Peuker_bezier3(C,k,i2,d); 
            splice(L1,liste_Bezier3.no_element,L2);
            
         end if;
         
     end if;
      
     return L1;
      
   end simplification_Douglas_Peuker_bezier3;


   --simplification douglas peuker bezier2 appliquee a un ensemble de contour
   function simplification_Douglas_Peuker_bezier3_contour (C : contours; d: Reel) return   contour_bezier3 is

   use liste_segments;
   use liste_contour;
   use liste_point;
   use liste_contour_Bezier3;
   CB: contour_bezier3;
   cc: curseur_contour; 
   P: polygone;
   B: ensemble_bezier3;
   
   begin

   cc:=first(C);
   
   while cc /= liste_contour.no_element loop   
         P:=element(cc);
         B:= simplification_Douglas_Peuker_bezier3(P,0,integer(length(P))-1,d);
         append(CB,B);
         next(cc);   
   end loop;
   
   return CB;

   end simplification_Douglas_Peuker_bezier3_contour;
 

-----------------------------------------------------------------------------------------------
--PARTIE CONCERNANT LA CREATION DES FICHIERS EPS 
-----------------------------------------------------------------------------------------------

   --creer le fichier eps correspondant a un contour par segments
   procedure creer_fichier_eps_segments(fichier: in string; L,H: positive; C: in contour_segments) is
   
      
      f_out:file_type;
      ccs: curseur_contour_segments;
      cc: curseur_segments;
      S: segments;      --ensemble des segments d'un contour
      seg: segment;
      P,P1:point;
  
   begin
      
    
      create(f_out,out_file,fichier&".eps");
   
      put(f_out,"%!PS-Adobe-3.0 EPSF-3.0");
      new_line(f_out);
      
      put(f_out,"%%BoundingBox:");
      put(f_out,"0 0 ");
      put(f_out,L,2); put(f_out," ");  --passage de la largeur de l'image
      put(f_out,H,2);                  --passage de la hauteur
      new_line(f_out);
      
      ccs:=first(C);
        
       
      while ccs/=liste_contour_segments.no_element loop
         
         S:=element(ccs);
         cc:=first(S);       
         seg:=element(cc);         
         P1:=seg(2);         
         P:=seg(1);       

         moveto(f_out,P(1),long_float(H)-P(2)); 
         lineto(f_out,P1(1),long_float(H)-P1(2));        
         next(cc);
                
         while cc/=liste_segments.no_element loop         
            seg:=element(cc);            
            P:=seg(2);
            lineto(f_out,P(1),long_float(H)-P(2));
            next(cc);                                              
         end loop;
     

         next(ccs);
         
         put_line(f_out,"stroke");
         new_line(f_out);
         
      end loop;
      
      put_line(f_out,"showpage");
      
      close(f_out);
      
   end creer_fichier_eps_segments;

   
   --procedure permettant la sortie au format eps d'une suite de Bezier2
   procedure creer_fichier_eps_Bezier2(fichier: in string; L,H: positive; C: in contour_Bezier2) is
      
      use liste_segments;
      use liste_contour;
      use liste_point;
      use liste_contour_Bezier2;
      use liste_Bezier2;
      
      f_out:file_type;
      ccb: curseur_contour_Bezier2;
      cc: curseur_Bezier2;
      LB: ensemble_Bezier2;      --ensemble des segments d'un contour
      B: bezier2;
      B3 : bezier3;
      P0,P1,P2,P3:point;
  
   begin
          
      create(f_out,out_file,fichier&".eps");
   
      put(f_out,"%!PS-Adobe-3.0 EPSF-3.0");
      new_line(f_out);
      
      put(f_out,"%%BoundingBox:");
      put(f_out,"0 0 ");
      put(f_out,L,2); put(f_out," ");  --passage de la largeur de l'image
      put(f_out,H,2);                  --passage de la hauteur
      new_line(f_out);
      
      ccb:=first(C);
               
      while ccb/=liste_contour_Bezier2.no_element loop
                 
         LB:=element(ccb);
         cc:=first(LB);       
         B:=element(cc); 
         B3 := conversion(B);        
         P0:=B3(0);         
         P1:=B3(1);
         P2:=B3(2);
         P3:=B3(3);       

         moveto(f_out,P0(1),long_float(H)-P0(2));
          
         --affichage du deuxieme point
         put(f_out,P1(1),5,4,0); put(f_out," ");
         put(f_out,long_float(H)-P1(2),5,4,0); put(f_out," ");
  
         --affichage du troisieme point
         put(f_out,P2(1),5,4,0); put(f_out," ");
         put(f_out,long_float(H)-P2(2),5,4,0); put(f_out," ");

         --affichage du quatrieme
         put(f_out,P3(1),5,4,0); put(f_out," ");
         put(f_out,long_float(H)-p3(2),5,4,0); put(f_out," ");
         put_line(f_out,"curveto");       
         
         next(cc);
         
         while cc/=liste_Bezier2.no_element loop
         
            B:=element(cc);
            B3 := conversion(B);        
            P0:=B3(0);         
            P1:=B3(1);
            P2:=B3(2);
            P3:=B3(3);
            
            --affichage du deuxieme point
            put(f_out,P1(1),5,4,0); put(f_out," ");
            put(f_out,long_float(H)-P1(2),5,4,0); put(f_out," ");
  
            --affichage du troisieme point
            put(f_out,P2(1),5,4,0); put(f_out," ");
            put(f_out,long_float(H)-P2(2),5,4,0); put(f_out," ");

            --affichage du quatrieme
            put(f_out,P3(1),5,4,0); put(f_out," ");
            put(f_out,long_float(H)-p3(2),5,4,0); put(f_out," ");
            put_line(f_out,"curveto");
            
            next(cc);                                  
            
         end loop;
     
         next(ccb);
                  
      end loop;
      
      put_line(f_out,"0 setlinewidth");
      put_line(f_out,"fill");
      new_line(f_out);
      put_line(f_out,"showpage");
      
      close(f_out);
      
   end creer_fichier_eps_Bezier2;
   
   
   --procedure permettant la sortie au format eps d'une suite de Bezier3
   procedure creer_fichier_eps_bezier3(fichier: in string; L,H: positive; C: in contour_Bezier3) is
      
      use liste_segments;
      use liste_contour;
      use liste_point;
      use liste_contour_Bezier3;
      use liste_Bezier3;
      
      f_out:file_type;
      ccb: curseur_contour_Bezier3;
      cc: curseur_Bezier3;
      LB: ensemble_Bezier3;      --ensemble des segments d'un contour
      B: bezier3;
      P0,P1,P2,P3:point;
  
   begin
          
      create(f_out,out_file,fichier&".eps");
   
      put(f_out,"%!PS-Adobe-3.0 EPSF-3.0");
      new_line(f_out);
      
      put(f_out,"%%BoundingBox:");
      put(f_out,"0 0 ");
      put(f_out,L,2); put(f_out," ");  --passage de la largeur de l'image
      put(f_out,H,2);                  --passage de la hauteur
      new_line(f_out);
      
      ccb:=first(C);
               
      while ccb/=liste_contour_Bezier3.no_element loop
         
         LB:=element(ccb);
         cc:=first(LB);       
         B:=element(cc);         
         P0:=B(0);         
         P1:=B(1);
         P2:=B(2);
         P3:=B(3);       

         moveto(f_out,P0(1),long_float(H)-P0(2));
          
         --affichage du deuxieme point
         put(f_out,P1(1),5,4,0); put(f_out," ");
         put(f_out,long_float(H)-P1(2),5,4,0); put(f_out," ");
  
         --affichage du troisieme point
         put(f_out,P2(1),5,4,0); put(f_out," ");
         put(f_out,long_float(H)-P2(2),5,4,0); put(f_out," ");

         --affichage du quatrieme
         put(f_out,P3(1),5,4,0); put(f_out," ");
         put(f_out,long_float(H)-p3(2),5,4,0); put(f_out," ");
         put_line(f_out,"curveto");       
         
         next(cc);
         
         while cc/=liste_Bezier3.no_element loop
         
            B:=element(cc);
            
            P0:=B(0);         
            P1:=B(1);
            P2:=B(2);
            P3:=B(3);
            
            --affichage du deuxieme point
            put(f_out,P1(1),5,4,0); put(f_out," ");
            put(f_out,long_float(H)-P1(2),5,4,0); put(f_out," ");
  
            --affichage du troisieme point
            put(f_out,P2(1),5,4,0); put(f_out," ");
            put(f_out,long_float(H)-P2(2),5,4,0); put(f_out," ");

            --affichage du quatrieme
            put(f_out, P3(1),5,4,0); put(f_out," ");
            put(f_out,long_float(H)-p3(2),5,4,0); put(f_out," ");
            put_line(f_out,"curveto");
            
            next(cc);                                  
            
         end loop;     

         next(ccb);
         
      end loop;
      
      put_line(f_out,"0 setlinewidth");
      put_line(f_out,"fill");
      new_line(f_out);
      put_line(f_out,"showpage");
      
      close(f_out);
      
   end creer_fichier_eps_bezier3;

-----------------------------------------------------------------------------------------------
--PARTIE CONCERNANT L'ECRITURE DES INFORMATIONS 
-----------------------------------------------------------------------------------------------   
   
   --procedure d'ecriture du nombre de contours et de la somme des nombres de segments de chaque contour
   procedure ecrire_info_segments(C: in contours; ES1: contour_segments; fichier: in string) is
   
   nb_p: integer;  --nompbre de points formant l'ensemble de l'image
   cc: curseur_contour;
   ccs: curseur_contour_segments;
   S: segments;      --ensemble des segments d'un contour
   L:polygone;
   f_out: file_type;
   
   begin
      
      create(f_out,out_file,"resultats_"&fichier&".txt");
      
      --affichage du nombre de contour
      put(f_out,integer(length(C)));      
      new_line(f_out);
      
      --ecriture du nombre de contours
      cc:=first(C);
      nb_p:=0;
      
      while cc /= liste_contour.no_element loop --parcours de la liste de contour
            
            L:=element(cc);
            
            --on retire 1 au nombre de points pour obtenir le nombre de                         segments, car le point initial d'un contour est compte deux fois 
            nb_p:=nb_p+integer(length(L))-1;  
            
            next(cc);
         
      end loop;
      
      put(f_out,nb_p);
      New_line(f_out);      
      
      --ecritue du nombre de segments apres une simplification 
      ccs:=first(ES1);
      nb_p:=0;
      
      while ccs /= liste_contour_segments.no_element loop --parcours de la liste de contour
            
            S:=element(ccs);
            
            --on retire 1 au nombre de points pour obtenir le nombre de segments,  
            --car le point initial d'un contour est compte deux fois 
            nb_p:=nb_p+integer(length(S))-1;  
            
            next(ccs);
         
      end loop;
      
      put(f_out,nb_p);
      New_line(f_out);     
      
   end ecrire_info_segments;


   --procedure d'ecriture du nombre de contours et du nombre de bezier2
   procedure ecrire_info_bezier2(C: in contours; ES1: contour_bezier2; fichier: in string) is

   use liste_segments;
   use liste_contour;
   use liste_point;
   use liste_contour_Bezier2;
   use liste_Bezier2;
   
   nb_p: integer;  --nompbre de points formant l'ensemble de l'image
   cc: curseur_contour;
   ccs: curseur_contour_bezier2;
   S: ensemble_bezier2;      --ensemble des segments d'un contour
   L:polygone;
   f_out: file_type;
   
   begin
      
      create(f_out,out_file,"resultats_"&fichier&".txt");
      
      --affichage du nombre de contour
      put(f_out,integer(length(C)));      
      new_line(f_out);
      
      --ecriture du nombre de contours
      cc:=first(C);
      nb_p:=0;
      
      while cc /= liste_contour.no_element loop --parcours de la liste de contour
            
            L:=element(cc);
            
            --on retire 1 au nombre de points pour obtenir le nombre de                         segments, car le point initial d'un contour est compte deux fois 
            nb_p:=nb_p+integer(length(L))-1;  
            
            next(cc);
         
      end loop;
      
      put(f_out,nb_p);
      New_line(f_out);
            
      --ecritue du nombre de segments apres une simplification de distance seuil 1
      ccs:=first(ES1);
      nb_p:=0;
      
      while ccs /= liste_contour_bezier2.no_element loop --parcours de la liste de contour
            
            S:=element(ccs);
             
            nb_p:=nb_p+integer(length(S));  
            
            next(ccs);
         
      end loop;
      
      put(f_out,nb_p);
      New_line(f_out);      
      
   end ecrire_info_bezier2;


   --procedure d'ecriture du nombre de contours et du nombre de bezier3
   procedure ecrire_info_bezier3(C: in contours; ES1: contour_bezier3; fichier: in string) is

   use liste_segments;
   use liste_contour;
   use liste_point;
   use liste_contour_Bezier3;
   use liste_Bezier3;
   
   nb_p: integer;  --nompbre de points formant l'ensemble de l'image
   cc: curseur_contour;
   ccs: curseur_contour_bezier3;
   S: ensemble_bezier3;      --ensemble des segments d'un contour
   L:polygone;
   f_out: file_type;
   
   begin
      
      create(f_out,out_file,"resultats_"&fichier&".txt");
      
      --affichage du nombre de contour
      put(f_out,integer(length(C)));      
      new_line(f_out);
      
      --ecriture du nombre de contours
      cc:=first(C);
      nb_p:=0;
      
      while cc /= liste_contour.no_element loop --parcours de la liste de contour
            
            L:=element(cc);
            
            --on retire 1 au nombre de points pour obtenir le nombre de                         segments, car le point initial d'un contour est compte deux fois 
            nb_p:=nb_p+integer(length(L))-1;  
            
            next(cc);
         
      end loop;
      
      put(f_out,nb_p);
      New_line(f_out);
            
      --ecritue du nombre de segments apres une simplification de distance seuil 1
      ccs:=first(ES1);
      nb_p:=0;
      
      while ccs /= liste_contour_bezier3.no_element loop --parcours de la liste de contour
            
            S:=element(ccs);
             
            nb_p:=nb_p+integer(length(S));  
            
            next(ccs);
         
      end loop;
      
      put(f_out,nb_p);
      New_line(f_out);      
      
   end ecrire_info_bezier3;

end simplification;










































