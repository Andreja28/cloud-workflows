/*
 * PI.c
 * Izracunavanje broja PI pomocu odredjenog integrala(od 0 do 1) funkcije 4.0 / (1.0 + x*x)
 *  Created on: Aug 20, 2010
 *      Author: djordje
 */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
double f( double );
double f( double a )
{
    return (4.0 / (1.0 + a*a));
}
int main( int argc, char *argv[])
{
  int n_intervals;// = 100000000;
  int n, myid, numprocs, i;
  double PI25DT = 3.141592653589793238462643;
  double mypi, pi, h, sum, x;
  double startwtime = 0.0, endwtime;
  int  namelen;

  double sumI;
  FILE* fl = fopen(argv[1], "r");

  fscanf(fl,"%d", &n_intervals);
  printf("%d\n", n_intervals);
  n = n_intervals;
  h   = 1.0 / (double) n;
  sum = 0.0;
  for (i = 0; i < n; i++)
  {
      x = h * ((double)i - 0.5);
      sum += f(x);
  }
  mypi = h * sum;
  
  printf("pi is approximately %.16f\n", mypi);
  return 0;
}