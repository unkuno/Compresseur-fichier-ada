
CFLAGS =  -g  # A decommenter si necessaire // Non ça va merci!!!

SRC_PACKAGES = dico.ads dico.adb \
               code.ads code.adb \
               file_priorite.ads file_priorite.adb \
               arbre_huffman.ads arbre_huffman.adb

EXE = tp_huffman


all: $(EXE) clean

tp_huffman: tp_huffman.adb $(SRC_PACKAGES)
	gnatmake $(CFLAGS) $@

test: all cleantxt
	$(MAKE) -C Tests 

clean:
	gnatclean -c *
	rm -f b~* ~*
	rm -f *~

cleantxt:
	rm -f Tests/*.txt.*

cleanall: clean cleantxt
	rm -f $(EXE)

