#############################################################################
# Fichier Makefile - MAP244 - 2011-2012
#############################################################################
# utilisation des variables internes $< $@ $*
# $@ : correspond au nom de la cible
# $< : correspond au nom de la premiere dependance
# $* : correspond au nom du fichier sans extension 
#       (dans les regles generiques uniquement)
#############################################################################
# information sur la regle executee avec la commande @echo
# (une commande commancant par @ n'est pas affichee a l'ecran)
#############################################################################


#############################################################################
# definition des variables locales
#############################################################################

# chemin d'acces aux librairies (interfaces)
INCDIR = .

# chemin d'acces aux librairies (binaires)
LIBDIR = .

# options pour l'édition des liens
GNATLDOPTS = -L$(LIBDIR)

# options pour la recherche des fichiers .ali et .ads
INCLUDEOPTS = -I$(INCDIR)

# options de compilation
COMPILOPTS = -g $(INCLUDEOPTS)

# liste des executables
EXECUTABLES =  test_simplification test_simplification_bezier2 test_simplification_bezier3


#############################################################################
# definition des regles
#############################################################################

########################################################
# la règle par défaut
all : $(EXECUTABLES)

########################################################
# regle generique : 
#  remplace les regles de compilation separee de la forme
#	module.ali : module.adb module.ads
#		gnat compile -c $(COMPILOPTS) module.adb
%.ali : %.adb %.ads
	@echo ""
	@echo "---------------------------------------------"
	@echo "Compilation du paquetage "$*
	@echo "---------------------------------------------"
	gnat compile -c $(COMPILOPTS) $<

########################################################
# regles explicites de compilation separee de modules
# n'ayant pas de fichier .ads ET/OU dependant d'autres paquetages	
	
contour.ali : contour.adb image_pbm.ali geom2d.ali 
	@echo ""
	@echo "---------------------------------------------"
	@echo "Compilation de la procedure contour"
	@echo "---------------------------------------------"
	gnat compile -c $(COMPILOPTS) $<

simplification.ali : simplification.adb fichier_eps.ali contour.ali geom2d.ali 
	@echo ""
	@echo "---------------------------------------------"
	@echo "Compilation de la procedure simplification"
	@echo "---------------------------------------------"
	gnat compile -c $(COMPILOPTS) $<
	
fichier_eps.ali : fichier_eps.adb contour.ali image_pbm.ali geom2d.ali 
	@echo ""
	@echo "---------------------------------------------"
	@echo "Compilation de la procedure fichier_eps"
	@echo "---------------------------------------------"
	gnat compile -c $(COMPILOPTS) $<
        
image_pbm.ali : image_pbm.adb geom2d.ali 
	@echo ""
	@echo "---------------------------------------------"
	@echo "Compilation de la procedure image_pbm"
	@echo "---------------------------------------------"
	gnat compile -c $(COMPILOPTS) $<


test_simplification.ali : test_simplification.adb fichier_eps.ali image_pbm.ali contour.ali geom2d.ali simplification.ali
	@echo ""
	@echo "---------------------------------------------"
	@echo "Compilation de la procedure test_simplification"
	@echo "---------------------------------------------"
	gnat compile -c $(COMPILOPTS) $<
 
test_simplification_bezier2.ali : test_simplification_bezier2.adb fichier_eps.ali image_pbm.ali contour.ali geom2d.ali simplification.ali
	@echo ""
	@echo "---------------------------------------------"
	@echo "Compilation de la procedure test_simplification_bezier2"
	@echo "---------------------------------------------"
	gnat compile -c $(COMPILOPTS) $<        
		
test_simplification_bezier3.ali : test_simplification_bezier3.adb fichier_eps.ali image_pbm.ali contour.ali geom2d.ali simplification.ali
	@echo ""
	@echo "---------------------------------------------"
	@echo "Compilation de la procedure test_simplification_bezier3"
	@echo "---------------------------------------------"
	gnat compile -c $(COMPILOPTS) $<
########################################################
# regles explicites de creation des executables

        
test_simplification : test_simplification.ali 
	@echo ""
	@echo "---------------------------------------------"
	@echo "Creation de l'executable "$@
	@echo "---------------------------------------------"
	gnat bind -x $(COMPILOPTS) $<
	gnat link $< $(GNATLDOPTS) -o $@
        
test_simplification_bezier2 : test_simplification_bezier2.ali 
	@echo ""
	@echo "---------------------------------------------"
	@echo "Creation de l'executable "$@
	@echo "---------------------------------------------"
	gnat bind -x $(COMPILOPTS) $<
	gnat link $< $(GNATLDOPTS) -o $@ 

test_simplification_bezier3 : test_simplification_bezier3.ali 
	@echo ""
	@echo "---------------------------------------------"
	@echo "Creation de l'executable "$@
	@echo "---------------------------------------------"
	gnat bind -x $(COMPILOPTS) $<
	gnat link $< $(GNATLDOPTS) -o $@         

# regle pour "nettoyer" le répertoire
clean:
	rm -fR $(EXECUTABLES) *.o *.ali b~*
