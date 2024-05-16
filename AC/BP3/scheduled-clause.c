#include <stdio.h>
#include <stdlib.h>

#ifdef _OPENMP
#include <omp.h>
#else
#define omp_get_thread_num() 0
#endif

int main(int argc, char **argv) {
  int i, n = 200, chunk, a[n], suma = 0;
  int dynamic, nthreads, threadlimit, modifier;

  if (argc < 3) {
    fprintf(stderr, "\nFalta iteraciones o chunk\n");
    exit(-1);
  }

  n = atoi(argv[1]);
  if (n > 200)
    n = 200;

  chunk = atoi(argv[2]);

  for (i = 0; i < n; i++)
    a[i] = i;

#pragma omp parallel for firstprivate(suma) lastprivate(suma)                  \
    schedule(dynamic, chunk)
  for (i = 0; i < n; i++) {

    if (i == 0) {
      omp_sched_t kind;
      omp_get_schedule(&kind, &modifier);
      printf("ANTES DE MODIFICAR \n");
      printf("Dinámica : %d\n", omp_get_dynamic());
      printf("numero de threads: %d\n", omp_get_max_threads());
      printf("Límite de threads: %d\n", omp_get_thread_limit());
      printf("Tipo  (Static 1, Dynamic 2, Guided 3): %d\n", kind);
      printf("Chunk: %d\n\n", modifier);
      omp_set_dynamic(5);
      omp_set_num_threads(4);
      omp_set_schedule(3, 2);
      omp_get_schedule(&kind, &modifier);

      printf("DESPUÉS DE MODIFICAR \n");
      printf("Dinámica : %d\n", omp_get_dynamic());
      printf("numero de threads: %d\n", omp_get_max_threads());
      printf("Límite de threads: %d\n", omp_get_thread_limit());
      printf("Tipo  (Static 1, Dynamic 2, Guided 3): %d\n", kind);
      printf("Chunk: %d\n\n", modifier);
    }

    suma = suma + a[i];
  }

  printf("Fuera de 'parallel for' \n");
  omp_sched_t kind;
  omp_get_schedule(&kind, &modifier);
  printf("ANTES DE MODIFICAR \n");
  printf("Dinámica : %d\n", omp_get_dynamic());
  printf("numero de threads: %d\n", omp_get_max_threads());
  printf("Límite de threads: %d\n", omp_get_thread_limit());
  printf("Tipo  (Static 1, Dynamic 2, Guided 3): %d\n", kind);
  printf("Chunk: %d\n\n", modifier);
  omp_set_dynamic(3);
  omp_set_num_threads(5);
  omp_set_schedule(1, 1);
  omp_get_schedule(&kind, &modifier);

  printf("DESPUÉS DE MODIFICAR \n");
  printf("Dinámica : %d\n", omp_get_dynamic());
  printf("numero de threads: %d\n", omp_get_max_threads());
  printf("Límite de threads: %d\n", omp_get_thread_limit());
  printf("Tipo  (Static 1, Dynamic 2, Guided 3): %d\n", kind);
  printf("Chunk: %d\n\n", modifier);
}
