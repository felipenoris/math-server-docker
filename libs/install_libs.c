#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

// gcc -o install_libs install_libs.c -lpthread
// http://gribblelab.org/CBootcamp/A2_Parallel_Programming_in_C.html

#define NTHREADS 3

int python2_result = 0;
int python3_result = 0;
int julia_result = 0;
int R_result = 0;

void *libs_python(void *x)
{
  int tid;
  tid = *((int *) x);
  printf("Thread %d: installing Python2 libs...\n", tid);
  python2_result = system("source ./libs_python2.sh");

  printf("Thread %d: installing Python3 libs...\n", tid);
  python3_result = system("source ./libs_python3.sh");
  return NULL;
}

void *libs_julia(void *x)
{
  int tid;
  tid = *((int *) x);
  printf("Thread %d: installing Julia libs...\n", tid);
  julia_result = system("source ./libs_julia.sh");
  return NULL;
}

void *libs_R(void *x)
{
  int tid;
  tid = *((int *) x);
  printf("Thread %d: installing R libs...\n", tid);
  R_result = system("source ./libs_R.sh");
  return NULL;
}

int main(int argc, char *argv[])
{
  pthread_t threads[NTHREADS];
  int thread_args[NTHREADS] = {1, 2, 3};
  int rc, i;

  rc = pthread_create(&threads[0], NULL, libs_python, (void *) &thread_args[0]);
  rc = pthread_create(&threads[1], NULL, libs_julia, (void *) &thread_args[1]);
  rc = pthread_create(&threads[2], NULL, libs_R, (void *) &thread_args[2]);

  /* wait for threads to finish */
  for (i=0; i<NTHREADS; ++i) {
    rc = pthread_join(threads[i], NULL);
  }

  return python2_result + python3_result + julia_result + R_result;
}
