#include <iostream>
#include "ap_axi_sdata.h"
//#############################################################################################
//#############################################################################################
//#
//#   The MIT License (MIT)
//#   
//#   Copyright (c) 2023 http://odelay.io 
//#   
//#   Permission is hereby granted, free of charge, to any person obtaining a copy
//#   of this software and associated documentation files (the "Software"), to deal
//#   in the Software without restriction, including without limitation the rights
//#   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//#   copies of the Software, and to permit persons to whom the Software is
//#   furnished to do so, subject to the following conditions:
//#   
//#   The above copyright notice and this permission notice shall be included in all
//#   copies or substantial portions of the Software.
//#   
//#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//#   SOFTWARE.
//#   
//#   Contact : <everett@odelay.io>
//#  
//#   Description : Xilinx Vitis HLS Fixed Gain Block for AXI Stream Interface
//#
//#   Version History:
//#   
//#       Date        Description
//#     -----------   -----------------------------------------------------------------------
//#      2023-04-18    Original Creation
//#
//###########################################################################################





#include "hls_stream.h"
using namespace std;

#define DWIDTH 32
#define type ap_int<DWIDTH>
typedef hls::axis<type, 0, 0, 0> pkt;

void fixed_gain_stream(hls::stream<pkt> &A, hls::stream<pkt> &B, int gain);
int main()
{
  int a_in=101;
  int gain=23;
  hls::stream<pkt> A, B;
  pkt tmp1, tmp2;
  tmp1.data = a_in;

  printf("\n\n\n\n");
  printf("HLS AXI-Stream Fixed Gain Stream\n");
  printf("Function b += a * gain\n");
  printf("Initial values a = %d, gain = %d\n",a_in,gain);
 
  A.write(tmp1);
  fixed_gain_stream(A,B,gain);
  B.read(tmp2);

  printf("HW Result = %d\n",tmp2.data);
  printf("\n\n\n\n");


  if (tmp2.data != a_in*gain)
  {
    cout << "ERROR: results mismatch" << endl;
    return 1;
  }
  else
  {
    cout << "Success: results match" << endl;
    return 0;
  }
}

