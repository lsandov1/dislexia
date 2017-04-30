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
	DC9="([0-3]|-)"         #Criterio: Lugar que ocupa la sílaba meta en la palabra

	# Relevant TOBBI fields names
	FIX_AOI=37
	FIX_TIMESTAMP=1
	FIX_INDEX=19
	FIX_X=33
	FIX_Y=34
	FIX_DURATION=35

	# Defines slides and lines numbers for AOI
	# Interpretation:
	# AOI_SLIDE_LINE[max aoi number] = [slide, line]
	#
	AOI_SLIDE_LINE[10] = "9:1"
	AOI_SLIDE_LINE[20] = "9:2"
	AOI_SLIDE_LINE[30] = "9:3"
	AOI_SLIDE_LINE[38] = "9:4"

	AOI_SLIDE_LINE[49] = "11:1"
	AOI_SLIDE_LINE[59] = "11:2"
	AOI_SLIDE_LINE[71] = "11:3"
	AOI_SLIDE_LINE[79] = "11:4"

	AOI_SLIDE_LINE[88] =  "13:1"
	AOI_SLIDE_LINE[98] =  "13:2"
	AOI_SLIDE_LINE[111] = "13:3"
	AOI_SLIDE_LINE[119] = "13:4"

	AOI_SLIDE_LINE[129] = "15:1"
	AOI_SLIDE_LINE[139] = "15:2"
	AOI_SLIDE_LINE[149] = "15:3"
	AOI_SLIDE_LINE[156] = "15:4"

	AOI_SLIDE_LINE[166] = "17:1"
	AOI_SLIDE_LINE[176] = "17:2"
	AOI_SLIDE_LINE[186] = "17:3"
	AOI_SLIDE_LINE[196] = "17:4"

	AOI_SLIDE_LINE[205] = "19:1"
	AOI_SLIDE_LINE[216] = "19:2"
	AOI_SLIDE_LINE[227] = "19:3"
	AOI_SLIDE_LINE[236] = "19:4"

	AOI_SLIDE_LINE[245] = "21:1"
	AOI_SLIDE_LINE[258] = "21:2"
	AOI_SLIDE_LINE[270] = "21:3"
	AOI_SLIDE_LINE[280] = "21:4"

	AOI_SLIDE_LINE[291] = "23:1"
	AOI_SLIDE_LINE[301] = "23:2"
	AOI_SLIDE_LINE[310] = "23:3"
	AOI_SLIDE_LINE[319] = "23:4"

	AOI_SLIDE_LINE[328] = "25:1"
	AOI_SLIDE_LINE[339] = "25:2"
	AOI_SLIDE_LINE[347] = "25:3"
	AOI_SLIDE_LINE[355] = "25:4"

	AOI_SLIDE_LINE[364] = "27:1"
	AOI_SLIDE_LINE[375] = "27:2"
	AOI_SLIDE_LINE[385] = "27:3"
	AOI_SLIDE_LINE[393] = "27:4"
}
