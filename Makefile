# -*- Makefile -*-

TOPDIR := $(shell pwd)

FC       = gfortran
OPTIM    = -g -C

FITSDIR  = -L/usr/lib -lcfitsio      # Directory containing libcfitsio.a
LAPACK   = -L/usr/lib -llapack -lblas
HEALPIX  = -L/usr/local/src/Healpix_3.50/lib -lhealpix
HEALINC  = -I/usr/local/src/Healpix_3.50/include
INCOTHER = -I$(TOPDIR)/include

OUTPUT  = map_editor
FFLAGS  = $(HEALPIX) $(LAPACK) -fopenmp

F90COMP = $(FC) $(OPTIM) $(INCOTHER) $(HEALINC)

# map_editor objects
COBJS   = sort_utils.o math_tools.o spline_1D_mod.o spline_2D_mod.o \
          powell_mod.o map_editor_utils.o \
          map_editor_simple_ops_mod.o map_editor_complex_ops_mod.o 

map_editor : libmap_editor.a map_editor.o
	$(FC) $(FFLAGS) -o $(OUTPUT) map_editor.o libmap_editor.a $(LAPACK) $(HEALPIX) $(FITSDIR)

map_editor_complex_ops_mod.o : map_editor_utils.o 

libmap_editor.a : $(COBJS)
	ar rcs libmap_editor.a $(COBJS)
	ranlib libmap_editor.a

%.o : %.F90
	$(F90COMP) -c $<

%.o : %.f90
	$(F90COMP) -c $<

clean:
	@rm -f *.o *.mod *.MOD *~ map_editor	
