int * transicio ( int estat, char simbol ) {
	static int proxim_estat[NUM_ESTATS+1], n=0;
	if ( (estat == 0) && (simbol == 'b') ) proxim_estat[n++] = 0;
	if ( (estat == 0) && (simbol == 'a') ) proxim_estat[n++] = 1;
	if ( (estat == 1) && (simbol == 'b') ) proxim_estat[n++] = 1;
	if ( (estat == 1) && (simbol == 'a') ) proxim_estat[n++] = 0;
	if ( (estat == 1) && (simbol == 'a') ) proxim_estat[n++] = 3;
	if ( (estat == 1) && (simbol == 'd') ) proxim_estat[n++] = 0;
