// Header file for NonLocalFilter function implementation 
 
#ifndef NON_LOCAL_FILTER___H
#define NON_LOCAL_FILTER___H

//
// http://www.ipol.im/pub/art/2011/bcm_nlm/
//


#include <cmath>
#include <iostream>

void NLF(float ** imIn[], float ** imOut [], int rows, int columns, int channels, float noiseSigma)
{
   float h, h2; 
   int patch_r, research_r; 

/*
for Gray
sigma	           Comp. Patch	  Res. Block	    h
0 <  sigma <= 15	   3 x 3	       21 x 21	   0.40 sigma
15 < sigma <= 30	   5 x 5	       21 x 21	   0.40 sigma
30 < sigma <= 45	   7 x 7	       35 x 35	   0.35 sigma
45 < sigma <= 75	   9 x 9	       35 x 35	   0.35 sigma
75 < sigma <= 100	  11 x 11	    35 x 35	   0.30 sigma
*/

   if (noiseSigma > 0 && noiseSigma <= 15.0)
   {
      patch_r = 1;
      research_r = 10;
      h = (float) 0.4*noiseSigma;
   }else if (noiseSigma > 15.0 && noiseSigma <= 30.0)
   {
      patch_r = 2;
      research_r = 10;
      h = (float) 0.4*noiseSigma;
   }else if (noiseSigma > 30.0 && noiseSigma <= 45.0)
   {
      patch_r = 3;
      research_r = 17;
      h = (float) 0.35*noiseSigma;
   }else if (noiseSigma > 45.0 && noiseSigma <= 75.0)
   {
      patch_r = 4;
      research_r = 17;
      h = (float) 0.35*noiseSigma;
   }else{
      patch_r = 5;
      research_r = 17;
      h =(float) 0.3*noiseSigma;
   }

   h2 = h*h;
   float wpq;
   float twoSigma2 = 2*noiseSigma*noiseSigma;

   for (int pi=0; pi<rows; ++pi)
   {
      // calculate rows of research neighbourhood
      int rs = ((pi-research_r) < 0) ? 0 : (pi-research_r);
      int re = ((pi+research_r) >= rows) ? rows: (pi+research_r+1);
      for (int pj=0; pj<columns; ++pj)
      {
         // calculate columns of research neighbourhood
         int cs = ((pj-research_r) < 0)? 0 : (pj-research_r);
         int ce = ((pj+research_r) >= columns)? columns : (pj+research_r+1);

         // start calculate new value for point (pi,pj)
         float CpIrJc = 0.0;
         for (int pk=0; pk<channels; ++pk)
            imOut[pi][pj][pk] = (float)0.0;

         for (int qi=rs; qi<re; ++qi)
         {
            // calculate boundaries for patch neighbourhood
            int rfs = (-1)*((pi-patch_r < 0 || qi-patch_r < 0)? std::min(pi,qi): patch_r);  
            int rfe = ((pi+patch_r >= rows || qi+patch_r >= rows) ? std::min(rows-pi,rows-qi)-1: patch_r);  
            for (int qj=cs; qj<ce; ++qj)
            {
               // calculate boundaries for patch neighbourhood
               int cfs = (-1)*((pj-patch_r < 0 || qj-patch_r < 0)? std::min(pj,qj): patch_r);  
               int cfe = ((pj+patch_r >= columns || qj+patch_r >= columns) ? std::min(columns-pj,columns-qj)-1: patch_r);


               int nnn = (rfe-rfs+1)*(cfe-cfs+1)*channels; 
               float d2pq = 0;
               float d = 0;

               if (false)
                  std::wcout << L"p=[" << pi << L"," << pj << L"], q=[" << qi << L"," << qj << L"] , " <<
                           L"(" << pi+rfs << L":" << pi+rfe << L"," << pj+cfs << L":" << pj+cfe << L") vs (" << 
                                   qi+rfs << L":" << qi+rfe << L"," << qj+cfs << L":" << qj+cfe << L")" << std::endl;


               for (int fcn=0; fcn<channels; ++fcn)
                  for (int fsi=rfs; fsi<=rfe; ++fsi)
                     for (int fsj=cfs; fsj<=cfe; ++fsj)
                     {
                        d = imIn[pi+fsi][pj+fsj][fcn] - imIn[qi+fsi][qj+fsj][fcn];
                        d2pq += d*d;
                     }

               d2pq = d2pq/nnn;

               // calculate weight function for pair (p,q) 
               wpq = std::exp(-1*(std::max((float)(d2pq-twoSigma2),(float)0.0))/h2);
          
               CpIrJc = CpIrJc + wpq; 

               for (int cn=0; cn<channels; ++cn)
                 imOut[pi][pj][cn] = imOut[pi][pj][cn]  + (imIn[qi][qj][cn])*wpq;
            
            }
         }

         for (int cn=0; cn<channels; ++cn)
            imOut[pi][pj][cn] = imOut[pi][pj][cn]/CpIrJc;

      }
   }


};

#endif /// NON_LOCAL_FILTER___H

