int transicio ( int estat, char simbol ) {
	int proxim_estat;
	if ( (estat == 0) && (simbol == 'b') ) proxim_estat = 0;
	if ( (estat == 0) && (simbol == 'a') ) proxim_estat = 1;
	if ( (estat == 1) && (simbol == 'b') ) proxim_estat = 1;
	if ( (estat == 1) && (simbol == 'a') ) proxim_estat = 0;
	if ( (estat == 1) && (simbol == 'a') ) proxim_estat = 3;
	return proxim_estat;
}
1