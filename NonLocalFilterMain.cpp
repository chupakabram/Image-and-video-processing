// NonLocalFilterMain.cpp : Defines the entry point for the console application.
//
 
#include <fstream>
#include <iostream>
#include <cwchar>
#include <string>

#include "NonLocalFilter.hpp"



/*
Example of data format: 2 rows, 4 columns, 3 channels

2 4 3

1 2 3 4
5 6 7 8

5 6 7 8
9 8 7 6


1 2 3 4
5 6 7 8


*/






int wmain(int argc, wchar_t* argv[])
{
   if (argc < 4)
   {
   }
   else
   {
      std::wstring inFileName = argv[1];
      std::wstring outFileName = argv[2];
      float sigma = (float)std::wcstod(argv[3], NULL);
      
      std::ifstream inD = std::ifstream();
      inD.open(inFileName, std::ifstream::in);

      int rows, columns, channels;
      inD >> rows;
      inD >> columns;
      inD >> channels;
      float ***pInput = new float**[rows];
      float ***pOutput = new float**[rows];

      for (int ii=0; ii<rows; ++ii)
      {
         pInput[ii] = new float *[columns];
         pOutput[ii] = new float *[columns];
         for (int jj = 0; jj<columns; ++jj)
         {
            pInput[ii][jj] = new float[channels];
            pOutput[ii][jj] = new float[channels];
         }
      }
            
      for (int kk=0; kk<channels; ++kk)
         for (int ii=0; ii<rows; ++ii)
            for (int jj = 0; jj<columns;++jj)
               inD >> pInput[ii][jj][kk];

      inD.close();

      // Data is read
      
      NLF(pInput, pOutput, rows, columns, channels, sigma);


      std::ofstream outD = std::ofstream();
      outD.open(outFileName, std::ofstream::out);
      outD << rows << " " << columns << " " << channels << std::endl;
      for (int kk=0; kk<channels; ++kk)
      {
         for (int ii=0; ii<rows; ++ii)
         {
            for (int jj = 0; jj<columns; ++jj)
            {
               outD << pOutput[ii][jj][kk] << " ";
            }
            outD << std::endl;
         }
         outD << std::endl;
      }
      outD.close();

      for (int ii=0; ii<rows; ++ii)
      {
         for (int jj = 0; jj<columns; ++jj)
         {
            delete [] pInput[ii][jj];
            delete [] pOutput[ii][jj];
         }
         delete [] pInput[ii];
         delete [] pOutput[ii];
      }
      delete [] pInput;
      delete [] pOutput;
   }

	return 0;
}

