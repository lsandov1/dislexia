BEGIN {
	# Default matches
	DC1="[ABC]"         # Criterio: Área que incluye cada AOI
	DC2="[pn]"          # Criterio: Tipo de estímulo
	DC3="[[:digit:]]+"  # Criterio: Pantalla o diapositiva en la que está la AOI
	DC4="s[1-6]"        # Criterio: Estructura silábica implicada en la AOI
	DC5="(dx|d[1-8])"   # Criterio: Densidad de consonantes de la palabra en
	                    #           la que está la AOI
	DC6="L[4-8]"        # Criterio: Longitud de la palabra en la que está
	                    #           la AOI según el número de letras que tiene
	                    #           la palabra
	DC7="c[1-7]"        # Criterio: Complejidad léxico silábica del Dr. Leal
	DC8="(t|b)"         # Criterio: Número de sílabas que tiene la palabra en
	                    #           la que está la AOI
	DC9="[0-3]"         #Criterio: Lugar que ocupa la sílaba meta en la palabra

	# Relevant TOBBI fields names
	TIMESTAMP=1
	FIXATION_INDEX=19
	FIXATION_MAPPED_POINT_X=33
	FIXATION_MAPPED_POINT_Y=34
	FIXATION_DURATION=35
	AOI=37

}
